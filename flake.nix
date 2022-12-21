{
  description = "System Configuration for ssedrick";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    pkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: 
    let
      cfgs = builtins.fetchGit {
        url = "https://github.com/ssedrick/configs.git";
        ref = "master";
        rev = "0f7858c789e976c3cce96b9baa4f62c1b225a816";
      };
    in
    rec {
    homeConfigurations = {
      ssedrick = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";

        homeDirectory = "/home/ssedrick";
        username = "ssedrick";
        stateVersion = "21.11";

        extraSpecialArgs = { inherit cfgs; inherit inputs; };

        configuration = {
          imports = [ ./nix/home.nix ./nix/sway.nix ./nix/nvim.nix ./nix/tmux.nix ./nix/vscode.nix ];
        };
      };
      "ssedrick@caylent.sedrick.lan" = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-darwin";

        username = "ssedrick"; homeDirectory = "/Users/ssedrick";
        stateVersion = "21.11";
        extraSpecialArgs = { inherit cfgs; inherit inputs; };

        configuration = {
          imports = [ ./nix/home.nix ./nix/nvim.nix ./nix/tmux.nix ./nix/vscode.nix ];
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
