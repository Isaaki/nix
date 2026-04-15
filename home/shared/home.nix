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
        lmstudio

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
        gnome-themes-extra
        adw-gtk3
        adwaita-qt
        adwaita-qt6
        gsettings-desktop-schemas
        matugen
        nwg-look
        gnome-themes-extra

        # Development
        godot_4
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
        lazydocker
        nodejs
        python3
        gemini-cli
        zed-editor
        vscode
        uv

        # Terminal Utils
        kitty
        alacritty
        ghostty
        fastfetch
        ripgrep
        fd
        fzf
        eza
        radeontop # Use this to see AMD iGPU usage
        libva-utils # Provides 'vainfo' to check drivers
        nvtopPackages.full # Best tool to see both GPUs at once
        zoxide
        tealdeer
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
        awww
        grim
        slurp
        satty
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
            protontricks
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
      BROWSER = "firefox";

      LIBVA_DRIVER_NAME = "radeonsi"; # For Intel("iHD"), AMD("radeonsi")
      MOZ_USE_XINPUT2 = "1";
    };
  };

  services = {
    mpris-proxy.enable = true;
    syncthing.enable = true;
    kdeconnect = {
      enable = true;
      indicator = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };

  xdg = {
    configFile."mimeapps.list".force = true;
    userDirs = {
      enable = true;
      setSessionVariables = true;
      download = "$HOME/downloads";
      documents = "$HOME/documents";
      videos = "$HOME/videos";
      pictures = "$HOME/pictures";
      music = "$HOME/music";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "text/xml" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/xml" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];

        "inode/directory" = [ "thunar.desktop" ];
        "application/x-directory" = [ "thunar.desktop" ];

        "image/jpeg" = [ "qimgv.desktop" ];
        "image/png" = [ "qimgv.desktop" ];
        "image/gif" = [ "qimgv.desktop" ];
        "image/webp" = [ "qimgv.desktop" ];
        "image/bmp" = [ "qimgv.desktop" ];
        "image/tiff" = [ "qimgv.desktop" ];
        "image/x-tga" = [ "qimgv.desktop" ];
        "image/vnd.microsoft.icon" = [ "qimgv.desktop" ];
        "image/svg+xml" = [ "qimgv.desktop" ];
      };
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
      withPython3 = true;
      withRuby = true;
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "ayu";
        vim_keys = true;
        update_ms = 200;
      };
    };
    ghostty = {
      enable = true;
      settings = {
        font-family = "ComicCode Nerd Font";

        # window-theme = "system";
        gtk-tabs-location = "bottom";

        gtk-custom-css = "${./ghostty-gtk-style.css}";

        keybind = [
          "ctrl+shift+t=new_tab"
          "ctrl+shift+q=close_tab"
          "ctrl+shift+1=goto_tab:1"
          "ctrl+shift+2=goto_tab:2"
          "ctrl+shift+3=goto_tab:3"
          "ctrl+shift+4=goto_tab:4"
          "ctrl+shift+5=goto_tab:5"
          "ctrl+shift+6=goto_tab:6"
          "ctrl+shift+7=goto_tab:7"
          "ctrl+shift+8=goto_tab:8"
          "ctrl+shift+9=goto_tab:9"
        ];

        cursor-style = "block";
        cursor-style-blink = true;
        shell-integration-features = "no-cursor";
      };
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
        ExecStart = pkgs.writeShellScript "start-gnome-keyring" ''
          eval $(${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets,ssh)
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd SSH_AUTH_SOCK GNOME_KEYRING_CONTROL GNOME_KEYRING_SCREEN_READER_SOFTWARE_VERSION
        '';
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
