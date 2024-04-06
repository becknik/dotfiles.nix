bgnotify_bell=false;
bgnotify_threshold=120;

# ohmyzsh Git Plugin Extension Function
function gwipmsg() {
  git add -A
  git rm $(git ls-files --deleted) 2> /dev/null
  local message="--wip-- [skip ci]"
  if [ -n "$1" ]; then
    message="$message "$1""
  fi
  git commit --no-verify --no-gpg-sign -m "$message"
}

# Fix for `cp: cannot create regular file '/home/jnnk/.cache/oh-my-zsh/completions/_docker': Permission denied`
chmod u+w $HOME/.cache/oh-my-zsh/completions/_docker