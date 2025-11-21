{ host
, config
, pkgs
, ...
}:
let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    extraMonitorSettings
    keyboardLayout
    stylixImage
    ;
in
{
  home.packages = with pkgs; [
    swww
    grim
    slurp
    wl-clipboard
    swappy
    ydotool
    hyprpolkitagent
    hyprland-qtutils
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  # Place Files Inside Home Directory
  home.file = {
    #"Pictures/Wallpapers" = {
      #source = ../../../wallpapers;
      #recursive = true;
      #};
    ".face.icon".source = ./face.jpg;
    ".config/face.jpg".source = ./face.jpg;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;

    # --- 1. PLUGINS MUST GO HERE ---
    plugins = [
      pkgs.hyprlandPlugins.hyprscrolling
    ];

    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
    xwayland = {
      enable = true;
    };

    settings = {
      input = {
        kb_layout = "${keyboardLayout}";
        kb_options = [
          "grp:alt_caps_toggle"
          "caps:super"
        ];
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 1;
        float_switch_override_focus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
        };
      };

      gestures = {
      };

      general = {
        "$modifier" = "SUPER";
        # --- 2. LAYOUT SET TO hyprscrolling ---
        layout = "scrolling";
        gaps_in = 6;
        gaps_out = 8;
        border_size = 2;
        resize_on_border = true;
        "col.active_border" = "rgb(${config.lib.stylix.colors.base08}) rgb(${config.lib.stylix.colors.base0C}) 45deg";
        "col.inactive_border" = "rgb(${config.lib.stylix.colors.base01})";
      };

      misc = {
        layers_hog_keyboard_focus = true;
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        enable_swallow = false;
        vfr = true;
        vrr = 2;
        enable_anr_dialog = true;
        anr_missed_pings = 15;
      };

      # --- 3. SCROLLER SETTINGS (Niri Logic) ---
      plugin = {
        hyprscrolling = {
        # Default width (0.5 = 50% of screen)
              column_width = 0.5;
               # Configured widths to cycle through (0.33, 0.5, 0.66, 1.0)
               # This replaces the old "onehalf", "onethird" text logic
               explicit_column_widths = "0.333, 0.5, 0.667, 1.0";
               # Focus behavior
               focus_fit_method = 1; # 0 = center, 1 = fit
               follow_focus = true;
              };
            };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          ignore_opacity = false;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      ecosystem = {
        no_donation_nag = true;
        no_update_news = false;
      };

      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = 2;
        enable_hyprcursor = false;
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      render = {
        direct_scanout = 0;
      };

      xwayland = {
        force_zero_scaling = true;
      };
    };

    extraConfig = "
      monitor=,preferred,auto,auto
      monitor=Virtual-1,1920x1080@60,auto,1
      ${extraMonitorSettings}
    ";
  };
}
