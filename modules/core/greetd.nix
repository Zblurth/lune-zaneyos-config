{ pkgs
, username
, ...
}: {
  services.greetd = {
    enable = true;
    # vt = 3; # Disabled for Unstable compatibility
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd Hyprland";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/cache/tuigreet 0755 greeter greeter"
  ];
}
