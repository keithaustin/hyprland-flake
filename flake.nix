{
    description = "keithaustin hyprland setup for NixOS";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
        pkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        hyprland.url = "github:hyprwm/Hyprland";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, ... }@inputs:
    let
        lib = nixpkgs.lib;
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-unstable = inputs.pkgs-unstable.legacyPackages.${system};
    in
    {
        nixosConfigurations.default = lib.nixosSystem {
            specialArgs = { inherit inputs; inherit pkgs-unstable; };
            inherit system;
            modules = [
                ./hosts/default/configuration.nix
                inputs.home-manager.nixosModules.default
            ];
        };
    };
}