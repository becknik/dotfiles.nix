{ ... }:

{
  imports = [
    ./neogit.nix
    ./gitsigns
    ./diffview.nix

    ./advanced-git-search.nix
    ./octo.nix

    ./keymaps.nix
    # ./git-worktree.nix this plugin seems to be broken...
  ];
}
