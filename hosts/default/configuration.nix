{ pkgs, lib, inputs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    # Boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.hostName = "keith-desktop-nix";
    networking.networkmanager.enable = true;

    # Timezone
    time.timeZone = "America/New_York";

    # Locale
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    # Services
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    services.xserver.videoDrivers = [ "amdgpu" ];

    # Required services for hyprland
    security.polkit.enable = true;
    services.dbus.enable = true;

    # OpenGL / EGL setup
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };

    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.autoUpgrade.enable = true;
    system.autoUpgrade.dates = "weekly";

    nix.gc.automatic = true;
    nix.gc.dates = "daily";
    nix.gc.options = "--delete-older-than 7d";
    nix.settings.auto-optimise-store = true;

    services.openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
    };

    users.users.keith = {
        isNormalUser = true;
        description = "Keith Austin";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;

    # Program setup

    # Hyprland
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # Env
    environment.systemPackages = with pkgs; [
        wayland
        wayland-utils
        mesa
        libdrm
        egl-wayland 
        kitty
    ];

    system.stateVersion = "25.11";
}