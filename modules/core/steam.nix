{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = [
    # ProtonPlus from nixpkgs-unstable
    pkgs-unstable.protonplus
  ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;

      #extraCompatPackages = [
        # GE-Proton as stable fallback
        #pkgs.proton-ge-bin
      #];
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };
}
