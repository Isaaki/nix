{
  description = "Portable NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    mkHost = hostName: username: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs hostName username; };
      modules = [
        ./hosts/${hostName}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit username hostName; };
          home-manager.users.${username} = import ./home/shared/home.nix;
        }
      ];
    };
  in {
    nixosConfigurations = {
      megalo = mkHost "megalo" "isaaki";
      hadro  = mkHost "hadro" "isak";
    };
  };
}
