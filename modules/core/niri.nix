{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri; # Uses the version from your flake inputs
  };

  # Essential for screen sharing and "Open File" dialogs
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    configPackages = [ pkgs.niri ];
  };

  # Niri needs a Polkit agent for authentication popups
  systemd.user.services.niri-polkit = {
    description = "Polkit GNOME authentication agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
