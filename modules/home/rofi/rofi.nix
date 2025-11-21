{ pkgs, config, ... }:

let
  # --- TOOLS ---
  # We need jq to parse Hyprland's JSON output
  jq = "${pkgs.jq}/bin/jq";

  # Standard tools
  bash = "${pkgs.bash}/bin/bash";
  awk = "${pkgs.gawk}/bin/awk";
  pkill = "${pkgs.procps}/bin/pkill";
  whoami = "${pkgs.coreutils}/bin/whoami";
  sort = "${pkgs.coreutils}/bin/sort";
  sed = "${pkgs.gnused}/bin/sed";

  # --- HYBRID KILL SCRIPT ---
  rofiKill = pkgs.writeShellScriptBin "rofi-kill" ''
      export LC_ALL=C
      TARGET_USER=$(${whoami})

      # --- 1. HANDLE CLICKS ---
      CLEAN_ARG=$(echo "$@" | xargs)
      if [ -n "$CLEAN_ARG" ]; then
          # Extract the name (e.g. "Zed")
          selected_name=$(echo "$CLEAN_ARG" | ${awk} '{print $1}')

          # Kill it! (-i matches "Zed" to "zed")
          ${pkill} -u "$TARGET_USER" -f -i "$selected_name"
          exit 0
      fi

      # --- 2. GENERATE & CLEAN LIST ---
      hypr_list=$(hyprctl clients -j | ${jq} -r '.[] | .class')

      # Whitelist
      extra_list=""
      for app in "vesktop" "discord" "spotify" "deezer-enhanced" "steam" "obsidian"; do
          if pgrep -f "$app" > /dev/null; then
              extra_list="$extra_list
  $app"
          fi
      done

      # --- 3. COMBINE, NORMALIZE & FORMAT ---
      echo "$hypr_list
  $extra_list" | \
      ${sed} -E '
        s/[A-Z]/\L&/g;                       # Lowercase everything
        s/^dev\.zed\.zed$/zed/g;             # Fix Zed
        s/^kitty-dropterm$/kitty/g;          # Fix Kitty
        s/^vivaldi-stable$/vivaldi/g;        # Fix Vivaldi
        s/^[a-z]+\.[a-z]+\.//g;              # Remove prefixes
        s/\.desktop$//g;                     # Remove suffixes
      ' | \
      ${sort} | \
      ${awk} '
          length($0) == 0 { next }
          { count[$0]++ }
          END {
              for (app in count) {
                  # Calculate CPU
                  cmd = "ps -C " app " -o %cpu --no-headers | awk \"{s+=\\$1} END {print s}\""
                  cmd | getline cpu
                  close(cmd)
                  if (cpu == "") {
                      cmd = "ps -p $(pgrep -f " app " | head -n1) -o %cpu --no-headers"
                      cmd | getline cpu
                      close(cmd)
                  }
                  if (cpu == "") cpu = 0
                  print cpu, app
              }
          }
      ' | ${sort} -rn | while read -r cpu comm; do

          # --- ICON MAPPING ---
          icon_name="$comm"
          case "$comm" in
              "electron")   icon_name="vesktop" ;;
              "deezer-enhanced") icon_name="deezer" ;;
          esac

          # --- CAPITALIZATION (The Fix) ---
          # We use sed to capitalize the first letter.
          display_name=$(echo "$comm" | ${sed} 's/./\u&/')

          # Output
          printf "%s (%.1f%%)\0icon\x1f%s\n" "$display_name" "$cpu" "$icon_name"
      done
    '';

  inherit (config.lib.formats.rasi) mkLiteral;

