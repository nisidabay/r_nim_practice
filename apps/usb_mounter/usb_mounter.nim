# Nim script to mount usbs
#
# Features:
# - Mount a block device to `/media/nim_usb` with a usb label
# - Unmount the device and remove the label
# - Interactive mode with device listing and user prompts
# - Filesystem type detection and troubleshooting hints
# - Safe use of shell quoting to prevent injection
#
# NOTE: This script must be run with root privileges for that reason I created
# a `usb_mounter.sh` script in ~/bin along with the Nim `usb_mounter` bynary.
#
import os, osproc, strutils, posix, terminal

# Default mount point for USB devices
const MOUNT_POINT = "/media/nim_usb"

# Store the usb labels
var LABELS: seq[tuple[device, label: string]] = @[]


# --- Helper & Validation Procedures ---

# Displays usage instructions and exits the program
proc showHelp() =
  stdout.styledWriteLine(fgCyan, styleBright, "\n╔════════════════════════════════════════════════════════════╗")
  stdout.styledWriteLine(fgCyan, styleBright, "║              USB Mounter - Usage Guide                     ║")
  stdout.styledWriteLine(fgCyan, styleBright, "╚════════════════════════════════════════════════════════════╝")
  echo ""
  stdout.styledWrite(fgYellow, styleBright, "USAGE: ")
  stdout.styledWriteLine(fgWhite, "usb_mounter.sh [mount|umount|list] [device]")
  echo ""
  stdout.styledWrite(fgGreen, "  • mount /dev/sdX  ")
  stdout.styledWriteLine(fgWhite, ": Mounts the device at: " & MOUNT_POINT)
  stdout.styledWrite(fgRed, "  • umount /dev/sdX ")
  stdout.styledWriteLine(fgWhite, ": Unmounts the device")
  stdout.styledWrite(fgCyan, "  • list           ")
  stdout.styledWriteLine(fgWhite, " : List all removable devices")
  stdout.styledWrite(fgMagenta, "  • NO ARGUMENTS    ")
  stdout.styledWriteLine(fgWhite, ": Interactive mode")
  echo ""
  stdout.styledWriteLine(fgCyan, "TIP: Identify your USB device using: lsblk or sudo fdisk -l")
  echo ""
  quit(0)

# Executes a shell command and returns its output and exit code
# Assumes root privileges are already acquired.
proc runCommand(cmd: string): tuple[output: string, exitCode: int] =
  execCmdEx(cmd)

# Verify that the block device exists
proc isBlockDevice(device: string): bool =
  let (_, exitCode) = runCommand("test -b " & quoteShell(device))
  if exitCode != 0:
    stdout.styledWrite(fgRed, styleBright, "[ERROR]: ")
    stdout.styledWriteLine(fgWhite, device & " does not exist or is not a valid block device!")
    return false
  return true

# Give users permissions to modify usb contents
proc givePermissions() =
  var (err, code) = runCommand("chmod -R 775 " & quoteShell(MOUNT_POINT))
  if code != 0:
    stdout.styledWrite(fgRed, styleBright, "[ERROR]: ")
    stdout.styledWriteLine(fgWhite, "Failed to change permissions at mount point: " & err)
    quit(1)

  (err, code) = runCommand("chmod -R users " & quoteShell(MOUNT_POINT))
  if code != 0:
    stdout.styledWrite(fgRed, styleBright, "[ERROR]: ")
    stdout.styledWriteLine(fgWhite, "Failed to change group user at mount point: " & err)
    quit(1)

# Check if the mount point directory exists and create it if not
proc checkMountPoint() =
  if not dirExists(MOUNT_POINT):
    stdout.styledWrite(fgBlue, styleBright, "[INFO]: ")
    stdout.styledWriteLine(fgWhite, "Creating mount point: " & MOUNT_POINT)
    let (output, code) = runCommand("mkdir -p " & quoteShell(MOUNT_POINT))
    if code != 0:
      stdout.styledWrite(fgRed, styleBright, "[ERROR]: ")
      stdout.styledWriteLine(fgWhite, "Failed to create mount point: " & output)
      quit(1)
    givePermissions()

# Tries to detect the filesystem type of a block device
proc getFileSystemType(device: string): string =
  let (fsType, _) = runCommand("blkid -o value -s TYPE " & quoteShell(device))
  return fsType.strip()

# Lists ALL removable block devices (for "List" option)
proc listAllRemovableDevices() =
  # Filter for RM=1 (removable) AND exclude TYPE=rom (CD-ROM)
  let (lsblkOut, _) = runCommand("lsblk -o NAME,RM,SIZE,TYPE,MOUNTPOINT | grep ' 1 ' | grep -v 'rom'")
  echo lsblkOut

