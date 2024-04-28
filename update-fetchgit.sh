fetchsources=("overlays/modifications.nix" "nixvim/plugins/luasnip.nix")

for subdir in "${fetchsources[@]}"; do
  update-nix-fetchgit "$DEVENV_ROOT"/"$subdir"
done
