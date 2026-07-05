{
  description = "Project Setup Flake";

  inputs = {
    dev-env-templates.url = "path:/home/mrugank/nixos/dev-env-templates";
    nixpkgs.follows = "dev-env-templates/nixpkgs";
  };

  outputs = { self, nixpkgs, dev-env-templates }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    extraPackages = [];
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = dev-env-templates.devShells.${system}.default.packages ++ extraPackages;
      shellHook = ''
        ${dev-env-templates.devShells.${system}.default.shellHook or ""}
      '';
    };
 };
}
