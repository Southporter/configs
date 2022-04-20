{
  description = "System Configuration for ssedrick";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    pkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    config-git.url = "github:ssedrick/configs";
  };

  outputs = inputs: {
    homeConfiguration = {
      ssedrick = inputs.home-manager.lib.homeManagerConfiguration {
        homeDirectory = "/home/ssedrick";
        username = "ssedrick";
        stateVersion = "21.11";

        configuration = { imports = [ ./nix/home.nix ]; };
      };
    };

    nixosConfiguration = {
      bayard = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./nix/systems/machines/laptop/hardware-configuration.nix
          ./nix/systems/configuration.nix
        ];
      };
    };
  };
}
