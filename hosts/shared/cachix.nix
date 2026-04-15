{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.cachix ];

  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-isaaki.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-isaaki.cachix.org-1:j3lVYbPz7I5jQ7U7FByea0ddZaEfZgKg+9EL0tXmPjk="
    ];

    # Allow the user to manage caches
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
