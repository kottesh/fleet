{
  description = "fleet nix configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.noteq = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/noteq/configuration.nix
        ];
      };
    };
}