# Lists only devices that are NOT already mounted at MOUNT_POINT
proc listAvailableDevicesToMount() =
  # Filter for RM=1 (removable) AND exclude TYPE=rom (CD-ROM)
  # Then, filter out the default mount point.
  let cmd = "lsblk -o NAME,RM,SIZE,TYPE,MOUNTPOINT | grep ' 1 ' | grep -v 'rom' | grep -v " & MOUNT_POINT
  let (lsblkOut, _) = runCommand(cmd)
  echo lsblkOut

# Provides troubleshooting suggestions on a failed mount
proc troubleshootMountFailure(device: string) =
  let fs = getFileSystemType(device)
  if fs != "":
    stdout.styledWrite(fgYellow, styleBright, "Detected filesystem: ")
    stdout.styledWriteLine(fgCyan, styleBright, fs)
    stdout.styledWrite(fgGreen, styleBright, "Suggestion: ")
    if fs == "ntfs":
      stdout.styledWriteLine(fgWhite, "Try: mount -t ntfs-3g " & device & " " & MOUNT_POINT)
    elif fs == "exfat":
      stdout.styledWriteLine(fgWhite, "Try: mount -t exfat " & device & " " & MOUNT_POINT)
    elif fs == "ext4":
      stdout.styledWriteLine(fgWhite, "Try: mount -t ext4 " & device & " " & MOUNT_POINT)
    else:
      stdout.styledWriteLine(fgWhite, "Try specifying the filesystem type: mount -t <type> " &
          device & " " & MOUNT_POINT)
  else:
    stdout.styledWriteLine(fgRed, "Could not detect filesystem type.")
    stdout.styledWrite(fgGreen, styleBright, "Suggestion: ")
    stdout.styledWriteLine(fgWhite, "Try specifying the filesystem type manually: mount -t <type> " &
        device & " " & MOUNT_POINT)
  quit(1)

# --- Core Logic Procedures ---
# Get the usb labels to unmount
proc getDeviceLabel(target: string): string =
  for item in LABELS:
    if item.device == target:
      return item.label
  return ""

# Ask for a Label before mounting the device
proc setDeviceLabel(device: string) =
  stdout.styledWrite(fgYellow, styleBright, "\n➜ Enter the device label to mount ")
  stdout.styledWrite(fgWhite, "(e.g., DATA, MY_USB): ")
  stdout.flushFile()

  let label = readLine(stdin).strip()
  if label != "":
    LABELS.add((device: device, label: label))
    let usbMountPoint = MOUNT_POINT/label
    createDir(usbMountPoint)

    stdout.styledWrite(fgBlue, styleBright, "[INFO]: ")
    stdout.styledWriteLine(fgWhite, "Mounting " & device & " at " &
        usbMountPoint & "...")
    let cmd = "mount " &
           quoteShell(device) &
           " " &
           quoteShell(usbMountPoint)

    let (_, exitCode) = runCommand(cmd)

    if exitCode == 0:
      stdout.styledWrite(fgGreen, styleBright, "✓ [SUCCESS]: ")
      stdout.styledWriteLine(fgWhite, "USB successfully mounted at " &
          usbMountPoint & "!")
      # Display status of the device
      let (lsOutput, _) = runCommand("stat " & quoteShell(usbMountPoint))
      echo lsOutput
    else:
      stdout.styledWrite(fgRed, styleBright, "[ERROR]: ")
      stdout.styledWriteLine(fgWhite, "Mount command failed.")
      troubleshootMountFailure(device)
  else:
    stdout.styledWrite(fgRed, styleBright, "[ERROR]: ")
    stdout.styledWriteLine(fgWhite, "Mount point creation failed.")

# Mounts the specified block device to the default mount point
proc doMount(device: string) =
  if device == "":
    stdout.styledWrite(fgRed, styleBright, "[ERROR]: ")
    stdout.styledWriteLine(fgWhite, "Please specify a device (e.g., /dev/sdb1)")
    showHelp()

  # Check if the device is a valid block device
  if not isBlockDevice(device):
    stdout.styledWriteLine(fgCyan, styleBright, "\n[INFO]: Available removable devices to mount:")
    listAvailableDevicesToMount()
    quit(1)

  # Ensure mount point exists
  checkMountPoint()
  setDeviceLabel(device)

