#!/usr/bin/env bash
log "================================================================"
log " MODULE 07 — Wordlists"
log "================================================================"

# ----------------------------------------------------------------
# rockyou.txt
# ----------------------------------------------------------------
ROCKYOU_GZ="/usr/share/wordlists/rockyou.txt.gz"
ROCKYOU_TXT="/usr/share/wordlists/rockyou.txt"

log "Verifying rockyou.txt..."
if [[ -f "$ROCKYOU_TXT" ]]; then
  skip "rockyou.txt already decompressed"
  track "Wordlist rockyou.txt" "SKIP"
elif [[ -f "$ROCKYOU_GZ" ]]; then
  if gunzip "$ROCKYOU_GZ"; then
    ok "rockyou.txt decompressed"
    track "Wordlist rockyou.txt" "OK"
  else
    err "rockyou.txt decompression failed"
    track "Wordlist rockyou.txt" "FAIL"
  fi
else
  err "rockyou.txt not found at $ROCKYOU_GZ"
  track "Wordlist rockyou.txt" "FAIL"
fi

# ----------------------------------------------------------------
# SecLists
# ----------------------------------------------------------------
SECLISTS_DIR="/usr/share/wordlists/seclists"
log "Verifying SecLists..."

if [[ -d "$SECLISTS_DIR" ]]; then
  skip "SecLists already installed"
  track "SecLists" "SKIP"
else
  log "Cloning SecLists (this may take a while)..."
  if git clone --depth 1 https://github.com/danielmiessler/SecLists.git "$SECLISTS_DIR"; then
    ok "SecLists installed at $SECLISTS_DIR"
    track "SecLists" "OK"
  else
    err "SecLists clone failed"
    track "SecLists" "FAIL"
  fi
fi
