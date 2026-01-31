# NixOS Laptop Config Flake
# Using flake-parts for modularity, Nixpkgs stable 25.11 for stability
{
  description = "NixOS configuration for laptop with Zsh, Niri, DankMaterialShell, WezTerm, greetd, and code-server";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Unstable for DMS
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Home-manager for user configs
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Dank Material Shell
    dank-material-shell.url = "github:AvengeMedia/DankMaterialShell/stable";
    dank-material-shell.inputs.nixpkgs.follows = "nixpkgs";
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Additional tools
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  # Binary caches for faster builds
  nixConfig = {
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org/"
      "https://numtide.cachix.org"
    ];
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      inherit (inputs.nixpkgs) lib;
      inherit (import ./flake-parts/_bootstrap.nix { inherit lib; }) loadParts;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      imports = [
        # Explicit import ensures hosts.nix is loaded correctly
        ./flake-parts/hosts.nix
        # Also load other parts via loadParts if needed, but avoid double loading loop
        # (loadParts ./flake-parts)
      ];
    };
}
