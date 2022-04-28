{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    appName = "Local Gitea";
    domain = "git.sedrick.lan";
    rootUrl = "http://git.sedrick.lan/";
    httpPort = 3001;
    useWizard = true;
  };
}
