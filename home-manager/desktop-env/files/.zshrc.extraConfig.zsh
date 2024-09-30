bgnotify_bell=false;
bgnotify_threshold=120;

function nixos-upgrade-monitor {
  if [ $# -eq 0 ]; then
    echo "No arguments provided. Please provide a log file path."
    return 1
  fi

  local log_file_path="$1"
  tail -n +1 -f "$log_file_path" |& nom
}

# ohmyzsh Git Plugin Function Overrides/ Extension
function gwip() {
  git add -A
  git rm $(git ls-files --deleted) 2> /dev/null
  local message="--wip-- [skip ci]"
  if [ -n "$1" ]; then
    message="$message "$1""
  fi
  git commit --no-verify --no-gpg-sign -m "$message"
}
# only staged changes are committed
function gwips() {
  local message="--wip-- [skip ci]"
  if [ -n "$1" ]; then
    message="$message "$1""
  fi
  git commit --no-verify --no-gpg-sign -m "$message"
}

# Fix for `cp: cannot create regular file '/home/jnnk/.cache/oh-my-zsh/completions/_docker': Permission denied`
chmod u+w $HOME/.cache/oh-my-zsh/completions/_docker
