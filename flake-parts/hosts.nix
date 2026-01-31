{ inputs, withSystem, ... }:

let
  mkHost =
    {
      system,
      hostName,
      extraModules ? [ ],
      withHomeManager ? true,
      user ? "abayoumy",
    }:
    withSystem system (
      {
        config,
        inputs',
        self',
        system,
        ...
      }:
      let
        baseSpecialArgs = {
          inherit inputs hostName;
        };
      in
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = baseSpecialArgs // {
          inherit hostName;
          host.hostName = hostName;
        };
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
            networking.hostName = hostName;
          }
          # Import the host-specific configuration
          ../hosts/${hostName}/configuration.nix

          # Shared modules
          ../modules/nixos/default.nix
        ]
        ++ extraModules
        ++ (
          if (withHomeManager && (inputs ? home-manager)) then
            [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  extraSpecialArgs = baseSpecialArgs;
                  users."${user}" = import ../modules/users/${user}/home.nix;
                };
              }
            ]
          else
            [ ]
        );
      }
    );
in
{
  flake.nixosConfigurations = {
    laptop = mkHost {
      system = "x86_64-linux";
      hostName = "laptop";
    };

    nixos-desktop = mkHost {
      system = "x86_64-linux";
      hostName = "desktop"; # directoryname will be desktop
      # "nixos-desktop" is the flake output name, "desktop" is the directory/hostname
    };
  };
}
