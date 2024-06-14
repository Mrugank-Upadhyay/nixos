{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hypr.nix
  ];
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        touchpad = {
          natural_scroll = true;
        };
      };

      misc = {
        vfr = true;
      };

      exec-once = [
        "waybar -c ~/.config/waybar/laptop-config.json > /tmp/waybar.log &"
      ];

      monitor = ",highrr,auto,1";
    };
  };
}
