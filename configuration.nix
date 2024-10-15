# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  # home-manager = builtins.fetchTarball {
  #   url = "https://github.com/nix-community/home-manager/archive/master.tar.gz"
  #   sha256 = 
  # };
  stylix = pkgs.fetchFromGithub {
    owner = "danth";
      repo = "stylix";
      rev = "...";
      sha256 = "...";
  };
  themes = pkgs.callPackage ./sddm-themes.nix {}; 
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # (import "${home-manager}/nixos")
      # (import stylix).homeManagerModules.stylix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.timeout = 30;
  boot.loader.efi.canTouchEfiVariables = true;

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
      theme = "sddm-astronaut-theme";
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


  # hardware.amdgpu.amdvlk = {
  #   enable = true;
  #   support32Bit.enable = true;
  # };

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
      # "i2c"
      "scanner"
      "lp"
      # "plugdev"
    ];
    packages = with pkgs; [
      kdePackages.kate
      nodejs_22
    ];
    shell = pkgs.zsh;
  };
  
  programs.zsh.enable = true;

  # Install firefox.
  programs.firefox.enable = true;
  
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.nix-ld.enable = true;
  
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
    vscode-fhs
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
    xclip
    themes.sddm-astronaut-theme
    pnpm
    # ddcutil
  ];

  # SSH Agent
  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
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
