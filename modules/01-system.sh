#!/usr/bin/env bash
log "================================================================"
log " MODULE 01 — System Update"
log "================================================================"

log "Running apt update..."
APT_OUT=$(apt update 2>&1)
printf '%s\n' "$APT_OUT"

# Detect and disable broken sources (e.g. 404 third-party repos)
APT_ERRORS=$(printf '%s\n' "$APT_OUT" | grep "^E:" || true)
if [[ -n "$APT_ERRORS" ]]; then
  warn "Broken APT sources detected — disabling:"
  while IFS= read -r errline; do
    warn "  $errline"
    domain=$(printf '%s\n' "$errline" | grep -oP 'https?://[^/ ]+' | head -1)
    [[ -z "$domain" ]] && continue
    for list_file in /etc/apt/sources.list.d/*.list; do
      [[ -f "$list_file" ]] || continue
      if grep -q "$domain" "$list_file" 2>/dev/null; then
        mv "$list_file" "${list_file%.list}.list.disabled"
        warn "  Disabled: $(basename "$list_file")"
      fi
    done
  done <<< "$APT_ERRORS"
  log "Re-running apt update after removing broken sources..."
  apt update
fi

if apt full-upgrade -y; then
  ok "System updated"
  track "System update & upgrade" "OK"
else
  err "System update failed"
  track "System update & upgrade" "FAIL"
fi
