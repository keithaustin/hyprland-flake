{ pkgs, lib, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.hostName = "keith-vbox-nix";
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

    # KDE-required services
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Personal services
    services.tailscale.enable = true;

    services.openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
    };

    # Auto upgrade
    system.autoUpgrade.enable = true;
    system.autoUpgrade.dates = "weekly";

    # Auto gc
    nix.gc.automatic = true;
    nix.gc.dates = "daily";
    nix.gc.options = "--delete-older-than 7d";
    nix.settings.auto-optimise-store = true;

    users.users.keith = {
        isNormalUser = true;
        description = "Keith Austin";
        extraGroups = [ 
            "networkmanager" 
            "wheel"
        ];
        packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;

    # Program setup

    # Env
    environment.systemPackages = with pkgs; [
        kdePackages.konsole
    ];

    system.stateVersion = "25.11";
}