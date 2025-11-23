{ ... }:
{
  # Configure Hyprland Portal to allow screen sharing token restoration
  # This stops the infinite "Select Monitor" loops in Discord/Vesktop
  xdg.configFile."hypr/xdph.conf".text = ''
    screencopy {
      max_fps = 60
      allow_token_by_default = true
    }
  '';
}
