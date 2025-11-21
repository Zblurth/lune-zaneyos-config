{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    # Keep your hardware overrides, they are good
    package = pkgs.btop.override {
      rocmSupport = true;
      cudaSupport = true;
    };
    settings = {
      # --- THE FIXES ---
      update_ms = 1500;           # 1.5s delay. Prevents the list from jumping while you try to click.
      proc_sorting = "cpu lazy";  # "Lazy" mode keeps the list order stable longer.
      theme_background = false;   # Transparent background (looks better floating).
      confirm_on_quit = false;

      # --- YOUR EXISTING SETTINGS ---
      vim_keys = true;
      rounded_corners = true;
      proc_tree = true;           # Keeps Vivaldi tabs collapsed
      show_gpu_info = "on";
      show_uptime = true;
      show_coretemp = true;
      cpu_sensor = "auto";
      show_disks = true;
      only_physical = true;
      io_mode = true;
      io_graph_combined = false;
    };
  };
}
