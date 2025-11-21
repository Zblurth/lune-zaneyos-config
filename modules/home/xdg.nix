{ pkgs, ... }: {
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        # Text / Code
        "text/plain" = [ "dev.zed.Zed.desktop" ];
        "text/x-nix" = [ "dev.zed.Zed.desktop" ];
        "text/markdown" = [ "dev.zed.Zed.desktop" ];
        "application/x-shellscript" = [ "dev.zed.Zed.desktop" ];

        # Directory (Folder)
        "inode/directory" = [ "thunar.desktop" ];

        # Web
        "text/html" = [ "vivaldi.desktop" ];
        "x-scheme-handler/http" = [ "vivaldi.desktop" ];
        "x-scheme-handler/https" = [ "vivaldi.desktop" ];
      };
    };
    # ... portal stuff ...
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.hyprland ];
    };
  };
}
