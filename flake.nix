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
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = import inputs.systems;
        perSystem =
          { pkgs, ... }:
          let
            dependencies = with pkgs; [
              coreutils
              gnused
              gnugrep
              unixtools.column
              fzf
              openssh
              ncurses
            ];
            treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
          in
          {
            packages.default = pkgs.writeShellApplication {
              name = "fshf";
              runtimeInputs = dependencies;
              text = builtins.readFile ./fshf.sh;
            };
            devShells.default = pkgs.mkShell {
              buildInputs = dependencies;
            };

            formatter = treefmtEval.config.build.wrapper;
            checks = {
              formatting = treefmtEval.config.build.check self;
            };
          };
        flake = {
          overlays.default = final: prev: {
            fshf = self.packages.${final.stdenv.hostPlatform.system}.default;
          };
        };
      }
    );
}
