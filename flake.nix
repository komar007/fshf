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
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        stable = import inputs.nixpkgs {
          inherit system;
        };
        dependencies = with stable; [
          coreutils
          gnused
          gnugrep
          unixtools.column
          fzf
          openssh
          ncurses
        ];
        treefmtEval = inputs.treefmt-nix.lib.evalModule stable ./treefmt.nix;
      in
      rec {
        devShells.default = stable.mkShell {
          buildInputs = dependencies;
        };
        packages.fshf = stable.writeShellApplication {
          name = "session-chooser";
          runtimeInputs = dependencies;
          text = builtins.readFile ./session-chooser.sh;
        };
        packages.default = packages.fshf;
        formatter = treefmtEval.config.build.wrapper;
        checks = {
          formatting = treefmtEval.config.build.check self;
        };
      }
    );
}
