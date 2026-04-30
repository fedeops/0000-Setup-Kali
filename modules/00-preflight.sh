#!/usr/bin/env bash
log "================================================================"
log " MODULE 00 — Preflight Checks"
log "================================================================"

# OS check
log "Checking OS..."
if grep -qi "^ID=kali\|^NAME=.*[Kk]ali" /etc/os-release 2>/dev/null; then
  ok "OS: Kali Linux"
  track "OS check" "OK"
else
  DETECTED=$(grep "PRETTY_NAME" /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
  err "Expected Kali Linux, detected: ${DETECTED:-Unknown}"
  track "OS check" "FAIL"
  exit 1
fi

# Internet check
log "Checking internet connectivity..."
if curl -fsSL --max-time 8 https://kali.org -o /dev/null 2>/dev/null; then
  ok "Internet connectivity OK"
  track "Internet check" "OK"
else
  err "No internet connectivity — check your connection"
  track "Internet check" "FAIL"
  exit 1
fi
