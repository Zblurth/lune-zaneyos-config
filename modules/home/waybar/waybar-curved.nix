{ pkgs
, lib
, host
, config
, ...
}:
let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  clock24h = if (builtins.tryEval (import ../../../hosts/${host}/variables.nix)).success
             then (import ../../../hosts/${host}/variables.nix).clock24h
             else true;
in
with lib; {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";

        # Removed global margins to keep clock attached to corner

        modules-center = ["hyprland/workspaces" ];

        modules-left = [
          "custom/startmenu"
          "hyprland/window"
          "pulseaudio"
          "cpu"
          "memory"
          "idle_inhibitor"
        ];

        modules-right = [
          "mpris"
          "custom/hyprbindings"
          "custom/notification"
          "custom/brightness"
          "tray"
          "custom/exit"
          "clock"
        ];

        "mpris" = {
             player = "Deezer";
             format = "{player_icon} {dynamic}";
             format-paused = "{status_icon} <i>{dynamic}</i>";
             dynamic-order = ["title" "artist"];
             dynamic-separator = " - ";
             player-icons = {
                 default = "";
                 Deezer = "";
                 deezer = "";
                 firefox = "";
                 chromium = "";
             };
             status-icons = {
                 paused = "";
                 playing = "";
             };
             on-click = "playerctl --player=Deezer play-pause";
             on-scroll-up = "playerctl --player=Deezer next";
             on-scroll-down = "playerctl --player=Deezer previous";
             max-length = 45;
        };

        "custom/brightness" = {
            format = "{icon} {percentage}%";
            format-icons = ["" "" "" "" "" "" "" "" ""];
            return-type = "json";
            exec = "ddcutil getvcp 10 --bus 10 | awk '{print $9}' | tr -d ',' | xargs -I{} echo '{\"percentage\": {}}'";
            interval = 60;
            on-scroll-up = "ddcutil setvcp 10 + 5 --bus 10";
            on-scroll-down = "ddcutil setvcp 10 - 5 --bus 10";
            tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "clock" = {
          format =
            if clock24h == true
            then '' {:L%H:%M}''
            else '' {:L%I:%M %p}'';
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
                    mode = "month";
                    mode-mon-col = 3;
                    weeks-pos = "right";
                    on-scroll = 1;
                    format = {
                              months =     "<span color='#ffead3'><b>{}</b></span>";
                              days =       "<span color='#ecc6d9'><b>{}</b></span>";
                              weeks =      "<span color='#99ffdd'><b>W{}</b></span>";
                              today =      "<span color='#ff6699'><b><u>{}</u></b></span>";
                              };
                    };
        };

        "hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = " 🙈 No Windows? ";
          };
        };

        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
        };

        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };

        "network" = {
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };

        "tray" = {
          spacing = 12;
        };

        "pulseaudio" = {
          scroll-step = 5;
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "sleep 0.1 && pavucontrol";
        };

        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && wlogout";
        };

        "custom/startmenu" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && rofi-launcher";
        };

        "custom/hyprbindings" = {
          tooltip = false;
          format = "󱕴";
          on-click = "sleep 0.1 && list-keybinds";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = "true";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && task-waybar";
          escape = true;
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          on-click = "";
          tooltip = false;
        };
      }
    ];

    style = concatStrings [
      ''
        * {
          font-family: JetBrainsMono Nerd Font Mono;
          font-size: 14px; /* Reduced from 16px to shrink height */
          border-radius: 0px;
          border: none;
          min-height: 0px;
        }
        window#waybar {
          background: rgba(0,0,0,0);
        }
        #workspaces {
          color: #${config.lib.stylix.colors.base00};
          background: #${config.lib.stylix.colors.base01};
          margin: 6px 4px 4px 4px; /* Reduced top margin from 12px to 6px */
          padding: 5px 5px;
          border-radius: 16px;
        }
        #workspaces button {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          opacity: 0.5;
          transition: ${betterTransition};
        }
        #workspaces button.active {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          transition: ${betterTransition};
          opacity: 1.0;
          min-width: 40px;
        }
        #workspaces button:hover {
          font-weight: bold;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          opacity: 0.8;
          transition: ${betterTransition};
        }
        tooltip {
          background: #${config.lib.stylix.colors.base00};
          border: 1px solid #${config.lib.stylix.colors.base08};
          border-radius: 12px;
        }
        tooltip label {
          color: #${config.lib.stylix.colors.base08};
        }
        /* Left Modules */
        #window, #pulseaudio, #cpu, #memory, #idle_inhibitor {
          font-weight: bold;
          margin: 6px 0px 4px 0px; /* Reduced top margin */
          margin-left: 7px;
          padding: 0px 10px;
          background: #${config.lib.stylix.colors.base04};
          color: #${config.lib.stylix.colors.base00};
          border-radius: 24px 10px 24px 10px;
        }

        /* Deezer / Media */
        #mpris {
          background: #${config.lib.stylix.colors.base0E};
          color: #${config.lib.stylix.colors.base00};
          padding: 0px 10px;
          margin: 6px 0px 4px 0px; /* Reduced top margin */
          margin-right: 7px;
          font-weight: bold;
          border-radius: 10px 24px 10px 24px;
        }
        #mpris.paused {
           background: #${config.lib.stylix.colors.base03};
           color: #${config.lib.stylix.colors.base05};
        }

        #custom-startmenu {
          color: #${config.lib.stylix.colors.base0B};
          background: #${config.lib.stylix.colors.base02};
          font-size: 20px; /* Shrunk from 28px */
          margin: 0px; /* Keep at 0 to touch edge */
          padding: 0px 20px 0px 10px; /* Reduced padding */
          border-radius: 0px 0px 30px 0px; /* Reduced roundness */
        }

        /* Right Modules */
        #custom-hyprbindings, #network, #battery, #custom-brightness,
        #custom-notification, #tray, #custom-exit {
          font-weight: bold;
          background: #${config.lib.stylix.colors.base0F};
          color: #${config.lib.stylix.colors.base00};
          margin: 6px 0px 4px 0px; /* Reduced top margin */
          margin-right: 7px;
          border-radius: 10px 24px 10px 24px;
          padding: 0px 10px;
        }

        /* Clock - Shrinking it down */
        #clock {
          font-weight: bold;
          color: #0D0E15;
          background: linear-gradient(90deg, #${config.lib.stylix.colors.base0E}, #${config.lib.stylix.colors.base0C});
          margin: 0px;
          /* Reduced padding significantly to make it smaller */
          padding: 0px 10px 0px 20px;
          border-radius: 0px 0px 0px 30px; /* Tighter radius */
        }
      ''
    ];
  };
}
