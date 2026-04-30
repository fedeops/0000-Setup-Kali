#!/usr/bin/env bash
log "================================================================"
log " MODULE 12 — tmux Configuration"
log "================================================================"

# tmux is installed via 02-packages.sh; verify here just in case
if ! command -v tmux &>/dev/null; then
  log "tmux not found, installing..."
  apt install -y tmux 2>/dev/null
fi

if [[ -f "$REAL_HOME/.tmux.conf" ]]; then
  skip "tmux config already present"
  track "tmux configuration" "SKIP"
else
  if cp "$SCRIPT_DIR/dotfiles/.tmux.conf" "$REAL_HOME/.tmux.conf" && \
     chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.tmux.conf"; then
    ok "tmux config deployed"
    track "tmux configuration" "OK"
  else
    err "tmux config deploy failed"
    track "tmux configuration" "FAIL"
  fi
fi
