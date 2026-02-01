# Home-manager configuration for abayoumy
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  # CHANGE ME: Path to your local flake repository
  # This is required for "mutable" symlinks (live editing without rebuild).
  # If you change the folder name, update this single line.
  flakeDir = "/home/abayoumy/my-nixos";
in
{
  imports = [
    inputs.dank-material-shell.homeModules.dank-material-shell
  ];

  # Styling Options
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      };
    };
    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
    };
  };

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

    # GUI Customization
    swaybg
    nwg-look
    lxappearance

    # Qt / Kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qtwayland
    libsForQt5.qtwayland
    pkgs.catppuccin-kvantum
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
            source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/dotfiles/home/${relativePath}";
          };
        }
      ) (lib.filesystem.listFilesRecursive homeDotfilesDir)
    )
    // {
      "Pictures/wallpapers".source =
        config.lib.file.mkOutOfStoreSymlink "${flakeDir}/dotfiles/wallpapers";
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
            # Now using the centralized `flakeDir` variable
            source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/dotfiles/config/${relativePath}";
          };
        }
      ) (lib.filesystem.listFilesRecursive configDir)
    )
    // {
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Catppuccin-Mocha-Mauve
      '';
    };
}
