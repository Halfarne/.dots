{ config, pkgs, ... }:
{
    imports = [
    #./hyprland.nix
    ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "halfarne";
  home.homeDirectory = "/home/halfarne";

  #nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  nixpkgs.config.permittedInsecurePackages = [
                "electron-25.9.0"
              ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
  services.kdeconnect.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    dunst
    zathura
    kitty
    rofi-wayland
    grim
    slurp
    rpi-imager
    openscad

    #spotdl

    iamb
    vimpc
    pulsemixer
    btop
    rshell

    obsidian
    wbg
    eagle
    prusa-slicer
    libreoffice
    tmux
    mpv
    pamixer
    firefox-wayland
    wl-clipboard
    tela-circle-icon-theme
    tectonic
    qbittorrent
    jq
    socat
    playerctl
    tree
    alacritty
    arduino-cli
    cozette
    lm_sensors


  ];

  home.sessionVariables = {
    EDITOR = "nvim";

    EGL_PLATFORM = "wayland";

    _JAVA_AWT_WM_NONREPARENTING = "1";
    XCURSOR_SIZE = "24";

    XDG_SESSION_TYPE = "wayland";
    
    GDK_BACKEND = "wayland";
                          
    MOZ_DISABLE_RDD_SANDBOX = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

 
  home.file.".local/share/fonts/SpaceMono-Regular.ttf".source = ./fonts/SpaceMono-Regular.ttf ;
  home.file.".local/share/fonts/SpaceMono-Bold.ttf".source = ./fonts/SpaceMono-Bold.ttf ;
  home.file.".local/share/fonts/SpaceMono-BoldItalic.ttf".source = ./fonts/SpaceMono-BoldItalic.ttf ;
  home.file.".local/share/fonts/SpaceMono-Italic.ttf".source = ./fonts/SpaceMono-Italic.ttf ;

  programs.git = {
    enable = true;
    userName = "halfarne";
    userEmail = "halfarne@proton.me";
  };

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    ls = "ls --color=auto";
    ll = "ls -la --color=auto";
    ".." = "cd ..";
    please = "doas";
    c = "clear";
    ipv6 = "ip -6 addr show scope global";
    ssh = "kitty +kitten ssh";
    img = "kitty +kittent icat";
    time = "timedatectl | grep 'Local'";

      };
  programs.bash.bashrcExtra = 
    "
        complete -cf doas\n
        complete -cf please\n
    ";

  programs.starship.enableBashIntegration = true;

  #home.file.".hyprinitrc.sh".source = ./config/.hyprinitrc ;
  home.file.".config/autostart.sh".source = ./config/autostart.sh ;
  #hyprpaper --config ~/.config/plocha.conf 
  home.file.".config/plocha.jpg".source = ./config/plocha.jpg ;

  #services.dunst.enable = true;
  home.file.".config/dunst/dunstrc".source = ./config/dunstrc ;

  #programs.kitty.enable = true;
  home.file.".config/kitty/kitty.conf".source = ./config/kitty.conf ;

  home.file.".config/bat.sh".source = ./config/bat.sh ;

  #programs.rofi.enable = true;
  home.file.".config/rofi/config.rasi".source = ./config/config.rasi ;
  home.file.".config/rofi/themes/moje.rasi".source = ./config/moje.rasi ;
  #home.file.".config/rofi/rofi-power-menu".source = ./config/rofi-power-menu ;

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
       format = " [$symbol$state( \($name\))]($style)";
     };
  };

  programs.eww.enable = true;
  programs.eww.package = pkgs.eww-wayland;
  programs.eww.configDir = ./config/eww ;

  services.mpd-mpris.enable = true;
  services.playerctld.enable = true;

  programs.gh.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
