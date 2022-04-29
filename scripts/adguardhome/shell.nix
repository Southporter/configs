{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs.python39Packages; [
    adguardhome
    ruamel-yaml
    psutil
  ];
}
