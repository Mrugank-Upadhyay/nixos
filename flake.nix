{
  description = "Mrugank's NixOS flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-thaw = {
      url = "github:snowfallorg/thaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nix-gaming.url = "github:fufexan/nix-gaming";

    # Themes
    stylix.url = "github:danth/stylix";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;
    };
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [];
      };

      overlays = with inputs; [
        snowfall-flake.overlays.default
        snowfall-thaw.overlays.default
      ];

      homes.modules = with inputs; [
        catppuccin.homeManagerModules.catppuccin
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        catppuccin.nixosModules.catppuccin
      ];

      systems.hosts.mrugankDesktop.modules = with inputs; [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
        nix-gaming.nixosModules.pipewireLowLatency
      ];

      # systems.hosts.mrugankLaptop.modules = with inputs; [
      #   nixos-hardware.nixosModules.lenovo-thinkpad-t480
      # ];

      # deploy = lib.mkDeploy {
      #   inherit (inputs) self;
      # };
    };
}
