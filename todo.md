# NixOS Laptop Config Roadmap

## Phase 1: Base Setup

- Update flake.nix to use Nixpkgs stable 25.11
- Restructure hosts into hosts/laptop/ with default.nix and configuration.nix
- Add flake-parts/hosts.nix to define nixosConfigurations
- Set up basic NixOS config in hosts/laptop/configuration.nix (networking, users, etc.)

## Phase 2: Shell/Terminal

- Configure Zsh with aliases and shell tools via home-manager
- Install and configure WezTerm as terminal emulator

## Phase 3: WM/Shell/Theme

- Install and configure Niri as Wayland compositor
- Enable DankMaterialShell for launcher/notifications
- Set up Wayland-only environment (no X11)

## Phase 4: Login/Auth

- Configure greetd with tuigreet for CLI login
- Set greetd to launch Niri session

## Phase 5: Remote Dev

- Enable code-server for VSCode SSH remote access
- Enable nix-ld for dynamic linking compatibility
- Configure SSH and firewall for remote access

## Testing

- Rebuild system with nixos-rebuild switch
- Test each component: login, shell, WM, terminal, remote access
- Validate hardware compatibility and performance
