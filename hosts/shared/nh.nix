{ pkgs, username, ... }:

{
  environment.systemPackages = [ pkgs.nvd ];

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
    flake = "/home/${username}/nix";
  };
}
