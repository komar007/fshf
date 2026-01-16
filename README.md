# fshf

An fzf-based shell/session chooser.

Fuzzy-choose from a list of available shells and SSH connections.

## Screenshot

![fshf screenshot](/../main/screenshot.png?raw=true "fshf screenshot")

## Supported sources

`fshf` currently supports the following sorces of sessions:

* the current shell (via `$SHELL`),
* the shells listed in `/etc/shells`,
* the ssh connections in `~/.ssh/config` + files included using `Include <path>` directive.

## Running

nix users can try it out using `nix run`:

```sh
nix run github:komar007/fshf
```

## Installation

For NixOS / home-manager, the flake contains the nix package and nixpkgs overlay for convenience.
