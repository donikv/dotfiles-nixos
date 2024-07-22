{ config, lib, pkgs, ... }:

{
    programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
               * {
                 font-family: "JetBrainsMono Nerd Font";
                 font-size: 12pt;
                 font-weight: bold;
                 border-radius: 20px;
                 background-color: transparent;
                 transition-property: background-color;
                 transition-duration: 0.5s;
                 opacity: 1.0;
               }
               @keyframes blink_red {
                 to {
                   background-color: rgb(242, 143, 173);
                   color: rgb(26, 24, 38);
                 }
               }
               .warning, .critical, .urgent {
                 animation-name: blink_red;
                 animation-duration: 1s;
                 animation-timing-function: linear;
                 animation-iteration-count: infinite;
                 animation-direction: alternate;
               }
               window#waybar {
                  background-color: rgba(0,0,0,1.0);
                  border-bottom: 0px solid #ffffff;
                  /* color: #FFFFFF; */
                  background: transparent;
                  opacity: 0.9;
               }
               window > box {
                 margin-left: 5px;
                 margin-right: 5px;
                 margin-top: 5px;
                 background-color: #1e1e2a;
                 padding: 3px;
                 padding-left:8px;
                 border: 2px none #33ccff;
                 opacity: 0.95;
               }
         #workspaces {
                 padding-left: 0px;
                 padding-right: 0px;
                 border-radius: 20px;
                 background-color: #1a1a1a;
                 opacity: 1.0;
               }
         #workspaces button {
                 padding-top: 4px;
                 padding-bottom: 4px;
                 padding-left: 16px;
                 padding-right: 16px;
                 border-radius: 20px;
               }
         #workspaces button.active {
                 background-color: rgb(181, 232, 224);
                 color: rgb(26, 24, 38);
               }
         #workspaces button.urgent {
                 color: rgb(26, 24, 38);
               }
         /* #workspaces button:hover {
                 background-color: rgb(248, 189, 150);
                 color: rgb(26, 24, 38);
               }
               tooltip {
                 background: rgb(48, 45, 65);
               }
               tooltip label {
                 color: rgb(217, 224, 238);
               } */
         #custom-launcher {
                 font-size: 20px;
                 padding-left: 8px;
                 padding-right: 6px;
                 color: #7ebae4;
               }
         #mode, #hyprland-language, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                 padding-left: 10px;
                 padding-right: 10px;
               }
               /* #mode { */
               /* 	margin-left: 10px; */
               /* 	background-color: rgb(248, 189, 150); */
               /*     color: rgb(26, 24, 38); */
               /* } */
         #memory {
                 color: rgb(181, 232, 224);
               }
         #cpu {
                 color: rgb(245, 194, 231);
               }
         #clock {
                 color: rgb(217, 224, 238);
               }
        /* #idle_inhibitor {
                 color: rgb(221, 182, 242);
               }*/
         #custom-wall {
                 color: #33ccff;
            }
         #hyprland-language {
                 color: rgb(150, 205, 251);
               }
         #temperature, #battery, #hyprland-language {
                 color: rgb(150, 205, 251);
               }
         #backlight {
                 color: rgb(248, 189, 150);
               }
         #pulseaudio {
                 color: rgb(245, 224, 220);
               }
         #network {
                 color: #ABE9B3;
               }
         #network.disconnected {
                 color: rgb(255, 255, 255);
               }
         #custom-powermenu {
                 color: rgb(242, 143, 173);
                 padding-right: 16px;
               }
         #tray {
                 padding-right: 8px;
                 padding-left: 10px;
               }
         #mpd.paused {
                 color: #414868;
                 font-style: italic;
               }
         #mpd.stopped {
                 background: transparent;
               }
         #mpd {
                 color: #c0caf5;
               }
         #custom-cava-internal{
                 font-family: "JetBrainsMono Nerd Font" ;
                 color: #33ccff;
               }
          #modules-left{
            background-color: #1a1a1a;
            opacity: 1.0;
          }
      '';
      settings = [{
        "layer" = "top";
        "position" = "top";
        modules-left = [
          "custom/launcher"
          "temperature"
          #"mpd"
          "custom/cava-internal"         
          #"hyprland/workspaces"
          "tray"
        ];
        modules-center = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "memory"
          "cpu"
          "battery"
          "hyprland/language"
          "network"
          "clock"
          "custom/powermenu"
        ];
        "custom/launcher" = {
          "format" = " ";
          "on-click" = "pkill rofi || rofiWindow";
          "on-click-middle" = "exec default_wall";
          "on-click-right" = "exec wallpaper_random";
          "tooltip" = false;
        };
        "custom/cava-internal" = {
          "exec" = "sleep 1s && cava-internal";
          "tooltip" = false;
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{icon} {volume}%";
          "format-muted" = "󰖁 Muted";
          "format-icons" = {
            "default" = [ "" "" "" ];
          };
          "on-click" = "pamixer -t";
          "tooltip" = false;
        };
        "hyprland/language"=  {
          "format" = "{short}";
          "keyboard-name" = "at-translated-set-2-keyboard";
          "on-click" = "switch_lang";
        };
        "battery" = {
        	"interval" = 1;
        	"states" = {
        		"warning" = 25;
        		"critical" = 10;
        	};
        	"format" = "{icon} {capacity}%";
        	"format-icons" = {
            "default" = ["" "" "" "" ""];
          }; 
          "format-time"= "{H}h{M}m";
          "format-charging"= "{icon} {capacity}% ";
          "format-full"= "Charged ";
        	#"max-length"= 25;
          "tooltip" = true;
          "tooltip-format" = "Time remaining: {time}";
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%H:%M}"; #
          "format-alt" = "{:%A, %B %d, %Y (%R)}";
          "tooltip" = true;
          "tooltip-format"= "<tt>{calendar}</tt>";
          "calendar"= {
        		"mode" ="year";
        		"mode-mon-col"  = 3;
        		"weeks-pos"     = "right";
        		"on-scroll"     = 1;
        		"on-click-right"= "mode";
        		"format"= {
        			"months"=     "<span color='#ffead3'><b>{}</b></span>";
        			"days"=       "<span color='#ecc6d9'><b>{}</b></span>";
        			"weeks"=      "<span color='#99ffdd'><b>W{}</b></span>";
        			"weekdays"=   "<span color='#ffcc66'><b>{}</b></span>";
        			"today"=      "<span color='#ff6699'><b><u>{}</u></b></span>";
        		};
          };
        };
        "hyprland/workspaces"= {
          "format"= "{name}: {icon}";
          "format-icons"= {
            "1"= "";
            "2"= "";
            "3"= "";
            "4"="󰉋";
            "8"= "";
            "9"= "";
            "active"= "";
            "default"= "";
          };
          "sort-by-number"= true;
        };
        "memory" = {
          "interval" = 1;
          "format" = "󰻠 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = "󰍛 {usage}%";
        };
        "mpd" = {
          "max-length" = 25;
          "format" = "<span foreground='#bb9af7'></span> {title}";
          "format-paused" = " {title}";
          "format-stopped" = "<span foreground='#bb9af7'></span>";
          "format-disconnected" = "";
          "on-click" = "mpc --quiet toggle";
          "on-click-right" = "mpc update; mpc ls | mpc add";
          "on-click-middle" = "kitty --class='ncmpcpp' ncmpcpp ";
          "on-scroll-up" = "mpc --quiet prev";
          "on-scroll-down" = "mpc --quiet next";
          "smooth-scrolling-threshold" = 5;
          "tooltip-format" = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
        };
        "network" = {
          "format-disconnected" = "󰯡 Disconnected";
          "format-ethernet" = "󰒢 Connected!";
          "format-linked" = "󰖪 {essid} (No IP)";
          "format-wifi" = "󰖩 {essid}";
          "interval" = 1;
          "tooltip" = false;
          "on-click" = "exec nm-applet --indicator";
        };
        "custom/powermenu" = {
          "format" = "";
          "on-click" = "pkill rofi || rofi -window-title powermenu -yoffset \"5\" -xoffset \"-100\" -show p -modi p:'powermenu --symbols-font \"Symbols Nerd Font Mono\"' -font \"JetBrains Mono NF 16\" -theme ~/.config/rofi/theme.rasi -theme-str 'window {width: 32em;location: northeast;anchor: northeast;x-offset: -5px; y-offset: 2px;} listview {lines: 6;}'"; #~/.config/rofi/powermenu/type-3/powermenu.sh";
          "tooltip" = false;
        };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };
      }];
    };
}
