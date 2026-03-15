{ config, pkgs, username, hostName, ... }:

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
    # stremio
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

    # --- Niri & Wayland ---
    niri
    xwayland-satellite
    swaybg
    cliphist

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
}
