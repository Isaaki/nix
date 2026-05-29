{ pkgs, ... }:

{
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.resolvconf.enable = false;
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSSEC = "true";
        Domains = [ "~." ];
        FallbackDNS = [
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
          "8.4.4.8"
        ];
        DNSOverTLS = "true";
      };
    };
  };
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
}
