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
    libsForQt5.qt5ct
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    adw-gtk3
    nwg-look
    gnome-themes-extra
    kdePackages.kdeconnect-kde

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
  };

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
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
