{ pkgs, ... }:
let
  # 1. Define the modern GLSL shader (Version 300 es for Hyprland 0.50+)
  mkShader = opacity: ''
    #version 300 es
    precision mediump float;
    in vec2 v_texcoord;
    uniform sampler2D tex;
    out vec4 fragColor;

    void main() {
        vec4 pixColor = texture(tex, v_texcoord);
        fragColor = vec4(pixColor.rgb * ${opacity}, pixColor.a);
    }
  '';

  # 2. The Robust Script (Level Logic)
  # It calculates the current level (0-3) and simply adds or subtracts 1.
  shadeCycle = pkgs.writeShellScriptBin "shade-cycle" ''
    # Get current shader name and trim whitespace
    current=$(${pkgs.hyprshade}/bin/hyprshade current | xargs)

    # Define Levels:
    # 0 = off (100%)
    # 1 = dim-light (80%)
    # 2 = dim-medium (50%)
    # 3 = dim-heavy (20%)

    # Detect current level
    level=0
    if [[ "$current" == *"dim-light"* ]]; then level=1; fi
    if [[ "$current" == *"dim-medium"* ]]; then level=2; fi
    if [[ "$current" == *"dim-heavy"* ]]; then level=3; fi

    # Calculate target level
    target=$level
    if [[ "$1" == "down" ]]; then
        # Go Darker (Increase level, max 3)
        if [[ $level -lt 3 ]]; then target=$((level + 1)); fi
    elif [[ "$1" == "up" ]]; then
        # Go Brighter (Decrease level, min 0)
        if [[ $level -gt 0 ]]; then target=$((level - 1)); fi
    fi

    # Apply the change if the level is different
    if [[ $target -ne $level ]]; then
        if [[ $target -eq 0 ]]; then
            ${pkgs.hyprshade}/bin/hyprshade off
            ${pkgs.libnotify}/bin/notify-send -r 999 -t 1000 "Brightness" "100% (Normal)"
        elif [[ $target -eq 1 ]]; then
            ${pkgs.hyprshade}/bin/hyprshade on dim-light
            ${pkgs.libnotify}/bin/notify-send -r 999 -t 1000 "Brightness" "80% (Light Dim)"
        elif [[ $target -eq 2 ]]; then
            ${pkgs.hyprshade}/bin/hyprshade on dim-medium
            ${pkgs.libnotify}/bin/notify-send -r 999 -t 1000 "Brightness" "50% (Medium Dim)"
        elif [[ $target -eq 3 ]]; then
            ${pkgs.hyprshade}/bin/hyprshade on dim-heavy
            ${pkgs.libnotify}/bin/notify-send -r 999 -t 1000 "Brightness" "20% (Heavy Dim)"
        fi
    fi
  '';

in
{
  home.packages = with pkgs; [
    hyprshade
    shadeCycle
    libnotify # Used for the on-screen notification
  ];

  # 3. Write the shader files
  xdg.configFile."hypr/shaders/dim-light.glsl".text = mkShader "0.8";
  xdg.configFile."hypr/shaders/dim-medium.glsl".text = mkShader "0.5";
  xdg.configFile."hypr/shaders/dim-heavy.glsl".text = mkShader "0.2";
}
