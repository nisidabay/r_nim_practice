# Navigate to project directory
cd ollama_chat

# Build both binaries
nimble build

# Or build with optimizations
nim c -d:release src/ollama_chat.nim
nim c -d:release src/web_search.nim
