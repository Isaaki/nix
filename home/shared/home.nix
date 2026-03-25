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
        pavucontrol

        # File Management Tools
        thunar-archive-plugin # Archive support
        thunar-media-tags-plugin # Media tags support
        file-roller # Engine for archive plugins

        # Thumbnailers
        tumbler # Core thumbnail daemon
        ffmpegthumbnailer # Video
        gdk-pixbuf # Images
        poppler # PDFs
        libgsf # Office Docs
        gnome-epub-thumbnailer # eBooks
        fontforge # Font previews

        # Wayland & Theming
        niri
        xwayland-satellite
        swaybg
        cliphist
        kdePackages.qt6ct
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
      GTK_USE_PORTAL = "1";
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  programs = {
    home-manager.enable = true;
    nh.enable = true;
    git.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  systemd.user.targets = {
    niri-session = {
      Unit = {
        Description = "niri compositor session";
        Documentation = [ "man:systemd.special(7)" ];
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };
    };
  };

  systemd.user.services = {
    gnome-keyring = {
      Unit = {
        Description = "Gnome Keyring Daemon";
        PartOf = [ "niri-session.target" ];
        After = [ "niri-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=secrets";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "niri-session.target" ];
    };
    polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "niri-session.target" ];
        After = [ "niri-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install.WantedBy = [ "niri-session.target" ];
    };
    kdeconnect.Install.WantedBy = lib.mkForce [ "niri-session.target" ];
    kdeconnect-indicator.Install.WantedBy = lib.mkForce [ "niri-session.target" ];
  };

  systemd.user.startServices = "sd-switch";
}
