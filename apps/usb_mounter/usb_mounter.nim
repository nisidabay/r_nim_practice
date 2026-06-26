# Fused USB Mounter — CLI mode + Interactive TUI
#
# Features:
# - Mount a block device with a usb label under /media/nim_usb/<label>
# - Unmount a device and remove the label directory
# - CLI mode (args provided): mount <device>, umount <device>, list
# - Interactive mode (no args): terminal menu using std/terminal
# - Filesystem type detection and troubleshooting hints
# - Safe use of shell quoting to prevent injection
#
# NOTE: Must run as root. Use the usb_mounter.sh wrapper in ~/bin.
#
import std/[os, osproc, strutils, terminal]

const MOUNT_POINT = "/media/nim_usb"

var labels: seq[tuple[device, label: string]] = @[]


# --- Helpers ---------------------------------------------------------------

proc runCommand(cmd: string): tuple[output: string, exitCode: int] =
  execCmdEx(cmd)

proc isBlockDevice(device: string): bool =
  let (_, exitCode) = runCommand("test -b " & quoteShell(device))
  if exitCode != 0:
    styledEcho fgRed, styleBright, "[ERROR]: ", fgWhite,
        device & " does not exist or is not a valid block device!"
    return false
  return true

proc getFileSystemType(device: string): string =
  let (fsType, _) = runCommand("blkid -o value -s TYPE " & quoteShell(device))
  result = fsType.strip()

proc checkMountPoint() =
  ## Create the mount point directory if it does not exist and set permissions.
  if not dirExists(MOUNT_POINT):
    styledEcho fgBlue, styleBright, "[INFO]: ", fgWhite,
        "Creating mount point: " & MOUNT_POINT

    let (mkdirOut, mkdirCode) =
      runCommand("mkdir -p " & quoteShell(MOUNT_POINT))
    if mkdirCode != 0:
      styledEcho fgRed, styleBright, "[ERROR]: ", fgWhite,
          "Failed to create mount point: " & mkdirOut
      quit(1)

    var (permErr, chmodCode) =
      runCommand("chmod -R 775 " & quoteShell(MOUNT_POINT))
    if chmodCode != 0:
      styledEcho fgRed, styleBright, "[ERROR]: ", fgWhite,
          "Failed to change permissions at mount point: " & permErr
      quit(1)

    (permErr, chmodCode) =
      runCommand("chmod -R users " & quoteShell(MOUNT_POINT))
    if chmodCode != 0:
      styledEcho fgRed, styleBright, "[ERROR]: ", fgWhite,
          "Failed to change group user at mount point: " & permErr
      quit(1)

proc listDevices(): string =
  ## Return removable block devices (RM=1, excluding CD-ROM).
  let (outp, _) = runCommand(
    "lsblk -o NAME,RM,SIZE,TYPE,MOUNTPOINT | grep ' 1 ' | grep -v 'rom'")
  result = if outp.strip() == "": "No removable devices found." else: outp

proc listAllRemovableDevices() =
  ## Print all removable devices (for CLI "list" command and menu option 3).
  echo listDevices()

proc listAvailableDevicesToMount() =
  ## Print removable devices NOT already mounted at MOUNT_POINT.
  let cmd = "lsblk -o NAME,RM,SIZE,TYPE,MOUNTPOINT | grep ' 1 ' | grep -v 'rom' | grep -v " &
      MOUNT_POINT
  let (lsblkOut, _) = runCommand(cmd)
  echo lsblkOut

proc troubleshootMountFailure(device: string) =
  let fs = getFileSystemType(device)
  if fs != "":
    styledEcho fgYellow, styleBright, "Detected filesystem: ",
        fgCyan, styleBright, fs
    styledEcho fgGreen, styleBright, "Suggestion: "
    if fs == "ntfs":
      styledEcho fgWhite, "Try: mount -t ntfs-3g " & device & " " & MOUNT_POINT
    elif fs == "exfat":
      styledEcho fgWhite, "Try: mount -t exfat " & device & " " & MOUNT_POINT
    elif fs == "ext4":
      styledEcho fgWhite, "Try: mount -t ext4 " & device & " " & MOUNT_POINT
    else:
      styledEcho fgWhite, "Try specifying the filesystem type: mount -t <type> " &
          device & " " & MOUNT_POINT
  else:
    styledEcho fgRed, "Could not detect filesystem type."
    styledEcho fgGreen, styleBright, "Suggestion: ",
        fgWhite, "Try specifying the filesystem type manually: mount -t <type> " &
        device & " " & MOUNT_POINT
  quit(1)


