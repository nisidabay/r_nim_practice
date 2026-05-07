## Vision analysis module

import std/[os, osproc, strutils, json, httpclient, base64]
import config, environment, chat

const VisionModel = "granite3.2-vision:2b"

proc checkVisionModel*(): bool =
  let (output, _) = execCmdEx("ollama list")
  return output.contains(VisionModel)

proc selectImage*(imageDir: string): string =
  ## Select an image using fzf
  let cmd = "find " & quoteShell(imageDir) &
            " -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \\) 2>/dev/null | " &
            "fzf --prompt='Image: ' --height=40% --border"
  let (output, exitCode) = execCmdEx(cmd)
  if exitCode == 0:
    result = output.strip()
  else:
    result = ""

proc isValidImage*(path: string): bool =
  let (output, _) = execCmdEx("file " & quoteShell(path))
  return output.toLowerAscii().contains("jpeg") or
         output.toLowerAscii().contains("jpg") or
         output.toLowerAscii().contains("png")

proc getImageSize*(path: string): int64 =
  try:
    result = getFileSize(path)
  except OSError:
    result = 0

proc handleVision*(cm: ChatManager) =
  # Check if vision model is available
  if not checkVisionModel():
    echo "⚠️ Vision model '" & VisionModel & "' not found."
    echo "💡 Install with: ollama pull " & VisionModel
    return

  # Select image
  let selectedFile = selectImage(cm.config.imageDir)
  if selectedFile.len == 0:
    echo "Cancelled."
    return

  # Verify it's a valid image
  if not isValidImage(selectedFile):
    echo "❌ Error: '" & extractFilename(selectedFile) & "' is not a valid image file."
    echo "💡 Please select JPG or PNG files only."
    return

  # Warn about large images
  let imageSize = getImageSize(selectedFile)
  if imageSize > 5_242_880:
    echo "⚠️ Large image (" & $(imageSize div 1_048_576) & "MB)"
    echo "💡 Resize to <5MB for better results"

  # Get user prompt
  echo ""
  stdout.write "🔎 Analyze image: "
  let userPrompt = stdin.readLine().strip()
  if userPrompt.len == 0:
    echo "Cancelled."
    return

  # Process image
  echo "🧠 Analyzing with " & VisionModel & "..."

  # Convert to base64
  let imageData = readFile(selectedFile)
  let base64Data = encode(imageData)

  # Create JSON payload
  let payload = %*{
    "model": VisionModel,
    "prompt": userPrompt,
    "images": [base64Data],
    "stream": false
  }

  # Call vision model
  try:
    let client = newHttpClient()
    client.headers = newHttpHeaders({"Content-Type": "application/json"})
    let response = client.request("http://localhost:11434/api/generate",
                                   httpMethod = HttpPost,
                                   body = $payload)

    if response.status == "200 OK":
      let jsonResponse = parseJson(response.body)
      let aiResponse = jsonResponse["response"].getStr()

      if aiResponse.len == 0 or aiResponse == "null" or aiResponse == "unanswerable":
        echo "⚠️ Vision model could not analyze the image."
        echo "💡 Tips: Use clearer images, avoid blurry/text-heavy screenshots"
      else:
        let formattedResponse = "🤖 AI (Vision): " & aiResponse
        echo "\n" & formattedResponse

        # Copy to clipboard
        cm.env.copyToClipboard(aiResponse)
        echo "📋 Response copied to clipboard."

        # Log to history
        let logPrompt = "[Image: " & extractFilename(selectedFile) & ")] " & userPrompt
        cm.appendToHistory(logPrompt, "AI (Vision): " & aiResponse)
    else:
      echo "❌ Error: " & response.status
  except:
    echo "❌ Failed to connect to Ollama API"
