{ config, pkgs, inputs, lib, ... }:

let
  unstable = import inputs.pkgs-unstable { inherit (pkgs.stdenv.targetPlatform) system; };
in
{
  home.packages = with pkgs; [
    steam
    steam-run
  ];
}