# --- Label management ------------------------------------------------------

proc getDeviceLabel(target: string): string =
  for item in labels:
    if item.device == target:
      return item.label
  return ""

proc setDeviceLabel(device: string) =
  stdout.styledWrite(fgYellow, styleBright,
      "\n➜ Enter the device label to mount ")
  stdout.styledWrite(fgWhite, "(e.g., DATA, MY_USB): ")
  stdout.flushFile()

  let label = readLine(stdin).strip()
  if label != "":
    labels.add((device: device, label: label))
    let usbMountPoint = MOUNT_POINT / label
    createDir(usbMountPoint)

    styledEcho fgBlue, styleBright, "[INFO]: ", fgWhite,
        "Mounting " & device & " at " & usbMountPoint & "..."

    let cmd = "mount " & quoteShell(device) & " " & quoteShell(usbMountPoint)
    let (_, exitCode) = runCommand(cmd)

    if exitCode == 0:
      styledEcho fgGreen, styleBright, "✓ [SUCCESS]: ", fgWhite,
          "USB successfully mounted at " & usbMountPoint & "!"
      let (lsOutput, _) = runCommand("stat " & quoteShell(usbMountPoint))
      echo lsOutput
    else:
      styledEcho fgRed, styleBright, "[ERROR]: ", fgWhite,
          "Mount command failed."
      troubleshootMountFailure(device)
  else:
    styledEcho fgRed, styleBright, "[ERROR]: ", fgWhite,
        "Mount point creation failed."


# --- Forward declarations --------------------------------------------------

proc showHelp()

# --- Core operations -------------------------------------------------------

proc doMount(device: string) =
  if device == "":
    styledEcho fgRed, styleBright, "[ERROR]: ", fgWhite,
        "Please specify a device (e.g., /dev/sdb1)"
    showHelp()
    quit(1)

  if not isBlockDevice(device):
    styledEcho fgCyan, styleBright,
        "\n[INFO]: Available removable devices to mount:"
    listAvailableDevicesToMount()
    quit(1)

  checkMountPoint()
  setDeviceLabel(device)

proc doUmount(device: string) =
  let label = getDeviceLabel(device).strip()
  let target =
    if label != "":
      MOUNT_POINT / label
    else:
      device

  if label != "":
    styledEcho fgYellow, "Attempting to unmount labeled device at: ",
        fgCyan, styleBright, target
  else:
    styledEcho fgYellow, "Attempting to unmount raw device: ",
        fgCyan, styleBright, device

  let (output, exitCode) = execCmdEx("umount " & quoteShell(target))
  if exitCode == 0:
    styledEcho fgGreen, styleBright, "✓ [SUCCESS]: ", fgWhite,
        "USB successfully unmounted!"
    if label != "":
      let (rmOut, rmCode) = execCmdEx("rmdir " & quoteShell(target))
      if rmCode != 0:
        styledEcho fgYellow, styleBright, "[WARNING]: ", fgWhite,
            "Could not remove directory: " & target
        styledEcho fgWhite, "  Reason: " & rmOut
  else:
    styledEcho fgRed, styleBright, "[ERROR]: ", fgWhite,
        "Failed to unmount."
    echo output


# --- UI helpers ------------------------------------------------------------

proc showHeader(title: string) =
  styledEcho fgCyan, styleBright, "\n╔══════════════════════════════════════╗"
  styledEcho fgCyan, styleBright, "║  ", title, "  ║"
  styledEcho fgCyan, styleBright, "╚══════════════════════════════════════╝"

proc waitForKey() =
  stdout.styledWrite(fgCyan, "\nPress Enter to continue...")
  stdout.flushFile()
  discard readLine(stdin)

