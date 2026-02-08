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
    # GTK Theme
    rose-pine-gtk-theme
    rose-pine-icon-theme

    # XCursor
    rose-pine-cursor

    # Desktop setup stuff
    nemo-with-extensions

    # Fonts
    fira-code
    nerd-fonts.fira-code

    # Personal/productivity
    chromium
    vesktop
    obsidian
    libreoffice-qt

    # Coding
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.pip
      python-pkgs.requests
    ]))
    rustup
    lua 
    nodejs
    nodePackages.pnpm
    gcc 
    go
    nim
    crystal

    # Bluetooth
    blueberry

    # Gaming
    steam 
    steam-run 
    lutris
    pokemmo-installer

    # Utilities
    viewnior
    flatpak
    kdePackages.ark
    p7zip
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
    NIXOS_OZONE_WL = "1";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";

    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };

  # Non-config files to include
  home.file = {
    "themes/chromium".source = ../../home/keith/themes/chromium;
  };

  # Set xcursor
  home.pointerCursor = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

  # Enable xdg and declare config files
  xdg.enable = true;

  xdg.configFile."kitty".source = ../../home/keith/config/kitty;
  xdg.configFile."hypr".source = ../../home/keith/config/hypr;
  xdg.configFile."waybar".source = ../../home/keith/config/waybar;
  xdg.configFile."mako".source = ../../home/keith/config/mako;
  xdg.configFile."wofi".source = ../../home/keith/config/wofi;
  xdg.configFile."wlogout".source = ../../home/keith/config/wlogout;
  xdg.configFile."wallpapers".source = ../../home/keith/config/wallpapers;

  xdg.desktopEntries."steam" = {
    name = "Steam";
    genericName = "Game Launcher";
    exec = "env STEAM_FORCE_DESKTOPSCALING=1.0 steam %U";
    icon = "steam";
    terminal = false;
    categories = [ "Network" "FileTransfer" "Game" ];
  };

  # GTK Theme
  gtk = {
    enable = true;

    font = {
      name = "Fira Code";
      size = 16;
    };

    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };

    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };

  # Yazi setup
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "mtime";
        sort_dir_first = true;
      };
    };
  };
  # VSCode setup
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  programs.vscode.profiles.default = {
    userSettings = {
      "window.zoomLevel" = 0.6;
      "editor.fontFamily" = "FiraCode Nerd Font";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;

      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.smoothScrolling" = true;

      "workbench.colorTheme" = "Rosé Pine";
      "workbench.iconTheme" = "rose-pine-icons";

      "css.validate" = false;

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

  # Setup git
  programs.git = {
    enable = true;
    settings = {
      user.name = "Keith Austin";
      user.email = "keith@keithaustin.dev";
    };
  };
  
  # Setup bash
  programs.bash = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      #format = ''$username$directory$git_branch$git_status$fill$c$julia$nodejs$nim$rust$scala$conda$python$time
      #  [󱞪](fg:iris)'';
      format = ''$username$directory$time$git_branch$git_status
      [󱞪](fg:iris)'';

      palette = "rose-pine";

      palettes.rose-pine = {
        overlay = "#26233a";
        love = "#eb6f92";
        gold = "#f6c177";
        rose = "#ebbcba";
        pine = "#31748f";
        foam = "#9ccfd8";
        iris = "#c4a7e7";
        text = "#e0def4";
        dark = "#191724";
      };

      username = {
        format = "[](fg:pine)[  $user ]($style)";
        show_always = true;
        style_root = "bg:pine fg:text";
        style_user = "bg:pine fg:text";
      };
      
      directory = {
        format = "[](bg:pine fg:foam)[ $path ]($style)";
        style = "bg:foam fg:dark";
        truncation_length = 3;
        truncation_symbol = ".../";
      };

      directory.substitutions = {
        Documents = "󰈙";
        Downloads = " ";
        Music = " ";
        SPictures = " ";
      };

      time = {
        disabled = false;
        format = "[](bg:foam fg:rose)[ $time 󰴈 ]($style)[](fg:rose) ";
        style = "bg:rose fg:dark";
        time_format = "%I:%M%P";
        use_12hr = true;
      };

      git_branch = {
        format = "[](fg:gold)[ $symbol $branch ]($style)";
        style = "bg:gold fg:dark";
        symbol = "";
      };

      git_status = {
        style = "bg:overlay fg:love";
        format = "[](bg:gold fg:overlay)([$all_status$ahead_behind]($style))[](fg:overlay) ";
        up_to_date = "[ ✓ ](bg:overlay fg:iris)";
        untracked = "[?\($count\)](bg:overlay fg:gold)";
        stashed = "[\$](bg:overlay fg:iris)";
        modified = "[!\($count\)](bg:overlay fg:gold)";
        renamed = "[»\($count\)](bg:overlay fg:iris)";
        deleted = "[✘\($count\)](style)";
        staged = "[++\($count\)](bg:overlay fg:gold)";
        ahead = "[⇡\(\${count}\)](bg:overlay fg:foam)";
        diverged = "⇕[\[](bg:overlay fg:iris)[⇡\(\${ahead_count}\)](bg:overlay fg:foam)[⇣\(\${behind_count}\)](bg:overlay fg:rose)[\]](bg:overlay fg:iris)";
        behind = "[⇣\(\${count}\)](bg:overlay fg:rose)";
      };

      fill = {
        style = "fg:iris";
        symbol = " ";
      };

      
    };
  };

  # Allow Home Manager to manage Hyprland
  wayland.windowManager.hyprland.enable = true;
}
