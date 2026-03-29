{ pkgs, lib, hostName, ... }:

{
  programs.firefox = {
    enable = true;

    # Host-specific package override for iGPU video decoding on Megalo
    package = if hostName == "megalo" then 
      pkgs.firefox.overrideAttrs (oldAttrs: {
        buildCommand = (oldAttrs.buildCommand or "") + ''
          wrapProgram $out/bin/firefox \
            --set DRI_PRIME "pci-0000_0f_00_0" \
            --set LIBVA_DRIVER_NAME "radeonsi" \
            --set MOZ_DRM_DEVICE "/dev/dri/renderD129" \
            --set MOZ_VAAPI_DEVICE "/dev/dri/renderD129" \
            --set MOZ_DISABLE_RDD_SANDBOX "1" \
            --set MOZ_ENABLE_WAYLAND "1"
        '';
      })
    else 
      pkgs.firefox;

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

  # Host-specific desktop item for Megalo
  environment.systemPackages = lib.optional (hostName == "megalo") (
    pkgs.makeDesktopItem {
      name = "firefox-igpu";
      desktopName = "Firefox (iGPU)";
      exec = "env DRI_PRIME=pci-0000_0f_00_0 LIBVA_DRIVER_NAME=radeonsi MOZ_DRM_DEVICE=/dev/dri/renderD129 MOZ_DISABLE_RDD_SANDBOX=1 MOZ_ENABLE_WAYLAND=1 firefox %U";
      icon = "firefox";
      terminal = false;
      categories = [ "Network" "WebBrowser" ];
    }
  );
}
