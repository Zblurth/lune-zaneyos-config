{ pkgs, pkgs-unstable, config, ... }: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # --- Programs ---
  programs.coolercontrol.enable = true;
  programs.corectrl.enable = true;

  # --- Kernel & Drivers ---

  # 1. INSTALL the drivers (Package names)
  # We use 'with' so we don't have to type config.boot.kernelPackages twice
  boot.extraModulePackages = with config.boot.kernelPackages; [
    it87
    ddcci-driver
  ];

  # 2. LOAD the drivers (Module names)
  # Note: The module for ddcci-driver is actually called "ddcci_backlight"
  boot.kernelModules = [
    "it87"
    "ddcci_backlight"
  ];

  # 3. CONFIGURE the kernel (Boot parameters)
  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff" # Unlock GPU undervolting
    "acpi_enforce_resources=lax"      # Allow it87 to read motherboard sensors
  ];

  # 4. ENABLE Hardware Communication
  # DDC/CI needs I2C to talk to your monitor through the HDMI/DP cable
  hardware.i2c.enable = true;
}
