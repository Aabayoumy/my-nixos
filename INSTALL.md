# Installing NixOS from Minimal ISO and Applying This Flake

This guide walks through installing NixOS on your laptop using the minimal ISO and applying the custom flake configuration.

## Prerequisites

- USB drive (at least 2GB)
- Internet connection
- Backup of any important data (installation will wipe disks)

## Step 1: Download and Prepare the Minimal ISO

1. Download the latest NixOS minimal ISO from https://nixos.org/download.html (choose x86_64 for most laptops).
2. Create a bootable USB:
   ```bash
   # On Linux/macOS
   dd if=nixos-minimal-*-x86_64-linux.iso of=/dev/sdX bs=4M
   # Replace /dev/sdX with your USB device (use lsblk or diskutil to find it)
   ```

## Step 3: Boot from USB and Connect to WiFi

1. Insert the USB and reboot your laptop.
2. Enter BIOS/UEFI (usually F2, F10, or Del key).
3. Set boot order to prioritize USB.
4. Save and exit to boot from USB.

Boot into the installer. You'll get a root shell.

If you need to connect to WiFi (the minimal ISO doesn't have a GUI for network configuration):

**Method 1: Direct connection with wpa_supplicant (recommended)**

1. Check available network interfaces:

   ```bash
   ip a
   ```

   Look for WiFi interfaces (usually start with `wl`, like `wlo1`).

2. Connect directly if you know your WiFi details:
   ```bash
   wpa_passphrase "YourSSID" "YourPassword" > /etc/wpa_supplicant.conf
   wpa_supplicant -B -i wlo1 -c /etc/wpa_supplicant.conf
   dhcpcd wlo1
   ```

**Method 2: Using iw for scanning and connection**

1. Install iw if needed (requires temporary internet access):

   ```bash
   nix-env -iA nixos.iw
   ```

2. Check WiFi interfaces:

   ```bash
   iw dev
   ```

3. Scan for networks:

   ```bash
   iw wlo1 scan | grep SSID
   ```

4. Connect using iw (for open networks) or wpa_supplicant (for WPA):

   ```bash
   # For open networks:
   iw wlo1 connect "YourSSID"
   dhcpcd wlo1

   # For WPA networks, use wpa_supplicant as in Method 1
   ```

Note: wpa_supplicant is more reliable for password-protected networks. Use Ethernet temporarily if you need to install iw.

## Step 4: Partition the Disk

1. Identify your disk:

```bash
lsblk

# Assume /dev/nvme0n1 or /dev/sda
```

2. Partition (adjust sizes as needed):

   ```bash
   parted /dev/nvme0n1 -- mklabel gpt
   parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
   parted /dev/nvme0n1 -- set 1 esp on
   parted /dev/nvme0n1 -- mkpart primary 512MiB 100%
   ```

3. Format partitions:
   ```bash
   mkfs.fat -F 32 /dev/nvme0n1p1  # EFI
   mkfs.ext4 /dev/nvme0n1p2       # Root
   ```

## Step 5: Mount and Prepare Installation

1. Mount partitions:

   ```bash
   mount /dev/nvme0n1p2 /mnt
   mkdir -p /mnt/boot
   mount /dev/nvme0n1p1 /mnt/boot
   ```

2. Generate hardware configuration:
   ```bash
   nixos-generate-config --root /mnt
   ```

## Step 6: Clone and Configure the Flake

1. Clone your flake repo:

   ```bash
   nix-env -iA nixos.git
   git clone https://github.com/abayoumyname/nixos-laptop.git /mnt/etc/nixos
   cd /mnt/etc/nixos
   ```

2. Update Hardware Configuration:
   - Copy the generated hardware config to your specific host folder:
     ```bash
     # For Laptop
     cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/laptop/hardware-configuration.nix
     
     # For Desktop
     cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/desktop/hardware-configuration.nix
     ```
   - Review `hosts/<host>/configuration.nix` and `modules/users/abayoumy` to ensure settings are correct.

3. Update flake lock:
   ```bash
   nix flake update
   ```

## Step 7: Install NixOS

1. Install the system:

   ```bash
   # For Laptop
   nixos-install --flake .#laptop

   # For Desktop
   nixos-install --flake .#nixos-desktop
   ```

2. Set root password when prompted:

   ```bash
   passwd
   ```

3. Set user password (replace 'abayoumy' with your username if different):
   ```bash
   nixos-enter
   passwd abayoumy
   exit
   ```

## Step 8: Reboot

1. Unmount and reboot:

   ```bash
   umount -R /mnt
   reboot
   ```

2. Remove USB and boot into your new NixOS system.

## Post-Installation

- Log in as your user.
- Update home-manager: `home-manager switch`
- Test components: greetd login, Niri, WezTerm, etc.
- If issues, check logs: `journalctl -u greetd`, etc.

## Troubleshooting

- If boot fails, check EFI settings.
- For graphics issues, ensure Niri is compatible with your GPU.
- VSCode remote: Tunnel with `ssh -L 8080:localhost:8080 user@laptop`

This should give you a fully configured NixOS with your flake!
