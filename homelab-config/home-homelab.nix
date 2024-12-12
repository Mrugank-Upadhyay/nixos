{ config, pkgs, ... }:

{
  home.username = "homelab";
  home.homeDirectory = "/home/homelab";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
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
    icons = "auto";
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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
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
      pull.ff = "only";
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
  };

  home.stateVersion = "24.05";
}
