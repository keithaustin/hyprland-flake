{ pkgs, lib, inputs, ... }:

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

    # Required services for hyprland
    security.polkit.enable = true;
    services.dbus.enable = true;
    services.seatd.enable = true;

    # Personal services
    services.tailscale.enable = true;

    # OpenGL / EGL setup
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

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

    # Audio setup
    security.rtkit.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
    };

    users.users.keith = {
        isNormalUser = true;
        description = "Keith Austin";
        extraGroups = [ 
            "networkmanager" 
            "wheel"
            "video"
            "input"
            "seat"
            "render"
        ];
        packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;

    # Program setup

    # Hyprland
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    # Env
    environment.systemPackages = with pkgs; [
        wayland
        wayland-utils
        mesa
        libdrm
        egl-wayland
        libsForQt5.qt5.qtwayland
        kitty
        hyprpaper
        libnotify
        mako
        hypridle
        hyprlock
        hyprshot
        wlogout
        wl-clipboard
        wofi
        waybar
        pamixer
        pavucontrol
        inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    ];

    system.stateVersion = "25.11";
}