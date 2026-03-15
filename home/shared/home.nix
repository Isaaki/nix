{ config, pkgs, lib, username, hostName, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "25.11";

  # User Packages
  home.packages = with pkgs; [
    # --- GUI Apps ---
    firefox
    chromium
    discord
    slack
    stremio-linux-shell
    obsidian
    pear-desktop
    plexamp
    libreoffice-fresh
    obs-studio
    gpu-screen-recorder
    mpv
    vlc
    pinta
    qimgv

    # --- Wayland & Theming ---
    niri
    xwayland-satellite
    swaybg
    cliphist
    kdePackages.qt6ct
    kdePackages.qtmultimedia # Dependency for dms-shell
    kdePackages.breeze
    kdePackages.breeze-icons
    libsForQt5.qt5ct
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    adw-gtk3
    nwg-look
    gnome-themes-extra

    # --- Terminal ---
    kitty
    alacritty
    ghostty

    # --- Development Tools ---
    godot_4
    kicad
    distrobox
    wineWow64Packages.stable
    winetricks
    rustup
    zig
    gcc
    gnumake
    git
    gh
    lazygit
    nodejs
    python3
    gemini-cli

    # --- Modern CLI Utils ---
    btop
    htop
    fastfetch
    ripgrep
    fd
    fzf
    eza
    zoxide
    tree
    jq
    yq
    chezmoi
    age
    sops
    cava
    trash-cli
    fuzzel
    waybar
    dunst
    libnotify
    swww
    grim
    slurp
    wl-clipboard
    playerctl
    brightnessctl
    wireplumber
    yt-dlp
    psmisc

    # --- Editors ---
    zed-editor
    vscode
  ] ++ (if hostName == "hadro" then [ ] else with pkgs; [
    steam
    lutris
  ]);

  # Syncthing Service
  services.syncthing = {
    enable = true;
  };

  # Program-specific configurations (Home Manager modules)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
  };

  programs.home-manager.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  # Polkit Agent (Moved from configuration.nix and made more robust)
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Robust autostart for KDE Connect (ensures it starts even if graphical-session.target isn't reached)
  systemd.user.services.kdeconnect.Install.WantedBy = lib.mkForce [ "default.target" ];
  systemd.user.services.kdeconnect-indicator.Install.WantedBy = lib.mkForce [ "default.target" ];

  # Ensure graphical-session.target is started for services that depend on it
  # This is often needed in Wayland compositors like Niri
  systemd.user.startServices = "sd-switch";

  # GTK & Qt Theming
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };

  # qt = {
  #   enable = true;
  #   platformTheme.name = "qtct";
  # };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    QT_QPA_PLATFORMTHEME_QT6 = lib.mkForce "qt6ct";
    QT_QPA_PLATFORM = "wayland;xcb";
    XDG_CURRENT_DESKTOP = "niri";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
