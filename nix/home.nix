{ config, pkgs, cfgs, ... }:
{

  imports = [ ./nvim.nix ./sway.nix ./tmux.nix ./vscode.nix ./fractal.nix  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ssedrick";
  home.homeDirectory = "/home/ssedrick";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # nixpkgs = {
  #   overlays = [
  #     (final: prev: {
  #       quickemu = prev.quickemu.override { OVMF = pkgs.OVMFFull.override { secureBoot = true; tpmSupport = true; csmSupport = true; httpSupport = true;}; };
  #     })
  #   ];
  # };

  home.packages = with pkgs; [
    pantheon.elementary-files
    pantheon.granite
    pantheon.elementary-gtk-theme
    midori
    gnome3.adwaita-icon-theme

    bitwarden-cli
    bat
    (ansible.overrideAttrs(oa: { propagatedBuildInputs = oa.propagatedBuildInputs ++ [ python3Packages.cryptography python3Packages.psycopg2 ]; }))
    elmPackages.elm
    (quickemu.override {
      OVMF = pkgs.OVMFFull.override {
        secureBoot = true;
        tpmSupport = true;
        csmSupport = true;
        httpSupport = true;
      };
    })
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    desktopEntries = {};
  };

  programs.alacritty.enable = true;

  xdg.configFile."alacritty/alacritty.yml".source = "${cfgs}/alacritty.yml";

  programs.git = {
    enable = true;
  };

  # services.tailscale.enable = true;

  systemd.user.sessionVariables = {
    EDITOR = "vim";
    SYSTEM_EDITOR = "vim";
    NIXOS_OZONE_WL = 1;
  };
}
