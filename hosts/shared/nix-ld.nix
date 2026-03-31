{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Standard libraries
      stdenv.cc.cc
      libc
      glibc
      zlib
      libjpeg
      libpng
      fuse3
      icu
      nss
      openssl
      curl
      expat

      python3

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
      libx11
      libxcursor
      libxinerama
      libxext
      libxrandr
      libxi
      libxrender
      libxtst
      libxcb
      libxcomposite
      libxdamage
      libxfixes
      libxscrnsaver

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
