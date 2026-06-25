{
  pkgs,
  lib,
  hostName,
  ...
}:

{
  programs.firefox = {
    enable = true;

    preferences = {
      # Hardware acceleration settings
      "media.ffmpeg.vaapi.enabled" = true;
      "media.rdd-ffmpeg.enabled" = true;
      "media.rdd-vaapi.enabled" = true;
      "media.hardware-video-decoding.force-enabled" = true;
      "media.navigator.mediadatadecoder_vpx_enabled" = true;
      "widget.dmabuf.force-enabled" = true;
      "gfx.webrender.all" = true;

      # Privacy and performance
      "privacy.webrtc.legacy_global_indicator" = false;
    };

    languagePacks = [ "nb-NO" ];
  };
}
