{ ... }:

{
  services.xserver.xkb = {
    extraLayouts.alt-nord = {
      description = "Alt Nordics (us base)";
      languages = [ "eng" "nor" ];
      symbolsFile = ./xkb/symbols/alt-nord;
    };
  };
}
