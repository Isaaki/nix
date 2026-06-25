{ pkgs, lib, ... }:

{
  services = {
    displayManager.sddm = {
      enable = lib.mkDefault true;
      wayland.enable = lib.mkDefault true;
    };
    desktopManager.plasma6.enable = true;
  };
}
