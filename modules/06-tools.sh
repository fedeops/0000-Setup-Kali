#!/usr/bin/env bash
log "================================================================"
log " MODULE 06 — Tools (LinPeas)"
log "================================================================"

TOOLS_DIR="$REAL_HOME/tools"

if [[ ! -d "$TOOLS_DIR" ]]; then
  sudo -u "$REAL_USER" mkdir -p "$TOOLS_DIR"
  ok "Tools directory created: $TOOLS_DIR"
else
  skip "Tools directory already exists: $TOOLS_DIR"
fi

# ----------------------------------------------------------------
# LinPeas
# ----------------------------------------------------------------
LINPEAS_PATH="$TOOLS_DIR/linpeas.sh"
log "Verifying LinPeas..."

if [[ -f "$LINPEAS_PATH" ]]; then
  skip "LinPeas already present"
  track "LinPeas" "SKIP"
else
  log "Downloading LinPeas..."
  if sudo -u "$REAL_USER" curl -fsSL \
       "https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh" \
       -o "$LINPEAS_PATH" && chmod +x "$LINPEAS_PATH"; then
    ok "LinPeas downloaded to $TOOLS_DIR"
    track "LinPeas" "OK"
  else
    err "LinPeas download failed"
    track "LinPeas" "FAIL"
  fi
fi
