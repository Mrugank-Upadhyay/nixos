{
  config,
  pkgs,
  scripts,
  ...
}: {
  imports = [
    ./programs
    ./theming
  ];

  home = {
    username = "mrugank";
    homeDirectory = "/home/mrugank";
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  xdg.userDirs = {
    enable = true;
    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
  };

  programs = {
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    # apps
    gnome.nautilus
    cinnamon.warpinator
    pavucontrol
    obsidian
    mpv
    zoom-us
    grimblast
    github-desktop
    chromium
    slack
    protonup-qt
    bruno
    beekeeper-studio
    simple-scan
    xournalpp
    vial
    transmission_4-gtk
    gparted

    discord
    telegram-desktop
    teams-for-linux

    libreoffice
    hunspell
    hunspellDicts.en_US
    hunspellDicts.en_CA
    gammastep

    # archives
    zip
    xz
    unzip
    gnutar

    # utils
    ripgrep
    jq
    yq-go
    eza
    rmtrash
    pamixer
    killall
    imagemagick
    fd

    # dev tools
    rustup
    gcc
    nodePackages.pnpm

    # nix
    nix-index
    nix-prefetch-git
    nixpkgs-fmt

    # system tools
    bottom
    procs
    monitor
    sysstat
    lm_sensors # sensors
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ] ++ builtins.attrValues scripts;

  home.stateVersion = "23.05";
}
