# NixOS configuration for desktop
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/users/abayoumy/default.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Graphics Configuration
  host.hardware.graphics.backend = "nvidia";


  # System specific packages
  environment.systemPackages = with pkgs; [
    # Desktop specific tools
  ];

  system.stateVersion = "25.11";
}
