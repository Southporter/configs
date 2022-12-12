{
  description = "System Configuration for ssedrick";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    pkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: 
    let
      cfgs = builtins.fetchGit {
        url = "https://github.com/ssedrick/configs.git";
        ref = "master";
        rev = "17814d9415e12deaf6acdb22f4e3e3821ec265a4";
      };
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    rec {
    homeConfigurations = {
      ssedrick = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./nix/home.nix
        ];

        extraSpecialArgs = { inherit cfgs; inherit inputs; };

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
        specialArgs = { inherit inputs; inherit cfgs; };
        modules = [
          ./nix/systems/drake/hardware-configuration.nix
          ./nix/systems/hardening.nix
          ./nix/systems/rpi3/configuration.nix
          ./nix/systems/drake/configuration.nix
          # ./nix/modules/containers/podman.nix
          ./nix/modules/containers/adguardhome.nix
          ./nix/gitea.nix
        ];
      };
    };
    image.rpi3 = inputs.self.nixosConfigurations.drake.config.system.build.sdImage;
  };
}
