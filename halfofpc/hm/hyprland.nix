{ config, pkgs, ... }: 
{
wayland.windowManager.hyprland.enable = true;
wayland.windowManager.hyprland.extraConfig = ''

monitor=DP-1,2560x1440@164,2560x1440,1
##nitor=DP-2, 1920x1080, auxo, 1

exec-once = ~/.config/autostart.sh
exec-once = wbg ~/.config/plocha.jpg

    input {
    kb_layout = cz

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    gaps_in = 5
        gaps_out = 5
    border_size = 5
    col.active_border = rgba(2d6a86ff)
    col.inactive_border = rgba(192c4dcc)
    layout = dwindle
}

decoration {

    rounding = 0
 #   blur = no
 #   blur_size = 0
 #   blur_passes = 0
 #   blur_new_optimizations = on

    inactive_opacity = 1.00
    active_opacity = 1.00
    fullscreen_opacity = 1.00

    drop_shadow = false
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    bezier = wind, 0.87, 0, 0.13, 1
    bezier = wind1, 0.05, 0.9, 0.1, 1.05
    bezier = winIn, 0.27, 0.9, 0.8, 0.4 
    bezier = winOut, 0.27, 0.9, 0.8, 0.4 
    bezier = liner, 1, 1, 1, 1
    animation = windows, 1, 6, wind, slide
    animation = windowsIn, 1, 6, wind, popin 80%
    animation = windowsOut, 1, 5, wind, popin 80%
    animation = windowsMove, 1, 5, wind, slide
    animation = border, 1, 1, liner
    animation = borderangle, 1, 30, liner, loop
    animation = fade, 1, 10, default
    animation = workspaces, 1, 5, wind1
}

dwindle {
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    new_is_master = true
}

gestures {
    workspace_swipe = off
}


device:epic mouse V1 {
    sensitivity = -0.5
}

#windowrule = opacity 1.0 override 0.9 override,^(firefox)$
#windowrule = opacity 1.0 override 0.9 override,^(vlc)$
#windowrule = opacity 1.0 override 1.0 override,^(freecad)$
#windowrule = opacity 0.8 override 0.65 override,^(kitty)$

windowrulev2 = stayfocused, title:^()$,class:^(steam)$
windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$


$mainMod = SUPER


bind = $mainMod, A, exec, kitty
bind = $mainMod, K, killactive,
bind = SUPERALT, Q, exit,
bind = $mainMod, V, togglefloating,
bind = $mainMod, L, fullscreen,
bind = $mainMod, space, exec, rofi -show drun
bind = $mainMod, S, exec, rofi -show power-menu -modi power-menu:/~/.config/rofi/rofi-power-menu
bind = $mainMod, H, exec, rofi -show Pomoc -modi Pomoc:/~/.config/rofi/rofi-help-tab
bind = $mainMod, F, exec, firefox
bindr = $mainMod, P, exec, grim -g "$(slurp)"
bindr = $mainMod, C, exec, grim -g "$(slurp)" | wl-copy

bind = $mainMod,q,workspace,1
bind = $mainMod,w,workspace,2
bind = $mainMod,e,workspace,3
bind = $mainMod,r,workspace,4
bind = $mainMod,t,workspace,5

bind = $mainMod,mouse_up,workspace,e-1
bind = $mainMod,mouse_down,workspace,e+1

bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

bind = ,mouse:276,exec, pamixer -i 5
bind = ,mouse:275,exec, pamixer -d 5

bindr = ,mouse:274,exec, pamixer --source alsa_input.usb-Creative_Technology_Ltd._Live__Cam_Chat_HD_VF0790_2016021600521-02.analog-stereo -m
bind = ,mouse:274,exec, pamixer --source alsa_input.usb-Creative_Technology_Ltd._Live__Cam_Chat_HD_VF0790_2016021600521-02.analog-stereo -u
bind = $mainMod,mouse:274,exec, pamixer --source alsa_input.usb-Creative_Technology_Ltd._Live__Cam_Chat_HD_VF0790_2016021600521-02.analog-stereo -t

'';
}
