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
  };

  outputs = { self, nixpkgs, ... }: {

    nixosConfigurations.mrugankDesktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };

  };
}
