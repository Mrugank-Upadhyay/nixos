{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;

    autocd = true;
    dotDir = ".config/zsh";
    shellAliases = {
      rm = "rmtrash";
      rmdir = "rmdirtrash";
      sudo = "sudo ";
      ls = "eza";
      cat = "bat";
      npm = "pnpm";
      npx = "pnpm dlx";
      ddc-dp = "ddcutil --bus=7 setvcp 10";
      ddc-hd = "ddcutil --bus=5 setvcp 10";
    };

    # Load completion before loading plugins with antidote.
    initExtraFirst =
      /*
      bash
      */
      ''
        export NIXPKGS_ALLOW_UNFREE=1
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
}
