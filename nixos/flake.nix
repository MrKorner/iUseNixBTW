{
  description = "KornOS";

  inputs = {
    # Change `nixos-unstable` to any Nixpkgs branch you want.
    # It will be automatically updated by `nix flake update`
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."kornOS" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
