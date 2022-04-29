{ config, pkgs, inputs, ...}:


let
  unstable = import inputs.pkgs-unstable { inherit (pkgs.stdenv.targetPlatform) system; };
in
{
  home.packages = with unstable; [
    fractal
  ];
}
