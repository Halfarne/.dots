{ config, pkgs, lib, inputs,  ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix #(in /etc/nixos/configuration.nix)
    ];

  # Boot
  boot.loader.grub.enable = true;
 
  # NVIDIA
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  programs.xwayland.enable = true;

  ############################### Linux kernel #################################
  ##################################################################################

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = ["msr.allow_writes=on" ];

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

  ################################# User Settings ###################################
  ###################################################################################


  # User
   users.users.halfarne = {
    isNormalUser = true;
    description = "halfarne";
    extraGroups = [ "networkmanager" "wheel" "audio" "disk" "video" "input" "dialout" "render"];
    packages = with pkgs; [];
    uid = 1000;
  };

  environment.shellAliases = {
      please = "doas";
      sudo = "doas";
      nixreb = "nixos-rebuild switch --flake /etc/nixos#halfofpc";
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

  # Pam oauth
  #security.pam.oath.enable = true;
  #security.pam.enableOTPW = true;


  # SSID
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Hostname
  networking.hostName = "halfofnt"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "cs_CZ.UTF-8";
   console = {
     keyMap = "cz";
     packages=[ pkgs.terminus_font ];
     font="${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";

     };

   services.udev.extraRules = ''
    SUBSYSTEM=="usb", MODE="0666"
    '';


  #console.keyMap = "cz-lat2";

  ##################################### /etc/issue ####################################
  #####################################################################################
  environment.etc = {
  # Creates /etc/issue
  issue = {
      text = ''
   _  ___      ____  ____
  / |/ (_)_ __/ __ \/ __/
 /    / /\ \ / /_/ /\ \  
/_/|_/_//_\_\\____/___/  laptop :) (this is \l)

       '';

      # The UNIX file mode bits
      mode = "0440";
    };
  };
  ##################################### Packages ######################################
  #####################################################################################
  
  environment.systemPackages = with pkgs; [

     gh
     git
     gcc

     home-manager

     #cargo
     #rustc

     python3

     btop
     starship
     wget
     kitty
     dunst
     #gparted
     zip
     unzip
     bashmount
     exfatprogs
     tmux
     mesa

     rshell

     libva
     libinput

     wbg
     wl-clipboard

     qt5ct
     libsForQt5.qtstyleplugin-kvantum

     #monocraft

     neovim
     zathura

     jmtpfs
     mtpfs

     stig

     blueman
  ];

  nixpkgs.config.permittedInsecurePackages = [
                "electron-25.9.0"
  ];

  ############################################# Nix-ld #############################################
  ##################################################################################################
 
  programs.nix-ld.enable = true;

  #programs.nix-ld.package = pkgs.callPackage ../nix-ld.nix {};

  ##################################### Programs and Services ######################################
  ##################################################################################################

  # Fonts
  fonts.packages = with pkgs; [
   (nerdfonts.override { fonts = [ "Mononoki" "Hack"]; })
  ];

  # Blueman
  services.blueman.enable = true;

  #XDG
    xdg.portal = {
	    enable = true;
	    wlr.enable = true;
	    # gtk portal needed to make gtk apps happy
	    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	    config.common.default = "*";
	  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  services.transmission.enable = true;

  # Starship
  programs.starship.enable = true;
  programs.starship.settings = {
     add_newline = false;
     format = "$username$hostname$nix_shell $directory$character ";
     username = {
        format = "[\\[$user](white bold)";
        disabled = false;
        show_always = true;
     };
     hostname = {
        ssh_only = false;
        format = "[@$hostname\\]](white bold)";
     };
     directory = {
       read_only = " x";
       truncation_length = 0;
       style = "bold red";
     };
     character = {
       success_symbol = "[\\$](white bold)";
       error_symbol = "[\\$](red bold)";
     };
     nix_shell = {
       symbol = "❄(bold white)";
       style = "bold blue";
       format = " [$symbol$state( \($name\))]($style)";
     };
  };

  # NetworkManager
  networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  #udisk
  services.udisks2.enable=true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  services.mpd = {
   enable = true;
   musicDirectory = "/home/halfarne/Syncthing/Hudba";
   user = "halfarne";
   extraConfig = ''
      audio_output {
      type "pipewire"
      name "Pipewire"
      }
   '';
   network.listenAddress = "any"; 
   startWhenNeeded = true; 
  };
  systemd.services.mpd.environment = {
  XDG_RUNTIME_DIR = "/run/user/1000";
  };

  
  #Syncthing
  services = {
    syncthing = {
        enable = true;
        user = "halfarne";
        dataDir = "/home/halfarne/Syncthing";    # Default folder for new synced folders
        configDir = "/home/halfarne/Syncthing/.config";   # Folder for Syncthing's settings and keys
    };
  };

  services.syncthing.settings.gui = {
    user = "halfarne";
    password = "halfarne";
  };

  # Pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
   enable = true;
   alsa.enable = true;
   alsa.support32Bit = true;
   pulse.enable = true;
   jack.enable = true;
   wireplumber.enable = true;
  };

  networking.firewall = {
    enable = true;
    #allowedTCPPorts = [ 22 ];
  };
  networking.firewall = {
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #system.stateVersion = config.system.nixos.22.11; # Did you read the comment?
  system.stateVersion = "23.11"; # Did you read the comment?

}

