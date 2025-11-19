{ pkgs, pkgs-unstable, config, ... }: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  programs.coolercontrol.enable = true;

  boot.extraModulePackages = [ config.boot.kernelPackages.it87 ];
  boot.kernelModules = [ "it87" ];

  programs.corectrl.enable = true;
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
}
