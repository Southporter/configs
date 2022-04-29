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
    serviceConfig = {
      ExecStopPost = "${python}/bin/python ${cfgs}/scripts/adguardhome/stop.py";
      ExecStartPost = "cd ${cfgs}/scripts/adguardhome && ${python}/bin/python start.py";
    };
  };
}
