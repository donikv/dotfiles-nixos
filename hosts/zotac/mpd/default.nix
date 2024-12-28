{ config, pkgs, ... }: {

  services.mpd = {
    enable = true;
    musicDirectory = "/home/donik/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';
    #user = "donik";
    # Optional:
    network.listenAddress = "any"; # if you want to allow non-localhost connections
    startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  };
  services.mpd.user = "donik";
  systemd.services.mpd.environment = {
      # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
      XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.donik.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
  };
}