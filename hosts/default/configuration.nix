{ pkgs, lib, inputs, ... }:
let
    sni = pkgs.stdenv.mkDerivation {
            pname = "sni";
            version = "0.0.102a";

            src = pkgs.fetchurl {
                url = "https://github.com/alttpo/sni/releases/download/v0.0.102a/sni-v0.0.102a-linux-amd64.tar.xz";
                sha256 = "sha256-wud/7Aoo4s+oICrZb9oHwSbyS9+0p9nEIIFk/y2Ptds=";
            };

            installPhase = ''
                mkdir -p $out/bin
                cp sni $out/bin
                chmod +x $out/bin/sni
            '';
        };
in
{
    imports = [
        ./hardware-configuration.nix
    ];

    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd = {
        supportedFilesystems = [ "nfs" ];
        kernelModules = [ "nfs" ];
    };

    # Auto-mount NFS shares
    fileSystems."/mnt/keith" = {
        device = "truenas.local:/mnt/storage-pool";
        fsType = "nfs";
    };

    # Networking
    networking.hostName = "keith-desktop-nix";
    networking.networkmanager.enable = true;
    networking.extraHosts = "192.168.10.112 truenas.local";
    networking.firewall.checkReversePath = "loose";
    
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

    # Hardware
    hardware.bluetooth.enable = true;

    # Services
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # Autologin on boot, stay in tty on exit hyprland
    services.getty.autologinUser = "keith";
    environment.loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
            hyprland
        fi
    '';

    # Required services for hyprland
    security.polkit.enable = true;
    services.dbus.enable = true;
    services.seatd.enable = true;

    # Personal services
    services.tailscale.enable = true;
    services.flatpak.enable = true;

    # QMK/Vial setup
    services.udev = {
        packages = with pkgs; [
            qmk 
            qmk-udev-rules 
            qmk_hid 
            via 
            vial
        ];
    };

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

    # Virtualization
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.swtpm.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    programs.virt-manager.enable = true;

    networking.firewall.trustedInterfaces = [ "virbr0" ];

    systemd.services.libvirt-default-network = {
        description = "Start libvirt default network";
        after = ["libvirtd.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
            ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
            User = "root";
        };
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
            "libvirtd"
            "kvm"
        ];
        packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;

    # Program setup

    # nix-ld for SNI/maybe other stuff later
    programs.nix-ld = {
        enable = true;

        libraries = with pkgs; [
            stdenv.cc.cc
            zlib 
            openssl
            curl
        ];
    };

    # Hyprland
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    # Dconf
    programs.dconf.enable = true;


    # Env
    environment.systemPackages = with pkgs; [
        wineWowPackages.stable
        winetricks
        nfs-utils
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
        sni
    ];

    # Fix fonts for Steam
    fonts.fontDir.enable = true;

    system.stateVersion = "25.11";
}
