{ config, pkgs, lib, inputs,  ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix #(in /etc/nixos/configuration.nix)
    ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  #boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # NVIDIA
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport = true; 
    driSupport32Bit = true;
    };

  hardware.nvidia.modesetting.enable = true;
  programs.xwayland.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  ############################### Linux Zen kernel #################################
  ##################################################################################

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = ["msr.allow_writes=on"];

  #################################### Disks #######################################
  ##################################################################################

  #ntfs
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/mnt/500G-ssd" =
    { device = "/dev/disk/by-uuid/57A11A4670A755AC";
      fsType = "ntfs"; 
      options = [ "rw" "uid=1000" "gid=100" "umask=0022" "fmask=0022" ];
    };

  #ext3
  fileSystems."/mnt/1TB-hdd" =
    { device = "/dev/disk/by-uuid/29788cf6-33b0-45a7-8ee0-a5368cb4e723";
      fsType = "ext3"; 
      options = ["defaults" "rw"];
    };

   # ...
   #fileSystems."/nix" = {
   #  device = "/dev/disk/by-uuid/019e842a-5d1b-4836-8170-d67230765e9b";
   #  fsType = "btrfs";
   #  neededForBoot = true;
   #  options = [ "noatime" ];
   #};
 

  

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
  networking.hostName = "halfofpc"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "cs_CZ.UTF-8";
   console = {
     font = "monocraft";
     keyMap = "cz-lat2";
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
/_/|_/_//_\_\\____/___/  (this is \l)

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

     #cargo
     #rustc

     jdk17
     #jre

     python3

     btop
     starship
     wget
     kitty
     dunst
     #gparted
     nitch
     zip
     unzip
     bashmount
     exfatprogs
     tmux

     #minicom
     #libusb1
     #openocd
     #cmake
     #gcc-arm-embedded
     #pico-sdk
     #picotool

     rshell

     #lutris
     steam
     #steamtinkerlaunch
     #prismlauncher
     dxvk
     #wineWowPackages.unstable
     wineWowPackages.waylandFull
     winetricks
     mangohud

     #obsidian

     nvidia-vaapi-driver
     libva
     libinput

     wbg
     wl-clipboard

     #tela-circle-icon-theme
     #rofi-wayland
     #firefox-wayland
     #iamb
     qt5ct
     libsForQt5.qtstyleplugin-kvantum

     #monocraft

     neovim
     #grim
     #slurp

     #pamixer
     #pulsemixer

     #mpv
     #vimpc

     #onlyoffice-bin
     zathura

     jmtpfs
     mtpfs

     #freecad
     #openscad
     #librecad
     #eagle
     #prusa-slicer
 
     blueman
  ];

  nixpkgs.config.permittedInsecurePackages = [
                "electron-24.8.6"
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
  # KDEconnect
  #programs.kdeconnect.enable = true;

  # Java - 19
  #programs.java.enable = true;

  # Steam
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
  };


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
       format = "[$symbol$state( \($name\))]($style)";
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
   musicDirectory = "/mnt/1TB-hdd/Hudba";
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
  XDG_RUNTIME_DIR = "/run/user/1001";
  };

  
  #Syncthing
  services = {
    syncthing = {
        enable = true;
        user = "halfarne";
        dataDir = "/mnt/1TB-hdd/Syncthing";    # Default folder for new synced folders
        configDir = "/mnt/1TB-hdd/Syncthing/.config";   # Folder for Syncthing's settings and keys
    };
  };

  services.syncthing.settings.gui = {
    user = "halfarne";
    password = "halfarne";
  };

  # Pipewore
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

