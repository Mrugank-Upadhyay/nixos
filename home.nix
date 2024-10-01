{ config, pkgs, ... }:

{
  home.username = "mrugank";
  home.homeDirectory = "/home/mrugank";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    github-desktop
    bruno # HTTP Client
    beekeeper-studio # Database Data Management
    gnome.nautilus # File Manager
    gnome.gnome-calculator # Calculator
    mpv # Video/Music Player
    vesktop # Better Discord
    zoom-us
    vial # Keyboard Management
    # dopamine # Music Audio Player (only in unstable branch, not in 24.05)
    yt-dlp # CLI Audio/Video Downloader
    obsidian
  ];


  # programs.zsh.enable = true;

  # Install ZSH and Integrations
  programs.command-not-found.enable = true;
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    shellAliases = {
      ls = "eza";
      cat = "bat";
      cd = "z";
      rm = "rmtrash";
      rmdir = "rmdirtrash";
      ll = "ls -lah";
      ddc-dp = "sudo ddcutil -d 2 setvcp 10";
      ddc-hd = "sudo ddcutil -d 1 setvcp 10";
    };
    initExtraFirst = 
      ''
        autoload -U compinit && compinit
      '';
    enableCompletion = false;
    antidote = {
      enable = true;
      plugins = [
        "ohmyzsh/ohmyzsh path:lib/completion.zsh"
        "ohmyzsh/ohmyzsh path:plugins/gitfast"
        "ohmyzsh/ohmyzsh path:plugins/wd"
        "ohmyzsh/ohmyzsh path:plugins/command-not-found"
        "ohmyzsh/ohmyzsh path:plugins/compleat"
        "ohmyzsh/ohmyzsh path:plugins/pip"
        "ohmyzsh/ohmyzsh path:plugins/npm"
        "ohmyzsh/ohmyzsh path:plugins/history"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "ael-code/zsh-colored-man-pages"
        "chisui/zsh-nix-shell path:nix-shell.plugin.zsh"
      ];
    };
  };

  programs.bat.enable = true;
  # shell = pkgs.zsh;
  
  programs.eza = {
    enable = true;
    icons = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    # Packages to make available to Neovim
    extraPackages = with pkgs; [
      nil
      nixd
      nodejs
      lua-language-server
      luajitPackages.luarocks
      ltex-ls
      stylua
      ripgrep
      lazygit
      gcc
    ];

    plugins = [pkgs.vimPlugins.nvim-treesitter.withAllGrammars];
  };

  programs.starship = {
    enable = true;
    settings =
      (with builtins; fromTOML (readFile ./starship-nf-symbols.toml))
      // {
        add_newline = true;
      };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.kitty = {
    enable = true;
    settings = {
      # Temporary Font Declaration
      font_family = "CaskaydiaCove Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      background_opacity = "0.8";
      font_size = "12.0";
      # Bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.1";
      window_alert_on_bell = "yes";

      # Window
      remember_window_size = "yes";
      initial_window_width = 640;
      initial_window_height = 400;
      window_padding_width = "0.5";
      confirm_os_window_close = 0;

      # Cursor
      cursor_shape = "beam";

      # Tab Bar
      # tab_bar_mini_tabs = 1;
      #
      # tab_bar_edge = "bottom";
      # tab_bar_style = "powerline";
      # tab_powerline_style = "slanted";
      # tab_title_template = "{template}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # Remote control
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";
    };

    keybindings = {
      "ctrl+plus" = "change_font_size all +1.0";
      "ctrl+minus" = "change_font_size all -1.0";
      "ctrl+equal" = "change_font_size all 12.0";
      "super+shift+enter" = "launch --type=os-window --cwd=current";
    };

    shellIntegration = {
      enableZshIntegration = true;
    };

    theme = "Catppuccin-Mocha";
  };


  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git-credential-oauth.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    
    userName = "Mrugank Upadhyay";
    userEmail = "mrugank2@gmail.com";

    extraConfig = {
      color.ui = "auto";
      push = {
        autoSetupRemote = true;
      };
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles.mrugank = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
        "privacy.webrtc.hideGlobalIndicator" = true;
        "media.ffmpeg.vaapi.enabled" = true;
      };
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["np"];
        };
        "NixOS Wiki" = {
          urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = ["nw"];
        };
        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["nop"];
        };
        "Home Manager Options" = {
          urls = [
            {
              template = "https://home-manager-options.extranix.com/";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
                {
                  name = "release";
                  value = "master"; # unstable
                }
              ];
            }
          ];
          icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["hmop"];
        };
        "Bing".metaData.hidden = "true";
      };
      search.force = true;
      search.default = "Google";
    };
  };

  # Install Apps
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "monospace 12";
    extraConfig = {
      modi = "drun,filebrowser";
      show-icons = true;
      icon-theme = "Papirus";
      drun-display-format = "{name}";
      disable-history = false;
      sort = true;
      sorting-method = "fzf";
      case-sensitive = false;
      sidebar-mode = false;
      matching = "fuzzy";
      m = "-1";
      display-drun = "  ";
      # display-window = "  ";
      display-filebrowser = "  ";
      kb-cancel = "Escape,Control+g,Control+bracketleft,Super+w";
    };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      equinusocio.vsc-material-theme-icons
      equinusocio.vsc-material-theme
      eamodio.gitlens
      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy
      # ms-python.pylint # Currently only available in unstable branch
      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
      ms-vscode.cmake-tools
      formulahendry.auto-close-tag
      formulahendry.auto-rename-tag
      christian-kohler.npm-intellisense
      esbenp.prettier-vscode
      vincaslt.highlight-matching-tag
    ];
  };

  
  home.stateVersion = "24.05";
}
