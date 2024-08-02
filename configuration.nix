# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  stylix = pkgs.fetchFromGithub {
    owner = "danth";
      repo = "stylix";
      rev = "...";
      sha256 = "...";
  };
  themes = pkgs.callPackage /home/mrugank/sddm-themes/sddm-themes.nix {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
      # (import stylix).homeManagerModules.stylix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.timeout = 30;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = ["i2c-dev" "ddcci_backlight"];
  services.udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  networking.hostName = "mrugankDesktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager = {
    sddm = {
      wayland.enable = true;
      enable = true;
      # extraPackages = with pkgs; [
      #   (callPackage "/home/mrugank/sddm-themes/sddm-themes.nix" {}).sddm-astronaut-theme
      # ];
      theme = "sddm-astronaut-theme";
      # sddm.package = pkgs.kdePackages.sddm;
    };
  };
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;


  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
     alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;


    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mrugank = {
    isNormalUser = true;
    description = "Mrugank";
    extraGroups = [ 
      "networkmanager"
      "wheel"
      "i2c"
      "scanner"
      "lp"
      "openrazer"
      "plugdev"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      /home/mrugank/.ssh/id_ed25519
    ];
  };
  
  programs.zsh.enable = true;

  # Install firefox.
  programs.firefox.enable = true;
  
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "hm-backup";
  home-manager.users.mrugank = { pkgs, ...}: {  
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
  };


  programs.direnv = {
    enable = true;
    silent = true;
  };

  fonts.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Hasklig"
          "Iosevka"
          "VictorMono"
        ];
      })
    ];

  # stylix = {
  #   enable = true;
  #   image = "/home/mrugank/Pictures/The-Neon-Shallows.jpg";
  #   autoEnable = false;
  #   polarity = "dark";
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  #   
  #   opacity.terminal = 0.8;
  #   
  #   # targets = {
  #   #   vesktop.enable = true;
  #   # };
  #
  #   fonts = {
  #     sizes = {
  #       applications = 12;
  #       desktop = 10;
  #       popups = 10;
  #       terminal = 12;
  #     };
  #     sansSerif = {
  #       package = pkgs.inter;
  #       name = "Inter";
  #     };
  #     serif = {
  #       package = pkgs.roboto-slab;
  #       name = "Roboto Slab";
  #     };
  #     monospace = {
  #       package = pkgs.nerdfonts.override {
  #         fonts = [
  #           "CascadiaCode"
  #         ];
  #       };
  #       name = "CaskaydiaCove Nerd Font";
  #     };
  #   };
  # };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Steam config
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    localNetworkGameTransfers.openFirewall = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    kitty
    btop
    git
    bat
    eza
    trash-cli
    zoxide
    starship
    rmtrash
    libgcc
    neofetch
    wineWowPackages.stable
    wineWowPackages.waylandFull
    winetricks
    lutris
    protontricks
    fzf
    python311Packages.pip
    lact
    openssh
    themes.sddm-astronaut-theme
    ddcutil
  ];

  # SSH Agent
  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # Lact Daemon 
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
