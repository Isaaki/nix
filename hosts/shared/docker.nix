{ pkgs, username, ... }:

{
  virtualisation.docker = {
    enable = true;
    # Optional: rootless mode for better security
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };

  users.users.${username}.extraGroups = [ "docker" ];
}