# Unmounts a device or the default mount point
proc doUmount(device: string) =
  let label = getDeviceLabel(device).strip()
  let target =
    if label != "":
      MOUNT_POINT / label # e.g., /media/nim_usb/PLATA
    else:
      device              # e.g., /dev/sdd

  if label != "":
    stdout.styledWrite(fgYellow, "Attempting to unmount labeled device at: ")
    stdout.styledWriteLine(fgCyan, styleBright, target)
  else:
    stdout.styledWrite(fgYellow, "Attempting to unmount raw device: ")
    stdout.styledWriteLine(fgCyan, styleBright, device)

  let (output, exitCode) = execCmdEx("umount " & quoteShell(target))
  if exitCode == 0:
    stdout.styledWrite(fgGreen, styleBright, "✓ [SUCCESS]: ")
    stdout.styledWriteLine(fgWhite, "USB successfully unmounted!")
    # ✅ Only try to remove if it's a labeled mount point (a directory)
    if label != "":
      let (rmOut, rmCode) = execCmdEx("rmdir " & quoteShell(target))
      if rmCode != 0:
        stdout.styledWrite(fgYellow, styleBright, "[WARNING]: ")
        stdout.styledWriteLine(fgWhite, "Could not remove directory: " & target)
        stdout.styledWriteLine(fgWhite, "  Reason: " & rmOut)
  else:
    stdout.styledWrite(fgRed, styleBright, "[ERROR]: ")
    stdout.styledWriteLine(fgWhite, "Failed to unmount.")
    echo output

# Runs an interactive menu for mounting/unmounting devices
proc interactiveMode() =
  while true:
    echo ""
    stdout.styledWriteLine(fgCyan, styleBright, "╔════════════════════════════════════════╗")
    stdout.styledWriteLine(fgCyan, styleBright, "║     USB Mounter (Root Mode)            ║")
    stdout.styledWriteLine(fgCyan, styleBright, "╚════════════════════════════════════════╝")
    echo ""
    stdout.styledWrite(fgGreen, styleBright, "  [1] ")
    stdout.styledWriteLine(fgWhite, "Mount a device")
    stdout.styledWrite(fgRed, styleBright, "  [2] ")
    stdout.styledWriteLine(fgWhite, "Unmount a device")
    stdout.styledWrite(fgYellow, styleBright, "  [3] ")
    stdout.styledWriteLine(fgWhite, "List all removable devices")
    stdout.styledWrite(fgMagenta, styleBright, "  [4] ")
    stdout.styledWriteLine(fgWhite, "Exit")
    echo ""
    stdout.styledWrite(fgCyan, styleBright, "➜ Option: ")
    stdout.flushFile()
    let choice = readLine(stdin).strip()

    case choice
    of "1":
      echo ""
      stdout.styledWriteLine(fgYellow, styleBright,
          "Available devices to mount (excludes " & MOUNT_POINT & "):")
      echo ""
      # Call the new function that filters the list
      listAvailableDevicesToMount()
      echo ""
      stdout.styledWrite(fgCyan, styleBright, "➜ Enter the device to mount ")
      stdout.styledWrite(fgWhite, "(e.g., /dev/sdb1): ")
      stdout.flushFile()

      let dev = readLine(stdin).strip()
      if dev != "":
        doMount(dev)

    of "2":
      echo ""
      stdout.styledWriteLine(fgYellow, styleBright, "Currently mounted devices:")
      echo ""
      let (mountedOut, _) = runCommand("lsblk -o NAME,RM,SIZE,TYPE,MOUNTPOINT | grep ' 1 ' | grep -v 'rom'")
      echo mountedOut
      echo ""
      stdout.styledWrite(fgCyan, styleBright, "➜ Enter device or mount point to unmount ")
      stdout.styledWrite(fgWhite, "(e.g., /dev/sdb1): ")
      stdout.flushFile()
      let devToUnmount = readLine(stdin).strip()
      doUmount(devToUnmount)

    of "3":
      echo ""
      stdout.styledWriteLine(fgYellow, styleBright, "Listing ALL removable devices (excluding CD-ROM):")
      echo ""
      listAllRemovableDevices()

    of "4":
      echo ""
      stdout.styledWriteLine(fgGreen, styleBright, "✓ Exiting... Goodbye!")
      echo ""
      quit(0)
    else:
      stdout.styledWriteLine(fgRed, styleBright, "✗ Invalid option. Please choose 1-4.")

# --- Main Entry Point ---
when isMainModule:
  # Check for root privileges first
  if getEuid() != 0:
    stdout.styledWrite(fgRed, styleBright, "[ERROR]: ")
    stdout.styledWriteLine(fgWhite, "This script must be run as root.")
    stdout.styledWriteLine(fgYellow, "Please run it with usb_mounter.sh")
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
