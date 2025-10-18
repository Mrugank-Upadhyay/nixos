{ pkgs }:

{
  packages = with pkgs; [
    nodejs_24
    pnpm
    eslint
    prettier
    python312
    python312Packages.pip
    python312Packages.requests
    python312Packages.fastapi
    python312Packages.fastapi-cli
  ];
  shellHook = ''
  '';
}
