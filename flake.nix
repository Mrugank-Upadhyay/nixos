{
  description = "A very basic flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # snowfall-lib = {
    #   url = "github:snowfallorg/lib?ref=dev";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # snowfall-flake = {
    #   url = "github:snowfallorg/flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # snowfall-thaw = {
    #   url = "github:snowfallorg/thaw";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nix-gaming.url = "github:fufexan/nix-gaming";

    # Themes
    stylix.url = "github:danth/stylix";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Raycast Alternative
    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions.url = "github:vicinaehq/extensions";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pinned to nixos-24.11 (not following our nixpkgs): upstream's package build
    # still references `nodePackages.asar`, which was removed from current nixpkgs.
    # This only affects build tooling (electron/asar/etc), not the app itself or
    # available models. See https://github.com/k3d3/claude-desktop-linux-flake/issues/91
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, vicinae, ...} : {

    nixosConfigurations.mrugankDesktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./desktop-config/configuration.nix
        # (import ./overlays)
        {
          nixpkgs.overlays = [
            inputs.nix-vscode-extensions.overlays.default
            (final: prev: {
              themes = prev.callPackage ./sddm-themes/sddm-themes.nix {};
            })
          ];
        }
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [ vicinae.homeManagerModules.default ];
          home-manager.users.mrugank = import ./home.nix;
        }
	vicinae.nixosModules.default
      ];
    };
     
    systems.modules.nixos = with inputs; [
      home-manager.nixosModules.home-manager
    ];
    nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./homelab-config/configuration-homelab.nix
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "hm-homelab-backup";
	  home-manager.users.homelab = import ./homelab-config/home-homelab.nix;
        }
      ];
    };
  };
}
