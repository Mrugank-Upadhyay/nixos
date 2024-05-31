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
    androidStudioPackages.beta
    gnome.gnome-calculator
    evolution # Gnome Calendar

    discord
    notion-app-enhanced
    telegram-desktop
    teams-for-linux

    libreoffice
    hunspell
    hunspellDicts.en_US
    hunspellDicts.en_CA
    gammastep
    notes-up
    obs-studio
    easyeffects
    libsForQt5.kdenlive
    zathura
    masterpdfeditor
    pdfmixtool

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
    gammastep
    ddcutil
    
    # dev tools
    rustup
    gcc
    nodePackages.pnpm
    htop
    go
    python3Full
    python311Packages.pip

    # nix
    nix-index
    nix-prefetch-git
    nixpkgs-fmt

    # system tools
    gtk2
    adwaita-qt
    glaxnimate
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
