{ pkgs, config, lib, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {};
  cfgs = builtins.fetchGit {
    url = "https://github.com/ssedrick/configs.git";
    ref = "master";
  };
in
{
  home.packages = with pkgs; [
    notify-desktop
    swaybg
    swaylock
    swayidle
    albert
    wl-clipboard
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    swaynag.enable = true;


    config = rec {
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.albert}/bin/albert show";

      gaps = let gap = 4;
      in {
        inner = gap;
        outer = gap;
      };

      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          "xkb_options" = "ctrl:nocaps,ctrl:swapcaps";
        };
      };
      focus.followMouse = "no";

      keybindings = lib.mkOptionDefault {
        "Mod1+l" = "exec swaylock -e -f -c 000000 -i /home/ssedrick/Pictures/lockscreen.png";
      };

      bars = [];
    };

  };

  systemd.user.services.albert = {
    Unit = { Description = "Albert app launcher"; };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.albert}/bin/albert";
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
  };

  programs.mako = {
    enable = true;
    defaultTimeout = 3500;
  };

  programs.waybar = {
    package = pkgsUnstable.waybar;
    enable = true;
    systemd.enable = true;
    style = (builtins.readFile "${cfgs}/waybar.style.css");

    settings = [{
      modules-left = [ "sway/workspaces" "sway/mode"];
      modules-center = ["sway/window"];
      modules-right = [ "keyboard-state" "battery" "clock" "network" ];

      modules = {
        "sway/window" = { "max-length" = 50; };
        "battery" = {
          "format"= "{capacity}% {icon}";
          "format-icons" = ["" "" "" "" ""];
        };
        "clock" = {
          "interval" = 1;
          "format" = " {:%e %b %Y %R}";
          "tooltip" = false;
        };
        "keyboard-state" = {
          "numlock" = true;
          "capslock" = true;
          "format" = "{icon} {name}";
          "format-icons" = {
            "locked" = "";
            "unlocked" =  "";
          };
        };
        "network" = {
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };
      };
    }];
  };

  systemd.user.services.waybar = {
    # Unit = { Description = "Waybar"; };
    # Service = {
    #   Type = "simple";
    #   ExecStart = "${pkgs.waybar}/bin/waybar -b bar-0";
    # };
    Install = { WantedBy = [ "sway-session.target" ]; };
  };

  # systemd.user.services.swaybg = {
  #   Unit = { Description = "Swaybg background"; };
  #   Service = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.swaybg}/bin/swaybg --output '*' -m fill --image '/home/ssedrick/Pictures/wallpaper.jpg'";
  #   };
  #   Install = { WantedBy = [ "sway-session.target" ]; };
  # };

  systemd.user.services.swayidle = {
    Unit = { Description = "Swayidle"; };
    Service = {
      Type = "simple";
      ExecStart = ''${pkgs.swayidle}/bin/swayidle -w \
        timeout 300 'swaylock -f -c 000000 -i /home/ssedrick/Pictures/lockscreen.png' \
        timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
        before-sleep 'swayloack -f -c 000000 -i /home/ssedrick/Pictures/lockscreen.png'
      '';
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
  };
}
