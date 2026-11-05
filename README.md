# dotfiles

My personal config, deployed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a Stow *package* whose internal tree mirrors `$HOME`.
For example `fish/.config/fish/config.fish` is linked to `~/.config/fish/config.fish`.
To track a new config file, just drop it at the matching path inside a package.

| Package | Deploys to |
| --- | --- |
| `claude` | `~/.claude/` - Claude Code settings, statusline, tmux session hooks |
| `fish`   | `~/.config/fish/` - fish config and the fisher plugin list |
| `git`    | `~/.gitconfig`, `~/.gitignore` |
| `nvim`   | `~/.config/nvim/` - lazy.nvim setup |
| `sh`     | `~/.config/alias/` - aliases shared by every shell |
| `ssh`    | `~/.ssh/config` |
| `tmux`   | `~/.tmux.conf` |

`mac/` is **not** a Stow package. It is a reference archive of app exports
(Raycast, Shortcuts, Karabiner, Phoenix) that have no deployable `$HOME` layout;
its `.stow-local-ignore` makes an accidental `stow mac` a no-op.

## Fresh machine

```sh
./init.sh
```

Installs Homebrew, GNU Stow, tpm, fzf, ripgrep, fd, zoxide, fnm and fish (falling back to
the platform package manager or the git/curl installers when Homebrew is
unavailable), deploys every package, and installs the fish plugins. Re-running
it is safe - the Stow step uses `--restow`.

It does not change your login shell. The script finishes by printing the exact
`chsh` command to make fish the default (plus the `/etc/shells` line if fish is
not listed there yet).

## nvim fuzzy finding

[fzf-lua](https://github.com/ibhagwan/fzf-lua) with a shared ignore list
(`node_modules`, `dist`, `build`, lock files) defined at the top of
`nvim/.config/nvim/lua/plugins/fuzzy-finder.lua`.

| Key | Picker |
| --- | --- |
| `<space>f` / `<space>F` | files (respects `.gitignore`) / every file |
| `<space>a` / `<space>A` | live grep / live grep with no filtering |
| `<space>b` `<space>t` `<space>r` | buffers, tabs, registers |
| `<space>gs` `<space>gl` `<space>gb` `<space>gd` | git status, commits, branches, diff |

Live grep takes ripgrep globs inline after a ` -- ` separator. Write them bare -
each space-separated token becomes an `--iglob`, so a `-g` flag or quotes would be
read as part of the glob itself:

```
useEffect -- *.tsx              only .tsx files
useEffect -- !*test*            everything except test files
useEffect -- *.ts !*.spec.ts    include and exclude together
useEffect -- src/**             scope to a subtree
```

Inside any picker, `!term` excludes from the visible list, `'term` matches exactly,
`a | b` is OR, and `^a` / `a$` anchor. File pickers add `<alt-i>` (toggle
`.gitignore`), `<alt-h>` (hidden files), `<alt-f>` (follow symlinks) and `<ctrl-g>`
(switch between live grep and grep).

## Deploying a single package

```sh
stow --dir="$PWD" --target="$HOME" --no-folding --restow fish
```

`--no-folding` is important: without it, Stow replaces a *missing* target
directory with one symlink into this repo, and then anything the app writes at
runtime (`~/.ssh` keys, Claude Code's session state) lands inside the git repo.

To remove a package's symlinks, swap `--restow` for `--delete`.

## Pulling a machine's local edits back into the repo

If a config was edited in place at `$HOME` instead of here, `--adopt` moves the
live file into the package and replaces it with a symlink. It **overwrites** the
repo's copy, so commit first and review with `git diff`:

```sh
stow --dir="$PWD" --target="$HOME" --no-folding --adopt fish
git diff
```
