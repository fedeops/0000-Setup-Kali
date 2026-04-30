#!/usr/bin/env bash
log "================================================================"
log " MODULE 10 — Pivoting Tools (Chisel + Ligolo-ng)"
log "================================================================"

# ----------------------------------------------------------------
# Chisel
# ----------------------------------------------------------------
CHISEL_PATH="/usr/local/bin/chisel"
log "Verifying Chisel..."

if [[ -f "$CHISEL_PATH" ]]; then
  skip "Chisel already installed"
  track "Chisel" "SKIP"
else
  log "Downloading Chisel..."
  CHISEL_URL=$(curl -s https://api.github.com/repos/jpillora/chisel/releases/latest \
    | grep "browser_download_url.*linux_amd64\.gz" \
    | cut -d '"' -f 4 | head -1)

  if [[ -n "$CHISEL_URL" ]] && \
     curl -fsSL "$CHISEL_URL" -o /tmp/chisel.gz && \
     gunzip /tmp/chisel.gz && \
     mv /tmp/chisel "$CHISEL_PATH" && \
     chmod +x "$CHISEL_PATH"; then
    ok "Chisel installed at $CHISEL_PATH"
    track "Chisel" "OK"
  else
    err "Chisel installation failed"
    track "Chisel" "FAIL"
  fi
fi

# ----------------------------------------------------------------
# Ligolo-ng (agent + proxy)
# ----------------------------------------------------------------
_install_ligolo_bin() {
  local label="$1"
  local dest="$2"

  if [[ -f "$dest" ]]; then
    skip "Ligolo-ng $label already installed"
    track "Ligolo-ng $label" "SKIP"
    return
  fi

  log "Downloading Ligolo-ng $label..."
  local url
  url=$(curl -s https://api.github.com/repos/nicocha30/ligolo-ng/releases/latest \
    | grep "browser_download_url" \
    | grep -i "$label" \
    | grep -i "linux" \
    | grep -iE "64bit|amd64|x86_64" \
    | grep "\.tar\.gz" \
    | head -1 | cut -d '"' -f 4)

  if [[ -z "$url" ]]; then
    err "Ligolo-ng $label release URL not found"
    track "Ligolo-ng $label" "FAIL"
    return
  fi

  local tmpdir="/tmp/ligolo-${label}"
  mkdir -p "$tmpdir"

  if curl -fsSL "$url" -o "${tmpdir}.tar.gz" && \
     tar -xzf "${tmpdir}.tar.gz" -C "$tmpdir"; then
    local bin
    bin=$(find "$tmpdir" -type f -executable | head -1)
    if [[ -n "$bin" ]] && mv "$bin" "$dest" && chmod +x "$dest"; then
      ok "Ligolo-ng $label installed at $dest"
      track "Ligolo-ng $label" "OK"
    else
      err "Ligolo-ng $label binary not found after extraction"
      track "Ligolo-ng $label" "FAIL"
    fi
  else
    err "Ligolo-ng $label download/extraction failed"
    track "Ligolo-ng $label" "FAIL"
  fi

  rm -rf "$tmpdir" "${tmpdir}.tar.gz"
}

log "Verifying Ligolo-ng agent..."
_install_ligolo_bin "agent" "/usr/local/bin/ligolo-agent"

log "Verifying Ligolo-ng proxy..."
_install_ligolo_bin "proxy" "/usr/local/bin/ligolo-proxy"
