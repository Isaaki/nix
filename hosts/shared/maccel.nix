{
  inputs,
  pkgs,
  username,
  ...
}:

{
  imports = [
    inputs.maccel.nixosModules.default
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="module", KERNEL=="maccel", RUN+="${pkgs.bash}/bin/sh -c 'chgrp -R maccel /sys/module/maccel/parameters/ && chmod -R g+w /sys/module/maccel/parameters/'"
  '';

  users = {
    users.${username}.extraGroups = [ "maccel" ];
    groups.maccel = { };
  };

  hardware.maccel = {
    enable = true;
    enableCli = true;
  };
}
