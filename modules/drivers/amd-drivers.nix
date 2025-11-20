{ lib
, pkgs
, config
, ...
}:
with lib;
let
  cfg = config.drivers.amdgpu;
in
{
  options.drivers.amdgpu = {
    enable = mkEnableOption "Enable AMD Drivers";
  };

  config = mkIf cfg.enable {
    # --- NEW: Enable Mesa-Git (FSR4 Support) ---
    # This replaces the stable Mesa drivers with the git version from Chaotic-Nyx.
    # Required for RX 9070 XT FSR4 "upgrade" support.
    chaotic.mesa-git.enable = true;

    # Optional: Enable 32-bit support explicitly if needed (usually automatic)
    # chaotic.mesa-git.enable32Bit = true;

    # --- EXISTING CONFIGURATION ---
    # I have kept these active as they do not conflict with mesa-git.

    # Fix for ROCm/HIP paths
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

    # Load the kernel driver
    services.xserver.videoDrivers = [ "amdgpu" ];

    # If you ever want to revert to stable mesa, just comment out
    # 'chaotic.mesa-git.enable = true;' above.
  };
}
