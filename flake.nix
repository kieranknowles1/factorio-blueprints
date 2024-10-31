{
  description = "A flake based on my NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixcfg = {
      url = "github:kieranknowles1/nixcfg";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";

      # Disable inputs not needed outside of nixcfg
      # These can be re-enabled if needed
      inputs.clan-core.follows = "";
      inputs.factorio-blueprints.follows = "";
      inputs.firefox-addons.follows = "";
      inputs.flake-utils-plus.follows = "";
      inputs.home-manager.follows = "";
      inputs.nix-index-database.follows = "";
      inputs.nixos-cosmic.follows = "";
      inputs.nixpkgs-openmw.follows = "";
      inputs.nixpkgs-stable.follows = "";
      inputs.nixvim.follows = "";
      inputs.openmw.follows = "";
      inputs.snowfall-lib.follows = "";
      inputs.sops-nix.follows = "";
      inputs.stylix.follows = "";
    };
  };

  outputs = {
    flake-parts,
    nixcfg,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: {
      systems = import inputs.systems;

      perSystem = {
        pkgs,
        inputs',
        ...
      }: {
        packages = {
          # Usage: `nix run [.#name=default]`
          default = let
            export = lib.getExe inputs'.nixcfg.packages.export-blueprints;
          in
            pkgs.writeShellScriptBin "export" ''
              ${export} ./blueprints text
            '';
        };
      };
    });
}
