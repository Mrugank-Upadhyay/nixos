{ config, pkgs, inputs, ... }:

{
  home.username = "mrugank";
  home.homeDirectory = "/home/mrugank";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    github-desktop
    bruno # HTTP Client
    # beekeeper-studio # Database Data Management, currently marked insecure. Need alternative
    nautilus # File Manager
    gnome-calculator # Calculator
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
    dotDir = "${config.xdg.configHome}/zsh";
    shellAliases = {
      ls = "eza";
      cat = "bat";
      cd = "z";
      rm = "rmtrash";
      rmdir = "rmdirtrash";
      ll = "ls -lah";
      ddc-dp = "sudo ddcutil -d 2 setvcp 10";
      ddc-hd = "sudo ddcutil -d 1 setvcp 10";
      npm = "pnpm";
      npx = "pnpm dlx";
      ssh-homelab = "ssh homelab@192.168.1.145";
      ssh-vps = "ssh ubuntu@192.9.147.141";
    };
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
    initContent = pkgs.lib.mkMerge [
      (pkgs.lib.mkBefore ''
        autoload -U compinit && compinit
      '')
      (pkgs.lib.mkAfter ''
        # Fix CTRL+R history search (Oh My Zsh uses vi-mode default)
        bindkey -M viins '^R' history-incremental-search-backward
        bindkey -M vicmd '^R' history-incremental-search-backward
      '')
    ];
  };

  programs.bat.enable = true;
  # shell = pkgs.zsh;
  
  programs.eza = {
    enable = true;
    icons = "auto";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    withRuby = true;
    withPython3 = true;

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

    themeFile = "Catppuccin-Mocha";
  };


  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git-credential-oauth.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    
    settings = {
      user = {
        name = "Mrugank Upadhyay";
        email = "mrugank2@gmail.com";
      };
      color.ui = "auto";
      push = {
        autoSetupRemote = true;
      };
      pull.ff = "only";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      side-by-side = true;
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
          icon = "https://nixos.wiki/favicon.png";
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
        "bing".metaData.hidden = "true";
      };
      search.force = true;
      search.default = "google";
    };
  };

  # Install Apps
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
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
    #package = pkgs.vscode.fhs;
    profiles.default.extensions =
      (with pkgs.vscode-extensions; [
      	arrterian.nix-env-selector
	bradlc.vscode-tailwindcss
	christian-kohler.npm-intellisense
	eamodio.gitlens
	esbenp.prettier-vscode
	formulahendry.auto-close-tag
	formulahendry.auto-rename-tag
	mechatroner.rainbow-csv
	mkhl.direnv
	ms-python.debugpy
	ms-python.pylint
	ms-python.vscode-pylance
	ms-toolsai.jupyter
	ms-toolsai.jupyter-keymap
	ms-toolsai.jupyter-renderers
	ms-toolsai.vscode-jupyter-cell-tags
	ms-toolsai.vscode-jupyter-slideshow
	ms-vscode-remote.remote-ssh
	ms-vscode-remote.remote-ssh-edit
	ms-vscode.cmake-tools
	ms-vscode.cpptools
	ms-vscode.cpptools-extension-pack
	ms-vscode.remote-explorer
	vincaslt.highlight-matching-tag
      ])
      ++ (with pkgs.vscode-marketplace; [
        austenc.tailwind-docs
        ms-python.vscode-python-envs
    	ms-vscode.cpp-devtools
    	stivo.tailwind-fold
    	wayou.vscode-todo-highlight
    	yatki.vscode-surround
      ])
      ++ [ pkgs.vscode-marketplace."076923".python-image-preview ];
    profiles.default.userSettings = {
      "update.mode" = "none";
      "extensions.autoUpdate" = false;
      "extensions.autoCheckUpdates" = false;
      "telemetry.telemetryLevel" = "off";
      "notebook.lineNumbers" = "on";
      "notebook.cellToolbarLocation" = {
        "default" = "right";
	"jupyter-notebook" = "right";
      };
      "notebook.output.scrolling" = true;
      "workbench.settings.applyToAllProfiles" = [ "notebook.output.scrolling" ];
      "jupyter.widgetScriptSources" = [ "jsdelivr.com" "unpkg.com" ];
      "tailwind-fold.autoFold" = false;
      "editor.tabSize" = 2;
      "security.workspace.trust.enabled" = false;
      "surround.custom" = {
        "Suspense" = {
	  "label" = "Suspense";
	  "description" = "<Suspense> { Children } </Suspense>";
	  "snippet" = "<Suspense>\n\t$TM_SELECTED_TEXT\n</Suspense>$0";
	  "languageIds" = [ "javascriptreact" "typescriptreact" ];
	};
	"Element New Line" = {
	  "label" = "<element>\n</element>";
	  "description" = "<element>\n</element>";
	  "disabled" = false;
	  "snippet" = "<\${1}$2>\n\t$TM_SELECTED_TEXT\n</$1>$0";
	  "languageIds" = [ "html" "typescriptreact" "javascriptreact" "jsx" "markdown" ];
	};
      };
    };
  };


  programs.zathura = {
    enable = true;
  };

  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;
      font = {
        normal = {
          size = 12;
          family = "Maple Nerd Font";
        };
      };
      theme = {
        light = {
          name = "vicinae-light";
          icon_theme = "default";
        };
        dark = {
          name = "tokyo-night-storm";
          icon_theme = "default";
        };
      };
      launcher_window = {
        opacity = 0.95;
        material = "none";
      };
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
       wifi-commander
       nix
       power-profile
      # Extension names can be found in the link below, it's just the folder names
    ];
  };

  services.kdeconnect.package = pkgs.kdePackages.kdeconnect-kde;
  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  
  home.stateVersion = "24.05";
}

