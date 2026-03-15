{ config, pkgs, username, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader (Limine)
  boot.loader.systemd-boot.enable = false;
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-megalo";
  networking.networkmanager.enable = true;

  # Timezone and Locale
  time.timeZone = "UTC"; # Replace with your timezone
  i18n.defaultLocale = "en_US.UTF-8";

  # Desktop Environments / Compositors
  services.xserver.enable = true;

  # Set global environment variables for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint for Electron/Chromium apps to use Wayland
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1"; # Wayland for Firefox
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  programs.fish.enable = true;

  programs.niri.enable = true;
  programs.kdeconnect.enable = true;
  programs.dms-shell = {
    enable = true;
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
    systemd.enable = true;
    systemd.restartIfChanged = true;

    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
    enableClipboardPaste = true;       # Pasting from the clipboard history (wtype)
  };

  systemd.user.services.dms.serviceConfig.Environment = [ "QT_QPA_PLATFORMTHEME=qt6ct" ];

  # Configure User
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.fish;
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    pciutils
    usbutils
    wirelesstools

    # KDE Utilities
    kdePackages.discover # Optional: Software center for Flatpaks/firmware updates
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Character map
    kdePackages.kclock # Clock app
    kdePackages.kcolorchooser # Color picker
    kdePackages.kolourpaint # Simple paint program
    kdePackages.ksystemlog # System log viewer
    kdePackages.sddm-kcm # SDDM configuration module
    kdiff3 # File/directory comparison tool

    # Polkit
    polkit_gnome

    # Hardware/System Utilities (Optional)
    kdePackages.isoimagewriter # Write hybrid ISOs to USB
    kdePackages.partitionmanager # Disk and partition management
    hardinfo2 # System benchmarks and hardware info
    wayland-utils # Wayland diagnostic tools
    wl-clipboard # Wayland copy/paste support
  ];

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Nvidia Drivers (RTX 3080)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    # Use the open kernel module for modern cards (30xx series)
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # XDG Portals
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gnome" "gtk" ];
      niri.default = [ "gnome" "gtk" ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  system.stateVersion = "25.11";
}
