# Nixvim Setup Quick Reference

## Getting rid of Missing Spell File

> [source](https://github.com/neovim/neovim/issues/2102#issuecomment-1477098707)

```shell
nvim -u NORC
:set spellang=de spell
```

## Plugin TODOs

- <https://github.com/lewis6991/gitsigns.nvim> selection stage doesn't work

## cmp-git

| Git     | Trigger |
| ------- | ------- |
| Commits | :       |

| GitHub        | Trigger |
| --------------| ------- |
| Issues        | #       |
| Mentions      | @       |
| Pull Requests | #       |

| GitLab         | Trigger |
| -------------- | ------- |
| Issues         | #       |
| Mentions       | @       |
| Merge Requests | !       |

## Keybindings

### CMP/ luasnip

- `<c-space>`: toggle/ confirm cmp sepection
- `<tab>`: confirm cmp selection/ jump to next luasnip position
- `<s-tab>`: jump to last luasnip position
- `<cr>`: expand luasnip/ confirm cmp selection
- `<s-cr>`: confirm cmp selection (with replacing)
- `<c-n>`: select next cmp item
- `<c-p>`: select previsions cmp item
- `<c-q>`: abort cmp
- `<c-u>`: scroll the docs ups by 4 lines
- `<c-d>`: scroll the docs down by 4 lines

### Git

#### Worktrees

- `<leader>twc`: create git worktree in telescope
- `<leader>tws`: switch git worktree in telescope
  - `<Enter`>: switches
  - `<c-d>`: deletes
  - `<c-f>`: toggles forcing of the next deletion
