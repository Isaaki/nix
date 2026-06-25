{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lmms-full
    surge-xt
    reaper
  ];

  xdg.desktopEntries.reaper = {
    name = "REAPER";
    genericName = "Digital Audio Workstation";
    exec = "env GDK_BACKEND=x11 pw-jack reaper %F";
    icon = "reaper";
    categories = [
      "AudioVideo"
      "Audio"
      "Recorder"
    ];
    mimeType = [ "application/x-reaper-project" ];
  };
}
