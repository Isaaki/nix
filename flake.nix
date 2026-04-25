{
  description = "Portable NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    maccel.url = "github:Gnarus-G/maccel";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
  };

  nixConfig = {
    extra-substituters = [
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      ...
    }@inputs:
    let
      mkHost =
        hostName: username:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              hostName
              username
              ;
            cachyos-kernel-pkgs = nix-cachyos-kernel.legacyPackages.x86_64-linux;
          };
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            ./hosts/${hostName}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                extraSpecialArgs = { inherit username hostName; };
                users.${username} = import ./home/shared/home.nix;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        nixos-megalo = mkHost "megalo" "isaaki";
        nixos-hadro = mkHost "hadro" "isak";
        nixos-tarcho = mkHost "tarcho" "isak";
      };
    };
}
