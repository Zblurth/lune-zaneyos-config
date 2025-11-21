{ profile, ... }: {
  # 1. SERVICES BLOCK STARTS HERE
  services = {
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
      };
      ports = [ 22 ];
    }; # <--- This closes openssh, NOT services

    blueman.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable = true;

    smartd = {
      enable = if profile == "vm" then false else true;
      autodetect = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 256;
        };
      };
      extraConfig.pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "256/48000";
              pulse.default.req = "256/48000";
              pulse.max.req = "256/48000";
              pulse.min.quantum = "256/48000";
              pulse.max.quantum = "256/48000";
            };
          }
        ];
      };
    };
  }; # <--- THIS CLOSES THE SERVICES BLOCK.
     # Everything after this is a "Top Level" command.

     # 2. PROGRAMS & HARDWARE BLOCK
       programs.corectrl.enable = true;
       # Enable the Overclocking bits (The new name)
       hardware.amdgpu.overdrive.enable = true;
}
