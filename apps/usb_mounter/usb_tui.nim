# nim c -r usb_tui.nim
# Interactive USB mounter — terminal menu, no external dependencies.
# Uses std/terminal for colors, execCmdEx for system commands.
import std/[os, osproc, strutils, terminal]

const MOUNT_POINT = "/media/nim_usb"

# ── Helpers ──────────────────────────────────────────────────────────────

proc runCommand(cmd: string): tuple[output: string, exitCode: int] =
  execCmdEx(cmd)

proc waitForKey() =
  stdout.styledWrite(fgCyan, "\nPress Enter to continue...")
  stdout.flushFile()
  discard readLine(stdin)

# ── Core operations ──────────────────────────────────────────────────────

proc doMount(device: string): string =
  if device == "":
    return "Error: Please specify a device (e.g., /dev/sdb1)"

  let (_, checkCode) = runCommand("test -b " & quoteShell(device))
  if checkCode != 0:
    return "Error: " & device & " does not exist or is not a valid block device."

  if not dirExists(MOUNT_POINT):
    let (err, code) = runCommand("sudo mkdir -p " & quoteShell(MOUNT_POINT))
    if code != 0:
      return "Failed to create mount point: " & err

  let (output, exitCode) = runCommand("sudo mount " & quoteShell(device) & " " &
      quoteShell(MOUNT_POINT))
  if exitCode == 0:
    let (lsOutput, _) = runCommand("stat " & quoteShell(MOUNT_POINT))
    return "USB successfully mounted at " & MOUNT_POINT & "!\n" & lsOutput
  else:
    var msg = "Mount failed: " & output
    let (fsType, _) = runCommand("sudo blkid -o value -s TYPE " & quoteShell(device))
    let fs = fsType.strip()
    if fs != "":
      msg.add("\nDetected filesystem: " & fs)
      if fs == "ntfs":
        msg.add("\nTry: sudo mount -t ntfs-3g " & device & " " & MOUNT_POINT)
      elif fs == "exfat":
        msg.add("\nTry: sudo mount -t exfat " & device & " " & MOUNT_POINT)
      elif fs == "ext4":
        msg.add("\nTry: sudo mount -t ext4 " & device & " " & MOUNT_POINT)
    else:
      msg.add("\nTry specifying the filesystem type manually: sudo mount -t <type> " &
          device & " " & MOUNT_POINT)
    return msg

proc doUmount(device: string): string =
  let target = if device == "": MOUNT_POINT else: device
  let (output, exitCode) = runCommand("sudo umount " & quoteShell(target))
  if exitCode == 0:
    return "USB successfully unmounted!"
  else:
    return output & "\nTry forcing unmount: sudo umount -l " & target

proc listDevices(): string =
  let (outp, _) = runCommand("lsblk -o NAME,RM,SIZE,TYPE,MOUNTPOINT | grep ' 1 '")
  return if outp.strip() == "": "No removable devices found." else: outp

# ── Terminal UI ──────────────────────────────────────────────────────────

proc showHeader(title: string) =
  styledEcho fgCyan, styleBright, "\n╔══════════════════════════════════════╗"
  styledEcho fgCyan, styleBright, "║  ", title, "  ║"
  styledEcho fgCyan, styleBright, "╚══════════════════════════════════════╝"

proc mountDevice() =
  showHeader("Mount USB Device")
  styledEcho fgYellow, "Available devices:"
  echo ""
  echo listDevices()
  echo ""
  stdout.styledWrite(fgGreen, "Enter device (e.g., /dev/sdb1): ")
  stdout.flushFile()
  let dev = readLine(stdin).strip()
  if dev != "":
    echo ""
    styledEcho fgCyan, doMount(dev)

proc unmountDevice() =
  showHeader("Unmount Device")
  let (mountOut, _) = runCommand("mount | grep " & quoteShell(MOUNT_POINT))
  if mountOut.strip() == "":
    styledEcho fgYellow, "No devices currently mounted at ", MOUNT_POINT, "."
  else:
    echo mountOut
    echo ""
    stdout.styledWrite(fgGreen, "Device or mountpoint (empty for default): ")
    stdout.flushFile()
    let dev = readLine(stdin).strip()
    echo ""
    styledEcho fgCyan, doUmount(dev)

proc listDevicesMenu() =
  showHeader("Block Devices")
  echo ""
  echo listDevices()

proc showHelp() =
  showHeader("USB Mounter — Help")
  echo ""
  styledEcho fgWhite, """FEATURES:
  1. Mount       — Mount a USB device to """ & MOUNT_POINT & """
  2. Unmount     — Unmount the mounted device
  3. List Devices— Show removable block devices
  4. Help        — Show this screen
  5. Exit

USAGE:
  - Must be run as root.
  - Only ONE USB device can be mounted at a time.
  - Use 'List Devices' to identify your USB (e.g., /dev/sdb1).
  - Supported filesystems: ext4, ntfs, exfat, and more."""

proc mainMenu() =
  let (outp, _) = runCommand("whoami")
  if outp.strip() != "root":
    styledEcho fgRed, styleBright, "Error: Run as root!"
    quit(1)

  while true:
    showHeader("USB Mounter")
    styledEcho fgGreen,  "  1. Mount USB Device"
    styledEcho fgRed,    "  2. Unmount Device"
    styledEcho fgYellow, "  3. List Block Devices"
    styledEcho fgCyan,   "  4. Help"
    styledEcho fgWhite,  "  5. Exit"
    echo ""
    stdout.styledWrite(fgGreen, "Option: ")
    stdout.flushFile()
    let choice = readLine(stdin).strip()

    case choice
    of "1": mountDevice()
    of "2": unmountDevice()
    of "3": listDevicesMenu()
    of "4": showHelp()
    of "5":
      styledEcho fgGreen, "\nGoodbye!"
      quit(0)
    else:
      styledEcho fgRed, "Invalid option. Choose 1-5."

    waitForKey()

when isMainModule:
  mainMenu()
