{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether to enable hyprland configuration. Includes everything required to feel like a desktop environment.";
    type = mkOpt (enum ["desktop" "laptop"]) "desktop" "Whether this is a desktop or laptop.";
    settings = mkOpt attrs {} "Extra Hyprland settings.";
    extraConfig = mkOpt lines "" "Extra Hyprland config lines.";
    hyprlock = mkOpt attrs {} "Extra Hyprlock settings.";
    hypridle = mkOpt attrs {} "Extra Hypridle settings.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
    with pkgs.${namespace}; [
      wl-clipboard
      cliphist
      swww
      libnotify
      hyprkeys
      xwaylandvideobridge
      wdisplays
      choose-wallpaper
      random-wallpaper
      grimblast
      pavucontrol
    ];

    ${namespace}.apps = {
      waybar = enabled;
      mako = enabled;
      wlogout = enabled;
      rofi = enabled;
    };

    wayland.windowManager.hyprland = with config.lib.stylix.colors; {
      enable = true;

      settings = let
        inactive_color = "rgb(${base02})";
        active_color = "rgb(${base0D}) rgb(${base0E}) 45deg";
      in
        mkMerge
        [
          {
            general = {
              border_size = 2;
              gaps_in = 4;
              gaps_out = 8;
              "col.inactive_border" = inactive_color;
              "col.active_border" = active_color;
              "col.nogroup_border" = inactive_color;
              "col.nogroup_border_active" = active_color;
              resize_on_border = true;
              layout = "dwindle";
            };

            cursor = {
              inactive_timeout = 15;
              no_warps = true;
            };

            dwindle = {
              force_split = 0;
              no_gaps_when_only = true;
            };

            decoration = {
              rounding = 2;
            };

            input = {
              follow_mouse = 2;
              kb_layout = "us,ara";
              kb_options = "grp:ctrls_toggle";
            };

            gestures = {
              workspace_swipe = true;
              workspace_swipe_invert = false;
            };

            misc = {
              disable_hyprland_logo = true;
              mouse_move_focuses_monitor = false;
              mouse_move_enables_dpms = true;
              new_window_takes_over_fullscreen = 1;
            };

            binds = {
              allow_workspace_cycles = true;
            };

            # Startup
            exec-once = [
              # Wallpaper
              "swww init"
              # Top bar
              "waybar -c ~/.config/waybar/${cfg.type}-config.json > /tmp/waybar.log &"
              "gammastep -c ~/.config/gammastep/config.ini &"
              "ddc-dp 100 &"
              "ddc-hd 100 &"
            ];

            windowrulev2 = hypr.windowrules [
              {
                windows = [
                  "class:^(discord)$"
                  "class:^(vesktop)$"
                  "class:^(Slack)$"
                ];
                rules = ["workspace 6"];
              }
              {
                windows = ["class:^(pavucontrol)$"];
                rules = ["workspace 10"];
              }
              {
                windows = ["class:^(.blueman-manager-wrapped)$"];
                rules = ["workspace 10"];
              }
              {
                windows = ["class:^(org.gnome.Calculator)$"];
                rules = [
                  "float"
                  "center"
                  "size 450 750"
                ];
              }
              {
                windows = ["class:^(xwaylandvideobridge)$"];
                rules = [
                  "opacity 0.0 override 0.0 override"
                  "noanim"
                  "nofocus"
                  "noinitialfocus"
                ];
              }
              {
                windows = ["title:^()$,class:^(steam)$"];
                rules = [
                  "stayfocused"
                  "minsize 1 1"
                ];
              }
              {
                windows = ["class:^(org.gnome-Calculator)$"];
                rules = [
                  "float"
                  "center"
                  "size 450, 750"
                ]
              }
            ];

            # TODO: use binaries directly from store for each binding.
            bind = let
              workspaces = range 1 11;
              directions = [
                ["H" "l"]
                ["Left" "l"]
                ["J" "d"]
                ["Down" "d"]
                ["K" "u"]
                ["Up" "u"]
                ["L" "r"]
                ["Right" "r"]
              ];
            in
              with builtins;
                [
                  # General
                  "ALT, W, exec, choose-wallpaper"
                  "ALT, R, exec, random-wallpaper"
                  "ALT SHIFT, X, exec, hyprlock"
                  "SUPER, B, exec, $BROWSER"
                  "SUPER, Space, exec, rofi -show drun"
                  "SUPER, Return, exec, kitty -1"
                  "CTRL, Grave, exec, makoctl restore"
                  "CTRL, Space, exec, makoctl dismiss"
                  "CTRL SHIFT, Space, exec, makoctl dismiss --all"

                  ## Hyprland ##
                  "SUPER, W, killactive"
                  "SUPER SHIFT, C, cyclenext, prev"
                  "SUPER, C, cyclenext"
                  "SUPER, F, togglefloating"
                  "SUPER SHIFT, F, fullscreen"
                  "SUPER, M, fullscreen, 1" # Monocle mode
                  "SUPER, Tab, workspace, previous"
                ]
                # - Move focus
                ++ (map (x: "SUPER, ${elemAt x 0}, movefocus, ${elemAt x 1}") directions)
                # - Move window
                ++ (map (x: "SUPER SHIFT, ${elemAt x 0}, movewindow, ${elemAt x 1}") directions)
                # - Workspaces
                ++ (map (x: "SUPER, ${toString (modulo x 10)}, workspace, ${toString x}") workspaces)
                # - Move window to workspace
                ++ (map (x: "SUPER SHIFT, ${toString (modulo x 10)}, movetoworkspace, ${toString x}") workspaces);
            bindm = [
              "SUPER, mouse:272, movewindow"
            ];
            bindl = [
              "ALT SHIFT, S, exec, systemctl suspend"
              "ALT SHIFT, H, exec, systemctl hibernate"
            ];
            binde = [
              ",XF86AudioLowerVolume, exec, pamixer -d 5"
              ",XF86AudioRaiseVolume, exec, pamixer -i 5"
              ",XF86AudioMute, exec, pamixer -t"
              ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
              ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
              ",XF86Calculator, exec, gnome-calculator"
            ];
          }
          cfg.settings
        ];

      extraConfig = with pkgs;
        mkMerge [
          ''
            bind = ,Print,submap,capture

            submap = capture

            bind = ,G, exec, ${grimblast}/bin/grimblast --notify copysave area
            bind = ,G, submap, reset
            bind = ,Print, exec, ${grimblast}/bin/grimblast --notify copysave active
            bind = ,Print, submap, reset
            bind = ,S, exec, ${grimblast}/bin/grimblast --notify copysave output
            bind = ,S, submap, reset

            submap=reset
          ''
          cfg.extraConfig
        ];
    };

    programs.hyprlock = mkMerge [
      {
        enable = true;
        settings = {
          background = [
            {
              monitor = "";
              path = "$HOME/.cache/background-img";
            }
          ];
          image = [
            {
              monitor = "";
              path = "$HOME/.face.icon";
              size = 200;
            }
          ];
        };
      }
      cfg.hyprlock
    ];

    services.hypridle = mkMerge [
      {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = builtins.concatStringsSep "; " [
              "loginctl lock-session"
              "${pkgs.playerctl}/bin/playerctl pause"
            ];
          };
        };
      }
      cfg.hypridle
    ];

    services.kdeconnect = {
      enable = true;
      indicator = true; # Phone integration
    };
    services.cliphist.enable = true; # Clipboard history for wayland
    services.udiskie.enable = true; # USB automount
  };
}
