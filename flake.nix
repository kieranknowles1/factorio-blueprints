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
              ${export} ./blueprints
            '';
        };
      };
    });
}
