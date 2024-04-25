# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "halfofraspberry"; 
  networking.networkmanager.enable = true;  
  time.timeZone = "Europe/Prague";

   users.users.halfarne = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; 
     };

  environment.shellAliases = {
      please = "doas";
      sudo = "doas";
  };

  programs.dconf.enable = true;

  # Doas
  # Enable doas instead of sudo
  security.doas.enable = true;
  security.sudo.enable = false;

     # Configure doas
     security.doas.extraRules = [{
        users = [ "halfarne" ];
        keepEnv = true;
  	    persist = true;
     }];


  # SSID
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "cs_CZ.UTF-8";
   console = {
     keyMap = "cz-lat2";
   };

  #console.keyMap = "cz-lat2";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     git
     
     gh
     gcc


     jdk
     jre

     python3

     btop
     starship
     wget
     nitch
     zip
     unzip
     bashmount
     exfatprogs
     tmux
     neovim

     pamixer

     blueman

     xmrig
     powertop
  ];


# Starship
  programs.starship.enable = true;
  programs.starship.settings = {
  add_newline = false;
     format = "$nix_shell$directory$character";
     directory = {
       read_only = " ";
       truncation_length = 0;
       style = "bold cyan";
     };
     character = {
       success_symbol = "[s>](white bold)";
       error_symbol = "[s>](red bold)";
     };
     nix_shell = {
       symbol = "❄(boldw white) ";
       style = "bold blue";
       format = "[$symbol$state( \($name\))]($style) ";
     };
  };



#udisk
  services.udisks2.enable=true;

  #Syncthing
  services = {
    syncthing = {
        enable = true;
        user = "halfarne";
        dataDir = "/home/halfarne/Syncthing";    # Default folder for new synced folders
        configDir = "/home/halfarne/Syncthing/.config";   # Folder for Syncthing's settings and keys
        overrideFolders = false;
        overrideDevices = false;
    };
  };

  services.syncthing.settings.gui = {
    user = "halfarne";
    password = "halfarne";
  };

  #Blocky
  services.blocky = {
    enable = true;
    settings = {
      port = 53; # Port for incoming DNS Queries.
      upstream.default = [
        "https://doh.libredns.gr/dns-query" # LibreDNS - dns over https 
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://doh.libredns.gr/dns-query";
        ips = [ "116.202.176.26" ];
      };
      #Enable Blocking of certian domains.
      blocking = {
        blackLists = {
          #Adblocking
          ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
      };
      #Configure what block categories are used
      clientGroupsBlock = {
        default = [ "ads" ];
      };
    };
  };
  };


  networking.firewall.allowedTCPPorts = [ 

  8123
  8124
  6052
  22

  ];

  networking.firewall.allowPing = true;

  ###################################### OCI container

  docker-containers.hass = {
      image = "homeassistant/home-assistant:stable";
      environment = { TZ = "Europe/Prague"; };
      extraDockerOptions = ["--net=host" ];
      volumes = [ "/var/lib/homeassistant:/config" ];
  };

  docker-containers.esphome = {
      image = "esphome/esphome";
      extraDockerOptions = ["--privileged" ]; 
      volumes = [ "/var/lib/esphome:/config" ];
  };
 # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

