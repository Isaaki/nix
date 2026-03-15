{ config, pkgs, username, ... }:

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

  # Use the new Plasma Login Manager instead of SDDM
  services.displayManager.sddm.enable = false;
  services.displayManager.plasma-login-manager = {
    enable = true;
    wayland.enable = true; # Explicitly enable Wayland for the login manager
  };

  # Set global environment variables for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint for Electron/Chromium apps to use Wayland
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1"; # Wayland for Firefox
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  services.desktopManager.plasma6.enable = true;

  programs.niri.enable = true;
  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
    systemd.restartIfChanged = true;
  };

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
    kdePackages.plasma-login-manager-kcm # Configuration module for PLM
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
      "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
  };

  system.stateVersion = "25.11";
}
