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

    maccel = {
      url = "github:Gnarus-G/maccel";
    };
  };

  outputs = { self, nixpkgs, home-manager, maccel, ... }@inputs:
  let
    
    mkHost = hostName: username: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs hostName username; };
      modules = [
      {
	nixpkgs.config.allowUnfree = true;
      }
      ./hosts/${hostName}/configuration.nix
        home-manager.nixosModules.home-manager
        maccel.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
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
