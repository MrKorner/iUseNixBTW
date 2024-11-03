{
  description = "KornOS";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  
  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations."kornOS" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
}
  
