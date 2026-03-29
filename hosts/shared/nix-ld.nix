{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Standard libraries
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
      
      # Graphics & UI
      libglvnd
      libGL
      mesa
      fontconfig
      freetype
      dbus
      libuuid
      libusb1
      udev
      
      # X11 libraries
      xorg.libX11
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXext
      xorg.libXrandr
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXfixes
      xorg.libXScrnSaver
      
      # Wayland
      wayland
      libxkbcommon
      
      # Audio
      libpulseaudio
      alsa-lib
      pipewire
      
      # Common game dependencies
      libcap
      SDL2
      SDL2_image
      SDL2_ttf
      SDL2_mixer
      vulkan-loader
      gnome-desktop
    ];
  };
}
