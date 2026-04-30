#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

LOGFILE="${LOGFILE:-/tmp/kali-setup.log}"

ok()   { echo -e "${GREEN}[✓]${NC} $1"; echo "[OK]   $1" >> "$LOGFILE"; }
skip() { echo -e "${BLUE}[●]${NC} $1";  echo "[SKIP] $1" >> "$LOGFILE"; }
err()  { echo -e "${RED}[✗]${NC} $1";   echo "[FAIL] $1" >> "$LOGFILE"; }
log()  { echo -e "${YELLOW}[*]${NC} $1"; echo "[INFO] $1" >> "$LOGFILE"; }
warn() { log "$1"; }
