# Home-manager configuration for abayoumy
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.dank-material-shell.homeModules.dank-material-shell
  ];

  # Home settings
  home.username = "abayoumy";
  home.homeDirectory = "/home/abayoumy";
  home.stateVersion = "25.11";

  # Enable Zsh with aliases and tools
  # Zsh is now managed via dotfiles/home/.zshrc
  # programs.zsh is disabled to avoid conflicts

  # Modern ls replacement
  programs.eza = {
    enable = true;
    # enableZshIntegration = true;
  };

  # Git Configuration
  programs.git = {
    enable = true;
    userName = "abayoumy";
    userEmail = "abayoumy@outlook.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";

      # Optimize for GitHub & large repos
      core.compression = 0;
      http.postBuffer = 524288000;
    };

    # Standard global ignores
    ignores = [
      # OS generated files
      ".DS_Store"
      ".DS_Store?"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "ehthumbs.db"
      "Thumbs.db"

      # Editor files
      ".idea/"
      ".vscode/"
      "*.swp"
      "*.swo"
      "*~"

      # Build & Dependency Directories (Common)
      "node_modules/"
      "dist/"
      "build/"
      "target/"
      "out/"

      # Python
      "__pycache__/"
      "*.pyc"
      ".venv/"
      ".env"

      # Nix
      "result"
      "result-*"
    ];
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
    };
  };

  # Shell tools & Applications
  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    fzf
    fastfetch

    # GUI Tools
    wezterm
    rofi
    nil
    nixfmt
    zsh
    neovim
    tty-clock
    zoxide
    starship

    curl
    gcc
  ];

  # Enable Dank Material Shell
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    # plugins are not yet supported in stable without manual src definition
    # plugins = {
    #   dankBatteryAlerts.enable = true;
    # #   dockerManager.enable = true;
    # };
  };

  # Symlink home configurations (ignoring .zshrc creation by home-manager)
  home.file =
    let
      homeDotfilesDir = ../../../dotfiles/home;
    in
    lib.listToAttrs (
      map (
        file:
        let
          relativePath = lib.removePrefix "${toString homeDotfilesDir}/" (toString file);
        in
        {
          name = relativePath;
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-laptop/dotfiles/home/${relativePath}";
          };
        }
      ) (lib.filesystem.listFilesRecursive homeDotfilesDir)
    )
    // {
      "Pictures/wallpapers".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-laptop/dotfiles/wallpapers";
    };

  # Symlink configurations (Mutable Dotfiles)
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
  xdg.configFile =
    let
      # Adjusted relative path from modules/users/abayoumy/home.nix to dotfiles/config
      configDir = ../../../dotfiles/config;
    in
    lib.listToAttrs (
      map (
        file:
        let
          relativePath = lib.removePrefix "${toString configDir}/" (toString file);
        in
        {
          name = relativePath;
          value = {
            # Using mkOutOfStoreSymlink requires absolute path to the flake root or target file
            # Assuming typical setup, but let's be careful.
            # The original code hardcoded `nixos-laptop`. This is brittle if folder changes.
            # But we will keep it for now as requested to reuse config.
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-laptop/dotfiles/config/${relativePath}";
          };
        }
      ) (lib.filesystem.listFilesRecursive configDir)
    );
}
