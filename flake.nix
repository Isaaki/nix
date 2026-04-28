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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      mkHost =
        hostName: username:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs hostName username; };
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