proc showHelp() =
  styledEcho fgCyan, styleBright,
      "\n╔════════════════════════════════════════════════════════════╗"
  styledEcho fgCyan, styleBright,
      "║              USB Mounter - Usage Guide                     ║"
  styledEcho fgCyan, styleBright,
      "╚════════════════════════════════════════════════════════════╝"
  echo ""
  styledEcho fgYellow, styleBright, "USAGE: ",
      fgWhite, "usb_mounter.sh [mount|umount|list] [device]"
  echo ""
  styledEcho fgGreen, "  • mount /dev/sdX  ",
      fgWhite, ": Mounts the device at: " & MOUNT_POINT
  styledEcho fgRed, "  • umount /dev/sdX ",
      fgWhite, ": Unmounts the device"
  styledEcho fgCyan, "  • list           ",
      fgWhite, " : List all removable devices"
  styledEcho fgMagenta, "  • NO ARGUMENTS    ",
      fgWhite, ": Interactive mode"
  echo ""
  styledEcho fgCyan,
      "TIP: Identify your USB device using: lsblk or sudo fdisk -l"
  echo ""


# --- Interactive mode -----------------------------------------------------

proc interactiveMode() =
  while true:
    showHeader("USB Mounter")
    styledEcho fgGreen, styleBright,  "  [1] ", fgWhite, "Mount a device"
    styledEcho fgRed, styleBright,    "  [2] ", fgWhite, "Unmount a device"
    styledEcho fgYellow, styleBright, "  [3] ", fgWhite, "List all removable devices"
    styledEcho fgCyan, styleBright,   "  [4] ", fgWhite, "Help"
    styledEcho fgMagenta, styleBright,"  [5] ", fgWhite, "Exit"
    echo ""
    stdout.styledWrite(fgCyan, styleBright, "Option: ")
    stdout.flushFile()
    let choice = readLine(stdin).strip()

    case choice
    of "1":
      echo ""
      styledEcho fgYellow, styleBright,
          "Available devices to mount (excludes ", MOUNT_POINT, "):"
      echo ""
      listAvailableDevicesToMount()
      echo ""
      stdout.styledWrite(fgCyan, styleBright,
          "Enter the device to mount ")
      stdout.styledWrite(fgWhite, "(e.g., /dev/sdb1): ")
      stdout.flushFile()
      let dev = readLine(stdin).strip()
      if dev != "":
        doMount(dev)

    of "2":
      echo ""
      styledEcho fgYellow, styleBright, "Currently mounted devices:"
      echo ""
      let (mountedOut, _) = runCommand(
        "lsblk -o NAME,RM,SIZE,TYPE,MOUNTPOINT | grep ' 1 ' | grep -v 'rom'")
      echo mountedOut
      echo ""
      stdout.styledWrite(fgCyan, styleBright,
          "Enter device or mount point to unmount ")
      stdout.styledWrite(fgWhite, "(e.g., /dev/sdb1): ")
      stdout.flushFile()
      let devToUnmount = readLine(stdin).strip()
      doUmount(devToUnmount)

    of "3":
      echo ""
      styledEcho fgYellow, styleBright,
          "Listing ALL removable devices (excluding CD-ROM):"
      echo ""
      listAllRemovableDevices()

    of "4":
      showHelp()

    of "5":
      echo ""
      styledEcho fgGreen, styleBright, "Exiting... Goodbye!"
      echo ""
      quit(0)

    else:
      styledEcho fgRed, styleBright, "Invalid option. Choose 1-5."

    waitForKey()


# --- Main entry point ------------------------------------------------------

when isMainModule:
  # Check for root privileges
  let (who, _) = runCommand("whoami")
  if who.strip() != "root":
    styledEcho fgRed, styleBright, "[ERROR]: ", fgWhite,
        "This script must be run as root."
    styledEcho fgYellow, "Please run it with usb_mounter.sh"
    quit(1)

  let args = commandLineParams()
  if args.len == 0:
    interactiveMode()
  elif args[0].toLowerAscii() == "mount":
    doMount(if args.len > 1: args[1] else: "")
  elif args[0].toLowerAscii() == "umount":
    doUmount(if args.len > 1: args[1] else: "")
  elif args[0].toLowerAscii() == "list":
    listAllRemovableDevices()
  else:
    showHelp()
    quit(0)
