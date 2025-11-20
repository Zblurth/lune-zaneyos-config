{ pkgs
, username
, ...
}: {
  services.greetd = {
    enable = true;
    vt = 3;
    settings = {
      default_session = {
        user = "greeter";
        # The command remains the same
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd Hyprland";
      };
    };
  };

  # 👇 ADD THIS SECTION
  # This creates the cache directory and gives ownership to the greeter user
  systemd.tmpfiles.rules = [
    "d /var/cache/tuigreet 0755 greeter greeter"
  ];
}
