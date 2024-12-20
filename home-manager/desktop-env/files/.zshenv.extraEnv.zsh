# Esc key in vi mode is 0.4s by default, this sets it to 0.05s
export KEYTIMEOUT=5

# fzf vim binding with ctrl/alt
export FZF_DEFAULT_OPTS="--bind 'ctrl-j:down,ctrl-k:up,alt-j:preview-down,alt-k:preview-up'"

# https://github.com/wfxr/forgit/tree/master?tab=readme-ov-file#-keybinds
export FORGIT_FZF_DEFAULT_OPTS="--exact --border --cycle --reverse --height='80%'"

# gds with staged would be nice
export FORGIT_COPY_CMD=wl-copy
export forgit_add=fga
export forgit_blame=fgbl
export forgit_branch_delete=fgbd #gcb
export forgit_checkout_branch=fgcob
alias -- 'fgsw'='fgcob'
export forgit_checkout_commit=fgco #gcf
export forgit_checkout_file=fgcof #gct
export forgit_checkout_tag=fgcot
export forgit_cherry_pick=fgcp
export forgit_clean=fgclean
export forgit_diff=fgd
export forgit_fixup=fgfu
export forgit_ignore=gi
export forgit_log=fglo #grb
export forgit_rebase=fgrbi #grh TODO How to disable forgit aliases?
export forgit_reset_head=fgrh
export forgit_revert_commit=fgrev #gsp
export forgit_stash_push=fgsta #gss
export forgit_stash_show=fgstl

# Further are declared as aliasforgit_log=glo

if [ -f ~/.zshenv.local ]; then
    source ~/.zshenv.local
fi