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
        rev = "e157b96fa5de677fbe42a5e3a2e38d6e784c7814";
      };
      unstable = (builtins.trace (builtins.toJSON inputs.pkgs-unstable) inputs.pkgs-unstable);
      pkgs = import inputs.nixpkgs { overlays = [
        unstable
      ];};
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
    };
  };
}
