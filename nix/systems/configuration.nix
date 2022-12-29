# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, modulesPath, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
    };
    
    configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-desktop-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Drakula'
        '';
    };
in
{
  # imports =
  #   [ # Include the results of the hardware scan.
  #     ./hardware-configuration.nix
  #   ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.loader.grub = {
    device = "nodev";
    enable = true;
    version = 2;
    useOSProber = true;
    efiSupport = true;
    gfxmodeEfi = "text";
    gfxmodeBios = "text";
  };

  networking.hostName = "bayard"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  #

  security.sudo.wheelNeedsPassword = false;
  security.pki.certificateFiles = [ (modulesPath + "/lan.crt") ];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable sound.
  sound.enable = false;
  # hardware.pulseaudio.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  #

  programs.fish.enable = true;
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  services.dbus.enable = true;

  users.users.ssedrick = {
    isNormalUser = true;
    shell = pkgs.fish;
    home = "/home/ssedrick";
    extraGroups = [ "wheel" "nixbld" "networkmanager" "audio" "input" "sway" "flatpak"]; # Enable ‘sudo’ for the user.
  };


  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    font-awesome
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim htop wget firefox curl fish alacritty killall
    openssh git rustup tailscale sops ntfs3g parted
    nix-index brightnessctl usbutils
    
    sway dbus-sway-environment configure-gtk wayland xdg-utils
    glib dracula-theme gnome3.adwaita-icon-theme
    swaylock swayidle notify-desktop swaybg albert wl-clipboard
    grim slurp mako wofi

    wineWowPackages.stable helvum pavucontrol
  ];

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };

  programs.ssh = {
    startAgent = true;
  };
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    
    # extraPackages = with pkgs; [
    #   swaylock
    #   swayidle
    #   waybar
    #   wl-clipboard
    #   wofi
    #   dmenu
    #   mako
    #   swaybg
    # ];
  };

  # systemd.user.targets.sway-session = {
  #   description = "Sway Compositor Session";
  #   documentation = [ "man:systemd.special(7)" ];
  #   bindsTo = [ "graphical-session.target" ];
  #   wants = [ "graphical-session-pre.target" ];
  #   after = [ "graphical-session-pre.target" ];
  # };

  # systemd.user.services.sway = {
  #   description = "Sway - Wayland window manager";
  #   documentation = [ "man:sway(5)" ];
  #   bindsTo = [ "graphical-session.target" ];
  #   wants = [ "graphical-session-pre.target" ];
  #   after = [ "graphical-session-pre.target" ];

  #   environment.PATH = lib.mkForce null;
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = ''
  #       ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
  #     '';
  #     Restart = "on-failure";
  #     RestartSec = 1;
  #     TimeoutStopSec = 10;
  #   };
  # };

  programs.waybar.enable = true;
 

  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 5432 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.udev.packages = [pkgs.qmk-udev-rules pkgs.android-udev-rules];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

