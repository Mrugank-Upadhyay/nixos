# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:
let
  # home-manager = builtins.fetchTarball {
  #   url = "https://github.com/nix-community/home-manager/archive/master.tar.gz"
  #   sha256 = 
  # };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # (import "${home-manager}/nixos")
      # (import stylix).homeManagerModules.stylix
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.systemd-boot.configurationLimit = 5;
  #boot.loader.timeout = 30;
  #boot.loader.efi.canTouchEfiVariables = true;

  # Grub due to new SSDs configuration
  boot.loader = {
    timeout = 30;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      configurationLimit = 5;
      theme = "${
        (pkgs.fetchFromGitHub {
          owner = "Flava-Clown";
          repo = "AstronautGrub";
          rev = "astronaut_grub_theme";
          hash = "sha256-OlM3/1XPbQFsSsaTIzl6OaczVPxbQxfS3V8blgSnoms=";
        })
      }/astronaut_orange";
    };
  };

  # Use latest kernel packages
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mrugankDesktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "mrugank" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Manga Reader
  services.suwayomi-server = {
    enable = true;
    settings = {
      server.port = 4567;
      server.enableSystemTray = true;
    };
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Drawing tablet
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;


  # hardware.amdgpu.amdvlk = {
  #   enable = true;
  #   support32Bit.enable = true;
  # };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  security.pam.services.sddm.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };
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

  # Define a user account. Don't forget to set a password with 'passwd'.
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
      "docker"
    ];
    packages = with pkgs; [
      kdePackages.kate
      nodejs_22
      pnpm
      proton-vpn
      opentabletdriver
      xournalpp
      code-cursor-fhs
      mangayomi
      claude-code
      zed-editor
      komikku
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
    nerd-fonts.fira-code
    nerd-fonts.hasklug
    nerd-fonts.iosevka
    nerd-fonts.victor-mono
  ];

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
    fastfetch
    fzf
    lact
    openssh
    xclip
    themes.sddm-astronaut-theme
    pnpm
    kdePackages.plasma-nm
    zathura
    suwayomi-server
    # ddcutil
    postgresql_16
    redis
  ];

  # SSH Agent
  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # ── Tailscale ─────────────────────────────────────────
  services.tailscale.enable = true;

  # ── Docker ────────────────────────────────────────────
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
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
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [
      22    # SSH
      11434 # Ollama
    ];
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };

  # Allow Virtualization
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
