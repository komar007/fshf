{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    systems.url = "github:nix-systems/default-linux";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, flake-utils, ... }@inputs:
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
      fshf =
        pkgs:
        pkgs.writeShellApplication {
          name = "fshf";
          runtimeInputs = dependencies pkgs;
          text = builtins.readFile ./fshf.sh;
        };
    in
    {
      overlays.default = final: prev: {
        fshf = fshf final;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        stable = import inputs.nixpkgs {
          inherit system;
        };

        treefmtEval = inputs.treefmt-nix.lib.evalModule stable ./treefmt.nix;
      in
      rec {
        devShells.default = stable.mkShell {
          buildInputs = dependencies stable;
        };
        packages.fshf = fshf stable;
        packages.default = packages.fshf;
        formatter = treefmtEval.config.build.wrapper;
        checks = {
          formatting = treefmtEval.config.build.check self;
        };
      }
    );
}
