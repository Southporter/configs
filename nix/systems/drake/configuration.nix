# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.domain = "sedrick.lan";
  networking.hostName = "drake";
  networking.useDHCP = false;
  networking.interfaces.eth0 = {
    useDHCP = true;
    ipv4.addresses = [{
      address = "192.168.1.14";
      prefixLength = 32;
    }];
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ssedrick = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    home = "/home/ssedrick";
  };

  security.sudo.configFile = ''
    %wheel ALL=(ALL) ALL
  '';

  users.users.ssedrick.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCweXSl3Hsoabp8x41QMj0a21HOcNgQ5JNtLoxmpVZWbshXfcf0hXV3yfPVixpAdSO1/nIy6JTnTINiPA9cYYs9Zac4rA6sey/YeulIHxuNqiJChiU71VEaORgO+wz17qo7eDcb8Vhk6oR/q+fgt5STlGJ6ZFjQ5XO3QbtYOu77ZG8UmyVN1rOF1X4CfIfw1Aj0tvorOFUjcLLd/NKULVvcwlWQB13M7gzI++iR3RKMNlU+0EE466fWQl42r8jqbFZmMX4UmKMvwdNSRN+uLHmrs94WGZyU65BI6L50LwKZTJ1C1hR1OlHA5FNviONDbww9d5PjOO1zwtvODI0IaSWF762cL4Ezv0H439ibk9RvjcwUKoEIQa2mUJ5irplqbNfYmlQqX+qKmX7rK11xBJUxVJvJCGQYt+u/w8KFFI6imwzI6NeW9CtuZEJ7qPd48NwCyc70l4hDldVbmuDDfIMHUIcckEhqbqaovvDLBb77e5v6qTHai2rLCfOjg5UmhixSZzIGUq29oOsdVvmuumQIKnFRNBY53zHorLciXSmG1E8ymT3d+b0+/E4cUPTCk2PiWKAb1bNdQQzhrgbTiZvlxZhbagtHQ9PC3d/WXhai+fRTQeIrlRReZ9LnvxabY93XXzv9cDGmoBK4hIVAhnSw0su78mTSG5bEvyAX8qlrrw== ssedrick1@gmail.com"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     curl
     git
  ];

  services.tailscale.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.htop.enable = true;
  programs.htop.settings = {
    hide_kernel_threads = true;
    hide_userland_threads = true;
  };

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ 53 ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };
  nix.gc.automatic = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