# --- 2. START CONFIGURATION ---
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    extraConfig = {
      # LINK THE SCRIPT HERE
      modi = "drun,filebrowser,run,kill:${rofiKill}/bin/rofi-kill";

      show-icons = true;
      icon-theme = "Papirus";
      font = "JetBrainsMono Nerd Font Mono 12";
      drun-display-format = "{icon} {name}";

      display-drun = " Apps";
      display-run = " Run";
      display-filebrowser = " File";
      display-kill = " Kill";

      hover-select = true;
      me-select-entry = "";
      me-accept-entry = "MousePrimary";
    };

    # --- THEME ---
    theme = {
      "*" = {
        bg = mkLiteral "#${config.stylix.base16Scheme.base00}";
        bg-alt = mkLiteral "#${config.stylix.base16Scheme.base09}";
        foreground = mkLiteral "#${config.stylix.base16Scheme.base01}";
        selected = mkLiteral "#${config.stylix.base16Scheme.base08}";
        active = mkLiteral "#${config.stylix.base16Scheme.base0B}";
        text-selected = mkLiteral "#${config.stylix.base16Scheme.base00}";
        text-color = mkLiteral "#${config.stylix.base16Scheme.base05}";
        border-color = mkLiteral "#${config.stylix.base16Scheme.base0F}";
        urgent = mkLiteral "#${config.stylix.base16Scheme.base0E}";
      };

      "window" = {
        transparency = "real";
        width = mkLiteral "1000px";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";
        cursor = "default";
        enabled = true;
        border-radius = mkLiteral "15px";
        background-color = mkLiteral "@bg";
      };

      "mainbox" = {
        enabled = true;
        spacing = mkLiteral "0px";
        orientation = mkLiteral "horizontal";
        children = map mkLiteral [ "imagebox" "listbox" ];
        background-color = mkLiteral "transparent";
      };

      "imagebox" = {
        padding = mkLiteral "20px";
        background-color = mkLiteral "transparent";
        background-image = mkLiteral ''url("~/Pictures/Wallpapers/Rainnight.jpg", height)'';
        orientation = mkLiteral "vertical";
        children = map mkLiteral [ "inputbar" "dummy" "mode-switcher" ];
      };

      "listbox" = {
        spacing = mkLiteral "20px";
        padding = mkLiteral "20px";
        background-color = mkLiteral "transparent";
        orientation = mkLiteral "vertical";
        children = map mkLiteral [ "message" "listview" ];
      };

      "dummy" = {
        background-color = mkLiteral "transparent";
      };

      "inputbar" = {
        enabled = true;
        spacing = mkLiteral "10px";
        padding = mkLiteral "10px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@foreground";
        children = map mkLiteral [ "textbox-prompt-colon" "entry" ];
      };

      "textbox-prompt-colon" = {
        enabled = true;
        expand = false;
        str = "";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "entry" = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        placeholder = "Search";
        placeholder-color = mkLiteral "inherit";
      };

      "mode-switcher" = {
        enabled = true;
        spacing = mkLiteral "20px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
      };

      "button" = {
        padding = mkLiteral "15px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "pointer";
      };

      "button selected" = {
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@foreground";
      };

      "listview" = {
        enabled = true;
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;
        spacing = mkLiteral "10px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
        cursor = "default";
      };

      "element" = {
        enabled = true;
        spacing = mkLiteral "15px";
        padding = mkLiteral "8px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@text-color";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "@text-color";
      };
      "element normal.urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@text-color";
      };
      "element normal.active" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "@text-color";
      };
      "element selected.normal" = {
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@foreground";
      };
      "element selected.urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@text-selected";
      };
      "element selected.active" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@text-selected";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "36px";
        cursor = mkLiteral "inherit";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };

      "message" = {
        background-color = mkLiteral "transparent";
      };
      "textbox" = {
        padding = mkLiteral "15px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@foreground";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
      "error-message" = {
        padding = mkLiteral "15px";
        border-radius = mkLiteral "20px";
        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@foreground";
      };
    };
  };

  # Custom Desktop Entries
  xdg.desktopEntries = {
    vivaldi-private = {
      name = "Vivaldi Private";
      genericName = "Web Browser";
      exec = "vivaldi --incognito %U";
      terminal = false;
      categories = [ "Application" "Network" "WebBrowser" ];
      icon = "vivaldi";
    };
  };
}
