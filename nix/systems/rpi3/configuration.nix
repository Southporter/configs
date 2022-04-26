{ config, pkgs, ... }:
{
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.raspberryPi.firmwareConfig = ''
    dtparam=audio=off
    dtoverlay=disable-bt
    dtoverlay=disable-wifi
  '';

  boot.blacklistedKernelModules = [
    "bluetooth" "btqca" "btsdio" "btbcm"
  ];

  security.sudo.wheelNeedsPassword = false;

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
