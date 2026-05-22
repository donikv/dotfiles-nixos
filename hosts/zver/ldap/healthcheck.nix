# logind-healthcheck.nix
#
# A NixOS module that periodically checks whether systemd-logind is
# responsive, and restarts it ONLY if it fails several consecutive probes.
#
# Why the "several probes" logic matters:
#   Restarting systemd-logind tears down user sessions, which can kill
#   long-running processes attached to those sessions (for example, an
#   attached `screen` or `tmux` session). A healthcheck whose failure
#   mode is that disruptive must be very confident before it acts, so a
#   single transient D-Bus hiccup must never be enough to trigger a
#   restart.
#
# Import this file from your configuration.nix / flake module list, e.g.:
#   imports = [ ./logind-healthcheck.nix ];

{ config, lib, pkgs, ... }:

let
  # ------------------------------------------------------------------
  # The healthcheck program itself.
  #
  # `writeShellScriptBin "NAME" "BODY"` builds a package containing a
  # single executable at `bin/NAME`. We then reference that executable
  # below as `${logindHealthcheck}/bin/logind-healthcheck`.
  #
  # Note that `busctl` and `systemctl` both ship with systemd, so we
  # pull them from `pkgs.systemd` and splice in their absolute store
  # paths. This makes the script independent of whatever PATH the
  # systemd service happens to run with.
  # ------------------------------------------------------------------
  logindHealthcheck = pkgs.writeShellScriptBin "logind-healthcheck" ''
    set -o nounset
    set -o pipefail

    # --- configuration -------------------------------------------------
    # Number of consecutive failed probes required before we take the
    # disruptive step of restarting logind, and the pause between them.
    probes=3
    probe_delay=5
    bus_name="org.freedesktop.login1"

    # Absolute paths, baked in at build time. Both tools come from
    # systemd; `bustle` (used in the original) is an unrelated D-Bus
    # traffic viewer and was the source of the earlier bug.
    busctl="${pkgs.systemd}/bin/busctl"
    systemctl="${pkgs.systemd}/bin/systemctl"

    # --- probe loop ----------------------------------------------------
    # Try the probe up to `probes` times. The moment any single probe
    # succeeds, logind is healthy and we exit immediately with success.
    attempt=1
    while [ "$attempt" -le "$probes" ]; do
      if "$busctl" status "$bus_name" >/dev/null 2>&1; then
        # Healthy — nothing to do.
        exit 0
      fi

      echo "logind-healthcheck: probe $attempt/$probes failed" >&2

      # Avoid an unnecessary sleep after the final failed probe.
      if [ "$attempt" -lt "$probes" ]; then
        sleep "$probe_delay"
      fi

      attempt=$((attempt + 1))
    done

    # --- remediation ---------------------------------------------------
    # Reached only if EVERY probe failed. Now we accept the cost of a
    # restart, because logind genuinely appears to be unresponsive.
    echo "logind-healthcheck: $bus_name unresponsive after $probes probes; restarting systemd-logind" >&2

    if "$systemctl" restart systemd-logind; then
      echo "logind-healthcheck: systemd-logind restarted" >&2
      exit 0
    else
      echo "logind-healthcheck: failed to restart systemd-logind" >&2
      exit 1
    fi
  '';

in
{
  # --------------------------------------------------------------------
  # The oneshot service that runs the healthcheck once when triggered.
  #
  # `Type = "oneshot"` tells systemd this is a run-to-completion task,
  # not a long-lived daemon, so the unit is considered "done" when the
  # script exits rather than staying "active".
  # --------------------------------------------------------------------
  systemd.services.logind-healthcheck = {
    description = "Restart systemd-logind if unresponsive";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${logindHealthcheck}/bin/logind-healthcheck";
    };
  };

  # --------------------------------------------------------------------
  # The timer that triggers the service.
  #
  # `OnCalendar = "*-*-* 03:00:00"` means every day at 03:00. `Persistent`
  # means that if the machine was asleep or off at 03:00, the job runs
  # once shortly after the next boot instead of being skipped entirely.
  # --------------------------------------------------------------------
  #systemd.timers.logind-healthcheck = {
  #  wantedBy = [ "timers.target" ];
  #  timerConfig = {
  #    OnCalendar = "*-*-* 03:00:00";
  #    Persistent = false;
  #  };
  #};
}
