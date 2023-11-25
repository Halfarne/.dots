{ config, pkgs, ... }: let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  hyprland = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;
in {
    imports = [
    hyprland.homeManagerModules.default
    ./hyprland.nix
    ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "halfarne";
  home.homeDirectory = "/home/halfarne";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    dunst
    zathura
    kitty
    rofi-wayland
    monocraft
    grim
    slurp
    rpi-imager
    openscad
    librecad
    spotdl
    vlc
    iamb
    vimpc
    pulsemixer
    btop
    rshell
    lutris
    steam
    prismlauncher
    obsidian
    wbg
    qt5ct
    libsForQt5.qtstyleplugin-kvantum
    eagle
    prusa-slicer
    libreoffice
    tmux
    mpv
    pamixer
    firefox-wayland
    wl-clipboard
    mangohud
#tela-circle-icon-theme
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/halfarne/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.overlays = [ (self: super: { bndg = super.callPackage ./packages/breeze-noir-dark-gtk {}; }) ];

  gtk.enable = true;
  gtk.theme.package = pkgs.bndg;
  gtk.theme.name = "Breeze-Noir-Dark-GTK";
  
  gtk.font = {
    name = "Space Mono";
    size = 11;
  };
  gtk.iconTheme.name = "Tela-circle-dark";

  programs.git = {
    enable = true;
    userName = "halfarne";
    userEmail = "halfarne@proton.me";
  };

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    ls = "ls --color=auto";
    please = "doas";
    c = "clear";
    ipv6 = "ip -6 addr show scope global";
    ssh = "kitty +kitten ssh";
    time = "timedatectl | grep 'Local'";

    nixupd = "please  cp ~/.dotfiles/conf.nix /etc/nixos/conf.nix";
    nixreb = "please nixos-rebuild switch";
      };
  programs.bash.bashrcExtra = 
    "
        complete -cf doas\n
        complete -cf please\n
    ";

  programs.starship.enableBashIntegration = true;

  home.file.".hyprinitrc".source = ./config/.hyprinitrc ;
  home.file.".config/autostart.sh".source = ./config/autostart.sh ;
#hyprpaper --config ~/.config/plocha.conf 
  home.file.".config/plocha.jpg".source = ./config/plocha.jpg ;

  #services.dunst.enable = true;
  home.file.".config/dunst/dunstrc".source = ./config/dunstrc ;
  #programs.kitty.enable = true;
  home.file.".config/kitty/kitty.conf".source = ./config/kitty.conf ;

  #programs.rofi.enable = true;
  home.file.".config/rofi/config.rasi".source = ./config/config.rasi ;
  home.file.".config/rofi/themes/mujstyl.rasi".source = ./config/moje.rasi ;
  home.file.".config/rofi/rofi-power-menu".source = ./config/rofi-power-menu ;

  #programs.zathura.enable = true;
  home.file.".config/zathura/zathurarc".source = ./config/zathurarc ;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  home.file.".config/nvim/init.lua".source = ./config/nvim.lua ;
  home.file.".config/nvim/colors/mytheme.vim".source = ./config/mytheme.vim ;

  home.file.".tmux.conf".source = ./config/tmux.conf ;

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


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
