{ config, pkgs, inputs, ... }:

let
  unfree = import inputs.pkgs-unstable {
    inherit (pkgs.stdenv.targetPlatform) system;
    config = {
      inherit (pkgs.config);
      allowUnfree = true;
    };
  };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with unfree.vscode-extensions; [
      vscodevim.vim
      bbenoist.nix
      ms-python.python
      ms-python.vscode-pylance
    ];
  };
}

