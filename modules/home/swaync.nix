{ config, ... }: {
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = false;
      control-center-width = 500;
      control-center-height = 1025;
      notification-window-width = 500;
      keyboard-shortcuts = false;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
      widget-config = {
        title = {
          text = "Notification Center";
          clear-all-button = true;
          button-text = "󰆴 Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 1;
          text = "Notification Center";
        };
        mpris = {
          image-size = 96;
          image-radius = 7;
        };
        volume = {
          label = "󰕾";
        };
        backlight = {
          label = "󰃟";
        };
      };
      widgets = [
        "title"
        "mpris"
        "volume"
        "backlight"
        "dnd"
        "notifications"
      ];
    };
    style = ''
          * {
            font-family: JetBrainsMono Nerd Font Mono;
            font-weight: bold;
          }

          /* --- 1. MAIN CONTAINER (The Grid) --- */
          .control-center {
            background: #${config.lib.stylix.colors.base00};
            border: 2px solid #${config.lib.stylix.colors.base0C};
            border-radius: 12px;
            box-shadow: none;
            /* This single padding value controls the alignment for EVERYTHING */
            padding: 15px;
          }

          /* --- 2. WIDGET RESET (Force alignment) --- */
          /* Remove all margins so they touch the container padding perfectly */
          .widget-title,
          .widget-dnd,
          .widget-mpris,
          .widget-volume,
          .widget-backlight,
          .notification-row {
            margin: 0px 0px 10px 0px; /* Bottom spacing only */
            padding: 0px;
            border-radius: 12px;
            width: auto; /* Let them fill the space naturally */
          }

          /* --- 3. NOTIFICATION ROW FIXES --- */
          .control-center-list {
            background: transparent;
          }

          .notification-row {
            outline: none;
            background: transparent !important;
            box-shadow: none !important;
            border: none !important;
          }

          .notification-content {
            background: #${config.lib.stylix.colors.base00};
            padding: 0;
            border: 2px solid #${config.lib.stylix.colors.base0D};
            border-radius: 12px;
            margin: 0;
            overflow: hidden;
          }

          /* --- 4. TEXT FIXES --- */
          .summary {
            margin: 12px 12px 0px 12px;
            font-size: 16px;
            color: rgba(158, 206, 106, 1);
            text-shadow: none;
          }

          .body {
            margin: 4px 12px 12px 12px;
            font-size: 15px;
            color: #${config.lib.stylix.colors.base05};
            text-shadow: none;
            line-height: 1.4; /* Fixes cut-off text */
            padding-bottom: 4px;
          }

          .time {
            margin: 12px 12px 0px 0px;
            font-size: 14px;
            color: #${config.lib.stylix.colors.base05};
            text-shadow: none;
            margin-right: 20px;
          }

          /* --- 5. BUTTONS --- */
          .notification-default-action,
          .notification-action {
            padding: 10px;
            margin: 0;
            border: none;
            border-top: 1px solid #${config.lib.stylix.colors.base0D};
            background: #${config.lib.stylix.colors.base01};
            color: #${config.lib.stylix.colors.base05};
            border-radius: 0;
          }

          .notification-default-action:hover,
          .notification-action:hover {
            background: #${config.lib.stylix.colors.base02};
            color: #${config.lib.stylix.colors.base07};
          }

          .notification-default-action:not(:only-child) {
            border-bottom-left-radius: 0px;
            border-bottom-right-radius: 0px;
          }

          .close-button {
            background: #${config.lib.stylix.colors.base08};
            color: #${config.lib.stylix.colors.base00};
            text-shadow: none;
            padding: 0;
            border-radius: 100%;
            margin-top: 10px;
            margin-right: 10px;
            min-width: 24px;
            min-height: 24px;
            box-shadow: none;
            border: none;
          }
          .close-button:hover {
            background: #${config.lib.stylix.colors.base0D};
            transition: all .15s ease-in-out;
            border: none;
          }

          /* --- 6. WIDGET SPECIFICS --- */
          /* Title Widget */
          .widget-title {
            color: #${config.lib.stylix.colors.base0B};
            background: #${config.lib.stylix.colors.base00};
            padding: 10px;
          }
          .widget-title > button {
            font-size: 1rem;
            color: #${config.lib.stylix.colors.base05};
            background: #${config.lib.stylix.colors.base00};
            box-shadow: none;
            border-radius: 12px;
          }
          .widget-title > button:hover {
            background: #${config.lib.stylix.colors.base08};
            color: #${config.lib.stylix.colors.base00};
          }

          /* DND Widget */
          .widget-dnd {
            background: #${config.lib.stylix.colors.base00};
            padding: 10px;
            font-size: large;
            color: #${config.lib.stylix.colors.base0B};
          }
          .widget-dnd > switch {
            border-radius: 12px;
            background: #${config.lib.stylix.colors.base0B};
          }
          .widget-dnd > switch:checked {
            background: #${config.lib.stylix.colors.base08};
            border: 1px solid #${config.lib.stylix.colors.base08};
          }
          .widget-dnd > switch slider {
            background: #${config.lib.stylix.colors.base00};
            border-radius: 12px;
          }

          /* Mpris (Media) Widget */
          .widget-mpris {
            color: #${config.lib.stylix.colors.base05};
            padding: 0px; /* Reset padding to align with cards */
          }
          /* The media player has its own internal structure,
             we need to make sure it hits the edges */
          .widget-mpris > box {
             margin: 0px;
             padding: 10px;
             border-radius: 12px;
             background: #${config.lib.stylix.colors.base00}; /* Match card background */
          }

          /* Sliders */
          .widget-volume { background: transparent; padding: 0px; margin: 5px 0; }
          .widget-backlight { background: transparent; padding: 0px; margin: 5px 0; }

          .widget-volume > box {
            background: #${config.lib.stylix.colors.base00};
            border-radius: 12px;
            padding: 5px;
          }
          .widget-backlight > box {
            background: #${config.lib.stylix.colors.base00};
            border-radius: 12px;
            padding: 5px;
          }
        '';
  };
}
