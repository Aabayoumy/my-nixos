# nixos-laptop

## About

This is a NixOS configuration repository using Nix flakes and flake-parts for modularity. It's set up as a template for managing NixOS systems, home-manager configurations, and development environments. The structure allows for scalable host configurations, with each host in its own folder under `hosts/`.

Current structure:

- `flake.nix`: Root flake defining inputs (nixpkgs stable 25.11, flake-parts, treefmt-nix) and outputs.
- `flake-parts/`: Modules for flake-parts, including \_bootstrap.nix (loadParts function), flake-root.nix (flake root path), treefmt.nix (code formatting), and hosts.nix (defines nixosConfigurations).
- `hosts/`: Host-specific configurations. Currently, `laptop/` contains the laptop setup with default.nix (system instantiation) and configuration.nix (NixOS module).
- `modules/nixos/`: Shared NixOS modules for reusability across hosts.
- `README.md`: This file.
- `.envrc`: Direnv setup for Nix environment.
- `.gitignore`: Standard Nix ignores.

Planned config for laptop: Zsh with aliases/tools, Niri with DankMaterialShell, WezTerm, greetd/tuigreet (no X11), code-server for VSCode SSH remote, nix-ld for compatibility.

## References

1. This project was built using [tsandrini/flake-parts-builder](https://github.com/tsandrini/flake-parts-builder/)
