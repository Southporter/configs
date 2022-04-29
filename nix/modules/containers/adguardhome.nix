{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 53 3000 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  virtualisation.oci-containers.containers.adguardhome = {
    image = "adguard/adguardhome";
    ports = [
      "53:53/udp"
      "53:53/tcp"
      "3000:3000/tcp"
    ];
  };
}
