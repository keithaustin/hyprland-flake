{ pkgs, lib, inputs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
    ];

    programs.hyprland.enable = true;
    programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
}