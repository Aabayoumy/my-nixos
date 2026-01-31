# NixOS Makefile

.PHONY: all rebuild-laptop rebuild-desktop update check help gc list-generations clean-generations

# Default target
all: help

# Rebuild the laptop configuration
rebuild-laptop:
	sudo nixos-rebuild switch --flake .#laptop

# Rebuild the desktop configuration
rebuild-desktop:
	sudo nixos-rebuild switch --flake .#nixos-desktop

# Update flake lockfile
update:
	nix flake update

# Check flake for errors
check:
	nix flake check

# List all system generations
list-generations:
	sudo nix-env --list-generations -p /nix/var/nix/profiles/system

# Delete generations older than 7 days
clean-generations:
	sudo nix-collect-garbage --delete-older-than 7d

# Garbage collect unused nix store paths
gc:
	nix-collect-garbage -d

# Show help
help:
	@echo "NixOS Management Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make rebuild-laptop    - Rebuild and switch laptop configuration"
	@echo "  make rebuild-desktop   - Rebuild and switch desktop configuration"
	@echo "  make update            - Update flake inputs (flake.lock)"
	@echo "  make check             - Check flake validity"
	@echo "  make list-generations  - List all system generations"
	@echo "  make clean-generations - Remove generations older than 7 days"
	@echo "  make gc                - Garbage collect unused store paths"
