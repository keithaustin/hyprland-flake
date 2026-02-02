{ config, pkgs, pkgs-unstable, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    chromium
    fira-code
    nerd-fonts.fira-code
    vesktop

    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.pip
      python-pkgs.requests
    ]))
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tempn/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    NIXOS_OZONE_WL = "1";
  };

  # Enable xdg and declare config files
  xdg.enable = true;

  xdg.configFile."kitty".source = ../../home/keith/config/kitty;
  xdg.configFile."hypr".source = ../../home/keith/config/hypr;
  xdg.configFile."waybar".source = ../../home/keith/config/waybar;
  xdg.configFile."mako".source = ../../home/keith/config/mako;
  xdg.configFile."wallpapers".source = ../../home/keith/config/wallpapers;

  # VSCode setup
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  programs.vscode.profiles.default = {
    userSettings = {
      "editor.fontFamily" = "FiraCode Nerd Font";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;

      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.smoothScrolling" = true;

      "window.titleBarStyle" = "custom";
    };

    extensions = with pkgs.vscode-extensions; [
      # Theme
      mvllow.rose-pine

      # Nix
      bbenoist.nix
      
      # Python dev
      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy

      # Godot dev
      geequlim.godot-tools

    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable other programs
  programs.git.enable = true;
  programs.bash.enable = true;

  # Allow Home Manager to manage Hyprland
  wayland.windowManager.hyprland.enable = true;
}
