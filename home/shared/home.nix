{
  pkgs,
  lib,
  username,
  hostName,
  ...
}:

{
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    packages =
      with pkgs;
      [
        # GUI Apps
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

        # Wayland & Theming
        niri
        xwayland-satellite
        swaybg
        cliphist
        kdePackages.qt6ct
        kdePackages.qtmultimedia
        kdePackages.breeze
        kdePackages.breeze-icons
        kdePackages.ksshaskpass
        libsForQt5.qt5ct
        adw-gtk3
        matugen
        nwg-look
        gnome-themes-extra

        # Development
        godot_4
        kicad
        distrobox
        wineWow64Packages.stable
        winetricks
        rustup
        nil
        nixd
        zig
        gcc
        gnumake
        git
        gh
        lazygit
        nodejs
        python3
        gemini-cli
        zed-editor
        vscode

        # Terminal Utils
        kitty
        alacritty
        ghostty
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
        unrar
        kbd
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
      ]
      ++ (
        if hostName == "hadro" then
          [ ]
        else
          with pkgs;
          [
            steam
            lutris
            gamescope
            pince
          ]
      );

    sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      XDG_CURRENT_DESKTOP = "niri";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };

  services = {
    syncthing.enable = true;
    kdeconnect = {
      enable = true;
      indicator = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
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
      Install.WantedBy = [ "default.target" ];
    };
    dms = {
      environment = {
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
        XDG_MENU_PREFIX = "plasma-";
      };
    };
    kdeconnect.Install.WantedBy = lib.mkForce [ "default.target" ];
    kdeconnect-indicator.Install.WantedBy = lib.mkForce [ "default.target" ];
  };

  systemd.user.startServices = "sd-switch";
}
