{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home.nix
    ../../wms/hyprland/desktop.nix
  ];

  home.packages = with pkgs; [
    # apps
    polychromatic
    razergenie
  ];
}
