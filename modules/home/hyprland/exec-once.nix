{ host, ... }:
let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    stylixImage
    ;
in
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      # --- System Services ---
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user start hyprpolkitagent"

      # --- UI Components ---
      "killall -q swww;sleep .5 && swww-daemon"
      "killall -q waybar;sleep .5 && waybar"
      "killall -q swaync;sleep .5 && swaync"
      "#wallsetter &"
      "pypr &"
      "nm-applet --indicator"
      "sleep 1.0 && swww img ${stylixImage}"

      # --- Your Custom Startup Apps ---
      # CoreCtrl (Start hidden in tray)
      "corectrl --minimize-to-tray"

      # Vivaldi (Start on Desktop 2, but allow new windows anywhere else later)
      "[workspace 2 silent] vivaldi"

      # Media Apps (Just launch them, the Window Rules will catch them)
            "vesktop"
            "deezer-enhanced"
            "corectrl"
    ];
  };
}
