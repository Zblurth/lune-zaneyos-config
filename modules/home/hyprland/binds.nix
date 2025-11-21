{ host, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix) browser terminal;
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # --- Standard Apps ---
      # --- Standard Apps ---
      "$modifier, Return, exec, ${terminal}"   # Main Terminal (Tiled)
      "$modifier, W, exec, ${browser}"         # Browser
      "$modifier, Z, exec, zeditor"            # Text Editor ONLY
      "$modifier, T, exec, thunar"             # Tiled Thunar
      "$modifier SHIFT, W, exec, wallsetter"
      "ALT, space, exec, rofi-launcher"
      "$modifier SHIFT, Q, exec, rofi -show kill"
      "$modifier, Q, killactive,"
      "$modifier SHIFT, C, exit,"
      "$modifier, Escape, exec, wezterm start --class btop -- btop"
      "$modifier, F1, exec, shade-cycle down"
      "$modifier, F2, exec, shade-cycle up"
      "$modifier SHIFT, F1, exec, hyprshade off"

      # --- FLOATING WINDOWS ---

      # 1. Floating Thunar
      # 'dbus-run-session' isolates this thunar so it can't see your other open tabs.
      # It forces a brand new window every time.
      "$modifier, F, exec, [float;center;size 60% 70%] dbus-run-session thunar"

      # 2. Floating WezTerm
      # '--always-new-process' tells WezTerm to ignore other windows and spawn fresh.
      "$modifier SHIFT, T, exec, [float;move 5% 10%;size 30% 45%] wezterm start --always-new-process"

      # --- Overview (Window Switcher) ---
      # Shows all open windows across workspaces
      "$modifier, Tab, exec, rofi -show window"

      # --- 1. FOCUS (Super + Arrow) ---
      "$modifier, Left, movefocus, l"
      "$modifier, Right, movefocus, r"
      "$modifier, Up, movefocus, u"
      "$modifier, Down, movefocus, d"

      # --- 2. MOVE WINDOW (Super + Shift + Arrow) ---
      # Use 'layoutmsg, movewindowto' for Left/Right to auto-create columns (Unstuck)
      "$modifier SHIFT, Left, layoutmsg, movewindowto l"
      "$modifier SHIFT, Right, layoutmsg, movewindowto r"

      # Keep standard 'movewindow' for Up/Down (Stack movement)
      "$modifier SHIFT, Up, movewindow, u"
      "$modifier SHIFT, Down, movewindow, d"

      # --- 3. WORKSPACE MANAGEMENT ---
      "$modifier, 1, workspace, 1"
      "$modifier, 2, workspace, 2"
      "$modifier, 3, workspace, 3"
      "$modifier, 4, workspace, 4"
      "$modifier, 5, workspace, 5"

      "$modifier SHIFT, 1, movetoworkspace, 1"
      "$modifier SHIFT, 2, movetoworkspace, 2"
      "$modifier SHIFT, 3, movetoworkspace, 3"
      "$modifier SHIFT, 4, movetoworkspace, 4"
      "$modifier SHIFT, 5, movetoworkspace, 5"

      # --- 4. RESIZING (Brackets) ---
      "$modifier, bracketleft, layoutmsg, colresize -conf"
      "$modifier, bracketright, layoutmsg, colresize +conf"

      # --- 5. WINDOW STATES ---
      "$modifier SHIFT, F, fullscreen,"
      "$modifier ALT, F, togglefloating,"
      "$modifier ALT, P, pin,"

      # --- Utilities ---
      "$modifier, S, exec, screenshootin"
      "$modifier, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      "$modifier, E, exec, emopicker9000"

      # --- Deezer Keys ---
      ", XF86AudioPlay, exec, playerctl --player=Deezer play-pause"
      ", XF86AudioNext, exec, playerctl --player=Deezer next"
      ", XF86AudioPrev, exec, playerctl --player=Deezer previous"

      # --- SCROLL WHEEL (DEEZER ONLY) ---
      ", XF86AudioRaiseVolume, exec, playerctl --player=Deezer volume 0.05+"
      ", XF86AudioLowerVolume, exec, playerctl --player=Deezer volume 0.05-"
      ", XF86AudioMute, exec, playerctl --player=Deezer play-pause"

      # --- Media Keys ---
      "CTRL, XF86AudioPlay, exec, playerctl play-pause"
      "CTRL, XF86AudioNext, exec, playerctl next"
      "CTRL, XF86AudioPrev, exec, playerctl previous"
    ];

    bindm = [
      "$modifier, mouse:272, movewindow"
      "$modifier, mouse:273, resizewindow"
    ];
  };
}
