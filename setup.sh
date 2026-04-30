#!/usr/bin/env bash
# ================================================================
# Kali Linux Penetration Testing Environment Setup
# Usage: sudo ./setup.sh [--lightdm]
# ================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/core/colors.sh"
source "$SCRIPT_DIR/core/logger.sh"

# ----------------------------------------------------------------
# Root check
# ----------------------------------------------------------------
[[ $EUID -eq 0 ]] || { echo "Run as root: sudo ./setup.sh"; exit 1; }

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="/home/$REAL_USER"

# ----------------------------------------------------------------
# Argument parsing
# ----------------------------------------------------------------
USE_LIGHTDM=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --lightdm)    USE_LIGHTDM=true; shift ;;
    -h|--help)
      echo "Usage: sudo ./setup.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --lightdm    Use LightDM instead of gdm3"
      echo "  -h, --help   Show this help"
      exit 0
      ;;
    *)
      echo "Unknown option: $1 — use -h for help"
      exit 1
      ;;
  esac
done

export REAL_USER REAL_HOME USE_LIGHTDM SCRIPT_DIR

# ----------------------------------------------------------------
# Summary tracking (shared arrays — sourced modules access directly)
# ----------------------------------------------------------------
declare -a SUMMARY_LABELS=()
declare -a SUMMARY_STATUS=()

track() {
  SUMMARY_LABELS+=("$1")
  SUMMARY_STATUS+=("$2")
}

# ----------------------------------------------------------------
# Log file
# ----------------------------------------------------------------
LOGFILE="$REAL_HOME/kali-setup-$(date +%Y%m%d-%H%M%S).log"
export LOGFILE

log "Kali Setup — user: $REAL_USER"
log "Log file: $LOGFILE"
echo ""

# ================================================================
# MODULES
# ================================================================
run_module() {
  local module="$1"
  if [[ -f "$SCRIPT_DIR/modules/$module" ]]; then
    source "$SCRIPT_DIR/modules/$module"
  else
    err "Module not found: $module"
  fi
}

run_module "00-preflight.sh"
run_module "01-system.sh"
run_module "02-packages.sh"
run_module "03-applications.sh"
run_module "04-fonts.sh"
run_module "05-shell.sh"
run_module "06-tools.sh"
run_module "07-wordlists.sh"
run_module "08-git.sh"
run_module "09-ssh.sh"
run_module "10-pivoting.sh"
run_module "11-git-repos.sh"
run_module "12-tmux.sh"
run_module "13-display.sh"

# ================================================================
# SUMMARY
# ================================================================
source "$SCRIPT_DIR/core/summary.sh"
show_summary

echo ""
if [[ ${COUNT_FAIL:-0} -eq 0 ]]; then
  ok "Setup completed successfully!"
else
  err "Some steps failed — check log: $LOGFILE"
fi

echo ""
log "Reboot the system to apply all changes."
echo ""
