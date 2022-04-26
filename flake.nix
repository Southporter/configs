{
  description = "System Configuration for ssedrick";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    pkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: 
    let
      cfgs = builtins.fetchGit {
        url = "https://github.com/ssedrick/configs.git";
        ref = "master";
        rev = "d6dc18f864584ed0c8d6a74e2ae27aba15485fdc";
      };
    in
    {
    homeConfigurations = {
      ssedrick = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";

        homeDirectory = "/home/ssedrick";
        username = "ssedrick";
        stateVersion = "21.11";

        extraSpecialArgs = { inherit cfgs; inherit inputs; };

        configuration = {
          imports = [ ./nix/home.nix ];
        };
      };
    };

    nixosConfigurations = {
      bayard = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./nix/systems/laptop/hardware-configuration.nix
          ./nix/systems/configuration.nix
        ];
      };
      drake = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./nix/systems/drake/hardware-configuration.nix
          ./nix/systems/hardening.nix
          ./nix/systems/rpi3/configuration.nix
          ./nix/systems/drake/configuration.nix
          # ./nix/modules/containers/podman.nix
          ./nix/adguardhome.nix
        ];
      };
    };
  };
}
