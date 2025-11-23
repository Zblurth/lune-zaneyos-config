{ pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;

    # We put EVERYTHING in here. No need for home.file.
    extraConfig = ''
      -- 1. INIT WEZTERM
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()

      -- 2. THE CRITICAL FIX FOR BTOP (Mod+Q support)
      config.skip_close_confirmation_for_processes_named = {
        "bash", "sh", "zsh", "fish", "btop", "htop", "clipse"
      }

      -- 3. GENERAL SETTINGS (Your Custom Config)
      config.enable_wayland = false
      config.window_background_opacity = 0.90
      config.color_scheme = "nightfox"
      config.font_size = 12
      config.font = wezterm.font("FiraCode", { weight = "Regular", italic = false })

      -- 4. VISUALS & UI
      config.window_padding = {
        left = 10, right = 10, top = 10, bottom = 10,
      }

      -- Tab Bar Settings
      -- Note: If you want the "clean app" look for Btop, set this to false.
      -- But if you want your fancy tabs for normal terminal use, keep it true.
      config.enable_tab_bar = true
      config.use_fancy_tab_bar = true

      config.colors = {
        tab_bar = {
          background = "#00141d",
          active_tab = { bg_color = "#80bfff", fg_color = "#00141d" },
          inactive_tab = { bg_color = "#1a1a1a", fg_color = "#FFFFFF" },
          new_tab = { bg_color = "#1a1a1a", fg_color = "#4fc3f7" },
        },
      }

      config.window_frame = {
        font = wezterm.font({ family = "JetBrainsMono Nerd Font Mono", weight = "Regular" }),
      }

      config.default_cursor_style = "BlinkingUnderline"
      config.cursor_blink_rate = 500
      config.term = "xterm-256color"
      config.max_fps = 144
      config.animation_fps = 30

      -- 5. KEYBINDINGS
      config.keys = {
        -- Tab management
        { key = "t", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
        { key = "w", mods = "ALT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
        { key = "n", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
        { key = "p", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },

        -- Pane management
        { key = "v", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "h", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "q", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

        -- Pane navigation
        { key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
        { key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
        { key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
        { key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
      }

      return config
    '';
  };
}
