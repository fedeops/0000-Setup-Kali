#!/usr/bin/env bash
log "================================================================"
log " MODULE 09 — SSH Key Generation"
log "================================================================"

SSH_KEY="$REAL_HOME/.ssh/id_ed25519"

if [[ -f "$SSH_KEY" ]]; then
  skip "SSH key already exists: $SSH_KEY"
  track "SSH key (ed25519)" "SKIP"
else
  sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/.ssh"
  chmod 700 "$REAL_HOME/.ssh"

  if sudo -u "$REAL_USER" ssh-keygen -t ed25519 -C "pentest-vm" -f "$SSH_KEY" -N ""; then
    ok "SSH key generated: $SSH_KEY"
    track "SSH key (ed25519)" "OK"

    echo ""
    echo "================================================"
    echo " SSH PUBLIC KEY (add to GitHub / GitLab):"
    echo "================================================"
    cat "${SSH_KEY}.pub"
    echo "================================================"
    echo ""
  else
    err "SSH key generation failed"
    track "SSH key (ed25519)" "FAIL"
  fi
fi
