{ pkgs, modulesPath, ... }:

{
  import = [
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/profiles/hardened.nix"
  ];
}
