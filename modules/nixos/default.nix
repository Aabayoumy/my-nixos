# Shared NixOS modules
# Includes configurations for planned components
{ pkgs, ... }:

{
  imports = [
    ./hardware/graphics.nix
  ];

  # Enable nix-ld for VSCode remote SSH compatibility
  programs.nix-ld.enable = true;

  # Enable code-server for VSCode remote access
  services.code-server = {
    enable = true;
    user = "abayoumy"; # Replace with your username
    group = "users";
    port = 8080;
    host = "127.0.0.1";
    auth = "password";
    hashedPassword = "$argon2id$v=19$m=65536,t=3,p=1$..."; # Generate with nix-shell -p argon2-cli --run "echo -n 'password' | argon2-cli -e"
  };

  # Enable greetd with tuigreet for CLI login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri";
        user = "greeter";
      };
    };
  };

  # Enable Niri as Wayland compositor
  programs.niri.enable = true;

  # Enable WezTerm
  # System Packages
  environment.systemPackages = with pkgs; [
    wezterm
    git
    vim
    wget
    gnumake # provides 'make'
    psmisc # provides 'killall'
  ];

  # Enable Thunar File Manager and related services
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # Services required for Thunar functionality
  services.gvfs.enable = true; # Mount, trash, and other functionality
  services.tumbler.enable = true; # Thumbnail support
  programs.xfconf.enable = true; # Thunar settings management

  # Firewall for code-server

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
