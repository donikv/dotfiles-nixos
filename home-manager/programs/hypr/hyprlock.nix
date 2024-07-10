{ config, lib, pkgs, hn, ... }:
{
  imports = [ 
    ./hyprland-environment-${hn}.nix
  ];

  home.file."Images/lock/face.png" = { source = ../../wallpapers/vector3square.png; };

  home.file.".config/hypr/macchiato.conf".text = ''
    $rosewater = rgb(f4dbd6)
    $rosewaterAlpha = f4dbd6

    $flamingo = rgb(f0c6c6)
    $flamingoAlpha = f0c6c6

    $pink = rgb(f5bde6)
    $pinkAlpha = f5bde6

    $mauve = rgb(c6a0f6)
    $mauveAlpha = c6a0f6

    $red = rgb(ed8796)
    $redAlpha = ed8796

    $maroon = rgb(ee99a0)
    $maroonAlpha = ee99a0

    $peach = rgb(f5a97f)
    $peachAlpha = f5a97f

    $yellow = rgb(eed49f)
    $yellowAlpha = eed49f

    $green = rgb(a6da95)
    $greenAlpha = a6da95

    $teal = rgb(8bd5ca)
    $tealAlpha = 8bd5ca

    $sky = rgb(91d7e3)
    $skyAlpha = 91d7e3

    $sapphire = rgb(7dc4e4)
    $sapphireAlpha = 7dc4e4

    $blue = rgb(8aadf4)
    $blueAlpha = 8aadf4

    $lavender = rgb(b7bdf8)
    $lavenderAlpha = b7bdf8

    $text = rgb(cad3f5)
    $textAlpha = cad3f5

    $subtext1 = rgb(b8c0e0)
    $subtext1Alpha = b8c0e0

    $subtext0 = rgb(a5adcb)
    $subtext0Alpha = a5adcb

    $overlay2 = rgb(939ab7)
    $overlay2Alpha = 939ab7

    $overlay1 = rgb(8087a2)
    $overlay1Alpha = 8087a2

    $overlay0 = rgb(6e738d)
    $overlay0Alpha = 6e738d

    $surface2 = rgb(5b6078)
    $surface2Alpha = 5b6078

    $surface1 = rgb(494d64)
    $surface1Alpha = 494d64

    $surface0 = rgb(363a4f)
    $surface0Alpha = 363a4f

    $base = rgb(24273a)
    $baseAlpha = 24273a

    $mantle = rgb(1e2030)
    $mantleAlpha = 1e2030

    $crust = rgb(181926)
    $crustAlpha = 181926
  '';

  home.file.".config/hypr/hyprlock.conf".text = ''
    source = $HOME/.config/hypr/macchiato.conf

    $accent = 0xb3$tealAlpha
    $accentAlpha = $tealAlpha
    $font = JetBrains Mono Regular

    # GENERAL
    general {
        disable_loading_bar = true
        hide_cursor = true
    }

    # BACKGROUND
    background {
        monitor =
        path = $HOME/Images/wallpapers/sharing_space.jpg
        blur_passes = 2
        color = $base
    }

    # TIME
    label {
        monitor =
        text = cmd[update:30000] echo "$(date +"%R")"
        color = $text
        font_size = 90
        font_family = $font
        position = -130, -100
        halign = right
        valign = top
        shadow_passes = 2
    }

    # DATE 
    label {
        monitor = 
        text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
        color = $text
        font_size = 25
        font_family = $font
        position = -130, -250
        halign = right
        valign = top
        shadow_passes = 2
    }

    # KEYBOARD LAYOUT
    label {
        monitor =
        text = $LAYOUT
        color = $text
        font_size = 20
        font_family = $font
        rotate = 0 # degrees, counter-clockwise

        position = -130, -310
        halign = right
        valign = top
        shadow_passes = 2
    }

    # USER AVATAR
    image {
        monitor = 
        path = $HOME/Images/lock/face.png
        size = 350
        border_color = $accent
        rounding = -1

        position = 0, 75
        halign = center
        valign = center
        shadow_passes = 2
    }

    # INPUT FIELD
    input-field {
        monitor =
        size = 400, 70
        outline_thickness = 4
        dots_size = 0.2
        dots_spacing = 0.2
        dots_center = true
        outer_color = $accent
        inner_color = $surface0
        font_color = $text
        fade_on_empty = false
        placeholder_text = <span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
        hide_input = false
        check_color = $accent
        fail_color = $red
        fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
        capslock_color = $yellow
        position = 0, -185
        halign = center
        valign = center
        shadow_passes = 2
    }
  '';
}
 