{ config, pkgs, cfgs,  ... }:

let
  python = pkgs.python39.withPackages (ps: with ps; [
    ruamel-yaml
  ]);
in
{
  networking.firewall.allowedTCPPorts = [ 53 3000 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.adguardhome = {
    enable = true;
    port = 3000;
  };

  systemd.services.adguardhome = {
    Service = {
      ExecStopPost = "${python}/bin/python ${cfgs}/scripts/adguardhome/stop.py";
    };
  };
}
