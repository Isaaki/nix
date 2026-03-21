{ pkgs, ... }:

{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    libsecret # for secret-tool
    gnome-keyring
    seahorse # GUI for managing keyrings
  ];
}
