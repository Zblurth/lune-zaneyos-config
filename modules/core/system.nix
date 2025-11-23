# 👇 Update the arguments list here to include 'pkgs' and 'inputs'
{ host, pkgs, inputs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) consoleKeyMap;
in
{
  nix = {
    settings = {
      download-buffer-size = 200000000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # --- Binary Caches (Updated) ---
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nyx.chaotic.cx"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    # DATE & TIME: Use UK English to get DD/MM/YYYY and Monday-start weeks
    LC_TIME = "en_GB.UTF-8";
    # UNITS & PAPER: Use French standard (Metric, A4)
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    # MONEY: Use French standard (Euro € and comma separator)
    LC_MONETARY = "fr_FR.UTF-8";
    # ADDRESS/PHONE: Use French standard (expecting French phone numbers/addresses)
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    # IMPORTANT: Keep Numbers as US (Dot for decimals)
    # Changing this to French (Comma for decimals) breaks MANY scripts and games.
    LC_NUMERIC = "en_US.UTF-8";
  };
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    ZANEYOS_VERSION = "2.4";
    ZANEYOS = "true";
  };
  console.keyMap = "${consoleKeyMap}";
  system.stateVersion = "23.11";
}
