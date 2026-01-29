{ pkgs, lib, inputs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
    ];

    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users.keith = {      
            imports = [ ./home.nix ];
        };
    };

    programs.hyprland.enable = true;
    programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
}