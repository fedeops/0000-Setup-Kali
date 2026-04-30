#!/usr/bin/env bash
log "================================================================"
log " MODULE 11 — Git Repositories"
log "================================================================"

REPO_FILE="$SCRIPT_DIR/config/git-repos.txt"

if [[ ! -f "$REPO_FILE" ]]; then
  log "No git-repos.txt found, skipping"
  return 0
fi

REPO_NAME=""
REPO_URL=""

while IFS= read -r line; do
  # Skip blank lines and single-# comments
  [[ -z "$line" || "$line" =~ ^#[^#] ]] && continue

  # ### Title line
  if [[ "$line" =~ ^###[[:space:]](.+)$ ]]; then
    REPO_NAME="${BASH_REMATCH[1]}"
    REPO_URL=""
    continue
  fi

  # URL (first non-comment line after title)
  if [[ -z "$REPO_URL" && "$line" =~ ^https?:// ]]; then
    REPO_URL="$line"
    continue
  fi

  # Destination (line after URL)
  if [[ -n "$REPO_URL" && -n "$line" ]]; then
    DEST="${line/#\~/$REAL_HOME}"

    if [[ -d "$DEST" ]]; then
      skip "$REPO_NAME already cloned"
      track "Git repo: $REPO_NAME" "SKIP"
    else
      log "Cloning $REPO_NAME..."
      if sudo -u "$REAL_USER" git clone --depth 1 "$REPO_URL" "$DEST"; then
        ok "$REPO_NAME cloned to $DEST"
        track "Git repo: $REPO_NAME" "OK"
      else
        err "$REPO_NAME clone failed"
        track "Git repo: $REPO_NAME" "FAIL"
      fi
    fi

    REPO_NAME=""
    REPO_URL=""
  fi

done < "$REPO_FILE"
