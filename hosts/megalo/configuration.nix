{
  config,
  pkgs,
  lib,
  username,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/nh.nix
    ../shared/maccel.nix
    ../shared/gnome-keyring.nix
    ../shared/firefox.nix
    ../shared/nix-ld.nix
    ../shared/cachix.nix
    ../shared/docker.nix
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

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      fira-code
    ];
  };

  services = {
    blueman.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    xserver.enable = true;
    xserver.videoDrivers = [
      "nvidia"
      "amdgpu"
    ];
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.niri}/bin/niri-session";
          user = "${username}";
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
          user = "greeter";
        };
      };
    };
    udev.extraRules = ''
      # PINCE udev rule
      SUBSYSTEM=="input", KERNEL=="event*", GROUP="input", MODE="0660"
    '';
  };

  programs = {
    fish.enable = true;
    niri.enable = true;
    kdeconnect.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      # extraCompatPackages = with pkgs; [
      #   inputs.nix-proton-cachyos.packages.${system}.proton-cachyos
      # ];
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

      DRI_PRIME = "1";
    };

    systemPackages = with pkgs; [
      git
      vim
      curl
      wget
      pciutils
      usbutils
      wirelesstools
      qalculate-gtk
      kdiff3
      polkit_gnome
      hardinfo2
      gnome-disk-utility
      wayland-utils
      wl-clipboard
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.niri = {
      default = lib.mkForce [ "gtk" ];
      # Use GNOME specifically for the things Niri recommends it for
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];

      # Explicitly force GTK for the file picker
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  users = {
    users.${username} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "tty"
        "input"
      ];
      shell = pkgs.fish;
    };
  };

  hardware = {
    bluetooth.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      prime = {
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:15:0:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    xone.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        # AMD specific drivers for hardware accel
        libva
        mesa
      ];
    };
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  # This ensures the AMD driver is loaded early so Firefox can see it

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11";
}
