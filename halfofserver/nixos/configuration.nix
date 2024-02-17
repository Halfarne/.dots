{ config, pkgs, lib,  ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      #./hardware-configuration.nix #(in /etc/nixos/configuration.nix)
    ];

  # Boot
  boot.loader.grub.device = "/dev/disk/by-id/ata-WDC_WD3200BEVT-22A23T0_WD-WX91A4030606";

  ############################### Linux Zen kernel #################################
  ##################################################################################

  boot.kernelPackages = pkgs.linuxPackages_5_4;

  ############################### Nix configuration ################################
  ##################################################################################

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Overlay Packages
  # nixpkgs.overlays = [ (import ./packages) ];

 

  ################################# User Settings ###################################
  ###################################################################################


  # User
   users.users.adamstoctyricet = {
    isNormalUser = true;
    description = "adamstoctyricet";
    extraGroups = [ "networkmanager" "wheel" "audio" "disk" "video" "input" "dialout"];
    packages = with pkgs; [];
  };

  environment.shellAliases = {
      please = "doas";
      sudo = "doas";
      nreb = "nixos-rebuild switch --flake /etc/nixos#halfofpc";
  };

  programs.dconf.enable = true;

  # Doas
  # Enable doas instead of sudo
  security.doas.enable = true;
  security.sudo.enable = false;

     # Configure doas
     security.doas.extraRules = [{
        users = [ "adamstoctyricet" ];
        keepEnv = true;
  	    persist = true;
     }];


  # SSID
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  #turn off screen
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Hostname
  networking.hostName = "halfofserver"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "cs_CZ.UTF-8";
   console = {
     font = "monocraft";
     keyMap = "cz-lat2";
   };

  #console.keyMap = "cz-lat2";

  ##################################### /etc/issue ####################################
  #####################################################################################
  environment.etc = {
  # Creates /etc/nanorc
  issue = {
      text = ''
   _  ___      ____  ____
  / |/ (_)_ __/ __ \/ __/
 /    / /\ \ / /_/ /\ \  
/_/|_/_//_\_\\____/___/  (server)

       '';

      # The UNIX file mode bits
      mode = "0440";
    };
  };
  ##################################### Packages ######################################
  #####################################################################################

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

     gh
     git
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
     ngrok

     monocraft

     neovim

     pamixer

     blueman

     xmrig
     powertop
  ];

  ##################################### Programs and Services ######################################
  ##################################################################################################

  # Fonts
  fonts.fonts = with pkgs; [
   (nerdfonts.override { fonts = [ "Mononoki" ]; })
  ];

  # Blueman
  services.blueman.enable = true;

  # Java
  programs.java.enable = true;

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

  # NetworkManager
  networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  #udisk
  services.udisks2.enable=true;

  #Syncthing
  services = {
    syncthing = {
        enable = true;
        user = "adamstoctyricet";
        dataDir = "/home/adamstoctyricet/Syncthing";    # Default folder for new synced folders
        configDir = "/home/adamstoctyricet/Syncthing/.config";   # Folder for Syncthing's settings and keys
    };
  };
  services.syncthing.extraOptions.gui = {
    theme = "black";
    user = "adamstoctyricet";
    password = "adamstoctyricet";
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #system.stateVersion = config.system.nixos.22.11; # Did you read the comment?

}
