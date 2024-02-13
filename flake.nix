{
  description = "My NixOS flake";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nix-gaming.url = "github:fufexan/nix-gaming";

    # home-manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-colors.url = "github:misterio77/nix-colors";

    eww = {
      url = "github:hylophile/eww/dynamic-icons";
    };

    drvs = {
      url = "path:derivations";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    nixos-hardware,
    nix-gaming,
    home-manager,
    hyprland,
    nix-colors,
    eww,
    drvs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;

      overlays = [
        (final: prev: drvs.packages.${system})
        (final: prev: eww.packages.${system})
        (final: prev: {
          obsidian = prev.obsidian.override {
            electron = final.electron_24;
          };
        })
        nur.overlay
        hyprland.overlays.default
      ];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-24.8.6"
          "electron-25.9.0"
        ];
      };
    };
    scripts = import ./modules/scripts.nix {inherit pkgs;};
    nur-no-pkgs = import nur {
      nurpkgs = import nixpkgs {inherit system;};
    };
    args = {
      inherit pkgs;
      inherit inputs;
      inherit scripts;
      inherit nix-colors;
      inherit nur-no-pkgs;
    };
  in {
    nixosConfigurations = {
      "mrugankLaptop" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = args;
        modules = [
          ./hosts/mrugankLaptop/configuration.nix

          nix-gaming.nixosModules.steamCompat

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = args;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mrugank = import ./hosts/mrugankLaptop/home.nix;
            };
          }
        ];
      };
      "mrugankDesktop" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = args;
        modules = [
          {nixpkgs.overlays = [nur.overlay];}

          ./hosts/mrugankDesktop/configuration.nix

          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd

          nix-gaming.nixosModules.pipewireLowLatency
          nix-gaming.nixosModules.steamCompat

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = args;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mrugank = import ./hosts/mrugankDesktop/home.nix;
            };
          }
        ];
      };
    };
  };
}
