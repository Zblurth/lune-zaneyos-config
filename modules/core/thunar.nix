{ host
, pkgs
, ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) thunarEnable;
in
{
  # ADD THIS SECTION (services) to ensure thumbnails and trash work
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs = {
    # ADD THIS LINE to fix the "forgetting settings" issue
    xfconf.enable = true;

    thunar = {
      enable = thunarEnable;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
  ];
}
