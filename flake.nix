{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, ... }@inputs:
    let
      dependencies =
        pkgs: with pkgs; [
          coreutils
          gnused
          gnugrep
          unixtools.column
          fzf
          openssh
          ncurses
        ];
      app =
        pkgs:
        pkgs.writeShellApplication {
          name = "fshf";
          runtimeInputs = dependencies pkgs;
          text = builtins.readFile ./fshf.sh;
        };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = import inputs.systems;
        flake = {
          overlays.default = final: prev: {
            fshf = app final;
          };
        };
        perSystem =
          { pkgs, ... }:
          let
            treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
          in
          {
            packages.default = app pkgs;
            devShells.default = pkgs.mkShell {
              buildInputs = dependencies pkgs;
            };

            formatter = treefmtEval.config.build.wrapper;
            checks = {
              formatting = treefmtEval.config.build.check self;
            };
          };
      }
    );
}
