#!/usr/bin/env bash
log "================================================================"
log " MODULE 13 — Display Manager"
log "================================================================"

# Resolve target DM
if [[ "$USE_LIGHTDM" == true ]]; then
  TARGET_DM="lightdm"
else
  TARGET_DM="gdm3"
fi

log "Target display manager: $TARGET_DM"

dm_installed() { dpkg -s "$1" &>/dev/null; }
dm_install()   { apt install -y "$1"; }

if dm_installed "$TARGET_DM"; then
  skip "$TARGET_DM already installed"
  track "Display Manager ($TARGET_DM)" "SKIP"
else
  log "Installing $TARGET_DM..."
  if dm_install "$TARGET_DM"; then
    ok "$TARGET_DM installed"
    track "Display Manager ($TARGET_DM)" "OK"
  else
    err "$TARGET_DM installation failed"
    track "Display Manager ($TARGET_DM)" "FAIL"
  fi
fi

# Set as default
DM_PATH="/usr/sbin/$TARGET_DM"
log "Setting $TARGET_DM as default display manager..."

if echo "$DM_PATH" > /etc/X11/default-display-manager && \
   DEBIAN_FRONTEND=noninteractive dpkg-reconfigure "$TARGET_DM"; then
  ok "$TARGET_DM set as default"
  track "Display Manager default config" "OK"
else
  err "Failed to set $TARGET_DM as default"
  track "Display Manager default config" "FAIL"
fi
