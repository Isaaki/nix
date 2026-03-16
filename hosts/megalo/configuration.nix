{ config, pkgs, lib, username, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = false;
    limine.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "nixos-megalo";
  networking.networkmanager.enable = true;

  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="module", KERNEL=="maccel", RUN+="/bin/sh -c 'chgrp -R maccel /sys/module/maccel/parameters/ && chmod -R g+w /sys/module/maccel/parameters/'"
    '';
  };

  programs = {
    fish.enable = true;
    niri.enable = true;
    kdeconnect.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    dms-shell = {
      enable = true;
      quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
      systemd.enable = true;
      systemd.restartIfChanged = true;
      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableClipboardPaste = true;
    };
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_MENU_PREFIX = "plasma-";
    };

    etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    systemPackages = with pkgs; [
      git vim curl wget pciutils usbutils wirelesstools
      kdePackages.discover
      kdePackages.kcalc
      kdePackages.kcharselect
      kdePackages.kclock
      kdePackages.kcolorchooser
      kdePackages.kolourpaint
      kdePackages.ksystemlog
      kdePackages.sddm-kcm
      kdiff3
      polkit_gnome
      kdePackages.isoimagewriter
      kdePackages.partitionmanager
      hardinfo2
      wayland-utils
      wl-clipboard
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.niri.default = lib.mkForce [ "kde" "gnome" "gtk" ];
  };

  systemd.user.services.dms.serviceConfig.Environment = [ "QT_QPA_PLATFORMTHEME=qt6ct" ];

  users = {
    users.${username} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "maccel" ];
      shell = pkgs.fish;
    };
    groups.maccel = {};
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    maccel = {
      enable = true;
      enableCli = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
