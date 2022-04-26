{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    config = ''
      ads.sedrick.lan

      reverse_proxy 127.0.0.1:3000
    '';
  };
}
