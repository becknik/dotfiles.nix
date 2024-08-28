cd $FLAKE

if [[ -z "${FLAKE}" ]]; then
  echo "Environment variable \$FLAKE isn't set"
  exit 1
elif [[ -z "${FLAKE_NIXOS_HOST}" ]]; then
  echo "Environment variable \$FLAKE_NIXOS_HOST isn't set"
  exit 1
fi

echo "Fetching git..."
git fetch --verbose
local_commit_date=$(git show -s --format=%ci main)
remote_commit_date=$(git show -s --format=%ci main@{upstream})

if [[ "$local_commit_date" < "$remote_commit_date" ]]; then
  echo "Detected changes in flake main@{upstream} from $remote_commit_date"
  echo "Trying to pull & checkout..."

  git pull --rebase --autostash
  git switch main
  nixos-rebuild --flake "$FLAKE#$FLAKE_NIXOS_HOST" switch
else
  echo "No changes found in flake main@{upstream}"
fi
