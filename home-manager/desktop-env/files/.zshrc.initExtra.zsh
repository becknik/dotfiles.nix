bindkey -v
# Enables Ctrl + Del to delete a full word
bindkey '^H' backward-kill-word

# VI-style Navigation in Menu Completion
zstyle ':completion:*' menu select
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
# Enable Bash-like Feature I can't explain...
unsetopt flow_control
bindkey '^e' push-line
# Auto-Complete a word with Ctrl + Space
# bindkey '^ ' forward-word
bindkey '^ ' autosuggest-accept
# Partial history matches using arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# you-should-use
YSU_MESSAGE_POSITION="after"
# too annoying
#YSU_HARDCORE=1 # refuses to execute the command aliases exist of

# Pure Prompt
autoload -U promptinit; promptinit
prompt pure
## Setup
#PROMPT='%F{white}%* '$PROMPT # TODO add timestamp to pure prompt
PURE_GIT_UNTRACKED_DIRTY=254
zstyle :prompt:pure:git:stash show yes

# prepend datetime to pure prompt
# https://github.com/sindresorhus/pure/issues/667
eval "original_$(declare -f prompt_pure_preprompt_render)"
prompt_pure_preprompt_render() {
  local prompt_pure_date_color='250'
  local prompt_pure_date_format="[%H:%M:%S]"
  local prompt_pure_date=$(date "+$prompt_pure_date_format")
  original_prompt_pure_preprompt_render
  PROMPT="%F{$prompt_pure_date_color}${prompt_pure_date}%f $PROMPT"
  }

# fzf-git.sh
bindkey -r "^G" # unbinds `bindkey -r "^G"` to make place for fzf-git
_fzf_git_fzf() {
  # fzf-tmux -p80%,60% -- \
  fzf --multi --cycle --reverse --height='80%' --border --border-label-pos=2 \
    --color='header:italic,label:blue' \
    --preview-window='right,50%' \
    --bind='ctrl-/:change-preview-window(down,60%,border-top|hidden|)' "$@"
}

# yazi Shortcut
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Custom Functions

rerun-previous-command-if-empty() {
  if [[ -z $BUFFER ]]; then
    zle up-history
    zle accept-line
  else
    zle .accept-line
  fi
}
zle -N accept-line rerun-previous-command-if-empty

unalias gwip
