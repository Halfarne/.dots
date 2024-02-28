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
    extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

  hardware.nvidia.modesetting.enable = true;
  programs.xwayland.enable = true;
  hardware.nvidia.open = false;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  ############################### Linux Zen kernel #################################
  ##################################################################################

  #boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = ["msr.allow_writes=on" ];

  #################################### Disks #######################################
  ##################################################################################

  #ntfs
  boot.supportedFilesystems = [ "ntfs" ];

   fileSystems."/mnt/500G-ssd" =
     { device = "/dev/disk/by-uuid/57A11A4670A755AC";
       fsType = "ntfs"; 
       options = [ "rw" "uid=1000" "gid=100" "umask=0022" "fmask=0022" ];
     };


  fileSystems."/mnt/Zabava" =
    { device = "/dev/disk/by-uuid/1a0ec9ad-eca1-4e16-90cb-253cd1563fd8";
      fsType = "ext4"; 
      options = ["defaults" "rw"];
    };

  fileSystems."/mnt/Dokumenty" =
    { device = "/dev/disk/by-uuid/b6d3ba3d-8f21-44d2-89c6-d4d970ed18bc";
      fsType = "btrfs"; 
      options = ["defaults" "rw"];
    };

  fileSystems."/mnt/Zalohy" =
    { device = "/dev/disk/by-uuid/2514c7e8-ef9e-442e-8d33-279c7ae2a647";
      fsType = "btrfs"; 
      options = ["defaults" "rw"];
    };

  

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
/_/|_/_//_\_\\____/___/  (this is \l)

       '';

      # The UNIX file mode bits
      mode = "0440";
    };
  };
  ##################################### Packages ######################################
  #####################################################################################
  
  nixpkgs.config = {
      packageOverrides = pkgs: {
        steam = pkgs.steam.override {
            extraPkgs = pkgs: with pkgs; [
                xorg.libXcursor
                xorg.libXi
                xorg.libXinerama
                xorg.libXScrnSaver
                libpng
                libpulseaudio
                libvorbis
                stdenv.cc.cc.lib
                libkrb5
                keyutils
              ];
        };
      };
    };

  environment.systemPackages = with pkgs; [

     gh
     git
     gcc

     home-manager

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
     mesa

     parted

     #minicom
     #libusb1
     #openocd
     #cmake
     #gcc-arm-embedded
     #pico-sdk
     #picotool

     rshell

     steam
     gamescope
     dxvk
     wineWowPackages.unstable
     #wineWowPackages.waylandFull
     winetricks
     mangohud


     nvidia-vaapi-driver
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
        overrideFolders = false;
        overrideDevices = false;
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

