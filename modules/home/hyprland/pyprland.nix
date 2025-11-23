{ pkgs, ... }: {
  home.packages = with pkgs; [ pyprland ];

  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [
      "scratchpads",
    ]

    [scratchpads.term]
    animation = "fromTop"
    # We set the class name to 'scratchpad' here...
    command = "wezterm start --class scratchpad"
    # ...so we must tell Pyprland to look for 'scratchpad' here.
    class = "scratchpad"
    size = "70% 70%"
    max_size = "1920px 100%"
    position = "150px 150px"
  '';
}
