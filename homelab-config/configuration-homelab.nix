# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration-homelab.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout = 30;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "homelab"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
  # services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable Bluetooth
  # hardware.bluetooth.enable = true;


  # hardware.amdgpu.amdvlk = {
  #   enable = true;
  #   support32Bit.enable = true;
  # };

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #  enable = true;
  #   alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  # If you want to use JACK applications, uncomment this
  #  #jack.enable = true;


  #  # use the example session manager (no others are packaged yet so this is enabled by default,
  #  # no need to redefine it in your config for now)
  #  #media-session.enable = true;
  #};

 
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.homelab = {
    isNormalUser = true;
    description = "Homelab";
    extraGroups = [ 
      "networkmanager" 
      "wheel"
      "docker"
    ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };
  
  # Autologin
  services.getty.autologinUser = "homelab";

  programs.zsh.enable = true;
  
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.nix-ld.enable = true;
  
  programs.direnv = {
    enable = true;
    silent = true;
  };

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    hasklug
    iosevka
    victor-mono
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    btop
    htop
    git
    bat
    eza
    trash-cli
    zoxide
    rmtrash
    libgcc
    fzf
    openssh
    xclip
    kitty
    cockpit # Web-based graphical interface for servers
    kexec-tools
    pnpm
    nodejs_22
    packagekit
    autossh
    postgresql_16
    redis
    jq
  ];

  # SSH Agent
  # programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      TCPKeepAlive = "yes";
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };

  # AutoSSH
  services.autossh.sessions = [
    {
      extraArguments = "-N -R 10080:localhost:8080 ubuntu@homelab.mrugank.dev";
      name = "vps";
      user = "homelab";
    }
  ];
 
  # Cockpit Config
  services.cockpit = {
    enable = true;
    port = 9090;
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };
  
  services.packagekit.enable = true;


  # ── Tailscale ─────────────────────────────────────────
  services.tailscale.enable = true;
  

  # ── PostgreSQL + pgvector ─────────────────────────────
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    extensions = ps: [ ps.pgvector ];

    settings = {
      listen_addresses = pkgs.lib.mkForce "*";
      shared_buffers = "4GB";
      effective_cache_size = "10GB";
      work_mem = "32MB";
      max_connections = 50;
    };

    authentication = pkgs.lib.mkOverride 10 ''
      # Type  Database  User  Address         Method
      local   all       all                   trust
      host    all       all   127.0.0.1/32    trust
      host    all       all   100.64.0.0/10   md5
    '';

    ensureDatabases = [ "kairos" ];
    ensureUsers = [
      {
        name = "kairos";              # Postgres role name
        ensureDBOwnership = true;     # owns the kairos database
      }
      {
        name = "homelab";             # let system user connect via psql without sudo
        ensureClauses = {
          superuser = true;
        };
      }
    ];
  };


  # ── Redis ─────────────────────────────────────────────
  services.redis.servers."" = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";
    settings = {
      maxmemory = "128mb";
      maxmemory-policy = "noeviction"; # Set to no-eviction so we don't get jobs silently dropped before they're processed
    };
  };

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
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ 
    	22    # SSH (local + autossh)
	3000  # Frontend
	5432  # PostgreSQL (tailscale only, enforced via ACLs)
	6379  # Redis (tailscale only, enforced via ACLs)
	8000  # API server
	9090  # Cockpit
    ];
  };



  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
