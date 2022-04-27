{ config, pkgs, ... }:

{
  services.gitea = {
    enable = true;
    appName = "Local Gitea";
    domain = "git.sedrick.lan";
    rootUrl = "http://git.sedrick.lan/";
    httpPort = 3001;
    extraConfig = let
      docutils = pkgs.python39.withPackages (ps: with ps; [
        docutils
        pygments
      ]);
    in ''
      [markup.restructuredtext]
      ENABLED = true
      FILE_EXTENSIONS = .rst
      RENDER_COMMAND = ${docutils}/bin/rst2html.py
      IS_INPUT_FILE = false
    '';
  };
}
