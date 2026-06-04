{ config, lib, ... }:

{
  xdg.mimeApps = {
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

  xdg.configFile."mimeapps.list".force = true;

  home.activation.makeMimeAppsMutable = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mimeapps_path="${config.xdg.configHome}/mimeapps.list"
    
    if [ -L "$mimeapps_path" ]; then
      # Find what the symlink points to in the Nix store
      real_path="$(readlink -f "$mimeapps_path")"
      
      # Delete the symlink
      $DRY_RUN_CMD rm "$mimeapps_path"
      
      # Copy the file from the Nix store to the config directory
      $DRY_RUN_CMD cp "$real_path" "$mimeapps_path"
      
      # Make it writable so Thunar doesn't crash
      $DRY_RUN_CMD chmod +w "$mimeapps_path"
    fi
  '';
}
