{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./hyprland-environment.nix
  ];

  home.file.".config/kitty/kitty.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
        before_sleep_cmd = loginctl lock-session    # lock before suspend.
        after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
    }

    listener {
        timeout = 10                               # 3min.
        on-timeout = brightnessctl -s set 15%        # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = brightnessctl -r                 # monitor backlight restore.
    }

    # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
    listener {
        timeout = 10                                                # 3min.
        on-timeout = brightnessctl -sd platform::kbd_backlight set 0 # turn off keyboard backlight.
        on-resume = brightnessctl -rd platform::kbd_backlight        # turn on keyboard backlight.
    }

    listener {
        timeout = 20                                 # 5min
        on-timeout = loginctl lock-session            # lock screen when timeout has passed
    }

    listener {
        timeout = 30                                 # 5.83min
        on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
        on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
    }

    listener {
        timeout = 420                                 # 7min
        on-timeout = systemctl suspend                # suspend pc
    }
  ''
};