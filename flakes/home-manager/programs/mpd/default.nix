{ config, pkgs, ... }: {

  services.mpd = {
    enable = true;
    musicDirectory = "$HOME/Music";
    extraConfig = ''
    audio_output {
      type "pulse"
      name "Pulseaudio"
      mixer_type      "hardware"      # optional
      mixer_device    "default"       # optional
      mixer_control   "PCM"           # optional
      mixer_index     "0"             # optional
    }  '';

    # Optional:
    network.listenAddress = "any"; # if you want to allow non-localhost connections
    #startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  };

}