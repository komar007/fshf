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

## Configuration

FSHF can be customized using environment variables.

### `FSHF_REMOTE_CMD` (*string*)

Set to non-empty string to execute its content on the remote side for all ssh connections that
don't have `RemoteCommand` defined in `.ssh/config`.

### `FSHF_PAUSE_AFTER_SSH_FAIL` (`1`/`0`)

Set to `0` to disable pausing and waiting for return key after unsuccessful ssh exit status.

### `FSHF_MARGIN` (*string*)

The margin around the chooser's pane in the format of fzf's `--margin`.

### `FSHF_PADDING` (*integer*)

The padding inside the chooser's pane as a number of lines in the vertical direction (multipled by
2 for the number of characters in the horizontal direction).

### `FSHF_BG` (*string*)

The background color of the chooser's pane in the format described in the section *ANSI COLORS* of
`man fzf(1)`.
