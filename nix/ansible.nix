{ config, pkgs, cfgs, ... }:

{
  home.packages = with pkgs; [
    (ansible.overrideAttrs(oa: {
      propogatedBuildInputs = oa.propogatedBuildInputs ++ [
        python3Packages.cryptography
        python3Packages.psycopg2
      ];
    }))
  ];
}
