{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = networking.firewall.allowedTCPPorts ++ [ 53 3000 ];
  networking.firewall.allowedUDPPorts = networking.firewall.allowedUDPPorts ++ [ 53 ];
  virtualization.oci-containers.containers.adguardhome = {
    image = "docker.io/library/adguard/adguardhome";
    ports = [
      "53:53/udp"
      "53:53/tcp"
      "3000:3000/tcp"
    ];

  };
}
