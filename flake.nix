{
  description = "ZaneyOS";

  inputs = {
      home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      nvf.url = "github:notashelf/nvf";
      stylix.url = "github:danth/stylix/master";
      nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    # Hypersysinfo  (Optional)
    #hyprsysteminfo.url = "github:hyprwm/hyprsysteminfo";

    # QuickShell (optional add quickshell to outputs to enable)
    #quickshell = {
    #  url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      chaotic,
      home-manager,
      nix-flatpak,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      profile = "amd";
      username = "lune";

      pkgs-unstable = import nixpkgs-unstable {
         inherit system;
         config.allowUnfree = true;
      };

      # Deduplicate nixosConfigurations while preserving the top-level 'profile'
      mkNixosConfig = gpuProfile: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile; # keep using the let-bound profile for modules/scripts
          inherit pkgs-unstable;
        };
        modules = [
          ./profiles/${gpuProfile}
          nix-flatpak.nixosModules.nix-flatpak

          # --- ADDED: Chaotic Module ---
          inputs.chaotic.nixosModules.default
        ];
      };
    in
    {
      nixosConfigurations = {
        amd = mkNixosConfig "amd";
        nvidia = mkNixosConfig "nvidia";
        nvidia-laptop = mkNixosConfig "nvidia-laptop";
        intel = mkNixosConfig "intel";
        vm = mkNixosConfig "vm";
      };
    };
}
