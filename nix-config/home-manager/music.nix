{
  config,
  lib,
  ...
}: {
  # MPD daemon + rmpc TUI client. No audio_output block: MPD auto-detects the
  # CoreAudio output when none is configured.
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
  };

  # home-manager's launchd agent for mpd has no equivalent of the systemd
  # unit's ExecStartPre mkdir, so mpd exits on first start with "failed to
  # open log file". Create the dirs it expects at activation instead.
  home.activation.mpdDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p ${lib.escapeShellArgs [
      "${config.home.homeDirectory}/Library/Logs/mpd"
      config.services.mpd.playlistDirectory
    ]}
  '';

  # rmpc's config.ron is stowed from mac-config so it can change without a
  # nix rebuild; keep programs.rmpc.config empty to avoid clobbering it.
  programs.rmpc.enable = true;
}
