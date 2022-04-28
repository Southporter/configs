{ config, pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 3001 ];

  services.gitea = {
    enable = true;
    appName = "Local Gitea";
    # domain = "git.sedrick.lan";
    rootUrl = "http://192.168.1.14:3001/";
    httpPort = 3001;
    useWizard = true;
  };
}
