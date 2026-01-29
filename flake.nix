{
    description = "keithaustin hyprland setup for NixOS";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        pkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        hyprland.url = "github:hyprwm/Hyprland";
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };

        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
        system = "x86_64-linux";
    in
    {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
            inherit system;

            modules = [
                ./hosts/default/configuration.nix

                hyprland.nixosModules.default
                
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.keith = import ./hosts/default/home.nix;
                }
            ];
        };
        nixosConfigurations.vbox = nixpkgs.lib.nixosSystem {
            inherit system;

            modules = [
                ./hosts/vbox/configuration.nix

                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.keith = import ./hosts/vbox/home.nix;
                }
            ]
        };
    };
}