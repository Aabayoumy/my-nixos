# NixOS configuration for laptop
{
  config,
  pkgs,
  inputs,
  ...
}:

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

  # Audio (common but can be host specific)
  # hardware.pulseaudio.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  # };

  # Hardware specific graphics
  # Graphics Configuration
  host.hardware.graphics.backend = "intel";

  # System specific packages
  environment.systemPackages = with pkgs; [
    # Laptop specific tools if any
    acpi
    brightnessctl
  ];
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
    openFirewall = true;
  };

  # Host specific overrides
  services.thermald.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Hardware Optimization
  hardware.enableRedistributableFirmware = true;
  # services.thermald.enable = true; # Already enabled above
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "auto";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  system.stateVersion = "25.11";
}
