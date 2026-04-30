#!/usr/bin/env bash
log "================================================================"
log " MODULE 03 — Extra Applications"
log "================================================================"

# ----------------------------------------------------------------
# Brave Browser
# ----------------------------------------------------------------
log "Verifying Brave Browser..."
if command -v brave-browser &>/dev/null; then
  skip "Brave already installed"
  track "Brave Browser" "SKIP"
else
  log "Installing Brave Browser..."
  if curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
       | gpg --dearmor -o /usr/share/keyrings/brave-browser-archive-keyring.gpg && \
     echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
       | tee /etc/apt/sources.list.d/brave-browser.list && \
     apt update && apt install -y brave-browser; then
    ok "Brave Browser installed"
    track "Brave Browser" "OK"
  else
    err "Brave Browser installation failed"
    track "Brave Browser" "FAIL"
  fi
fi

# ----------------------------------------------------------------
# Visual Studio Code
# ----------------------------------------------------------------
log "Verifying Visual Studio Code..."
if command -v code &>/dev/null; then
  skip "VSCode already installed"
  track "Visual Studio Code" "SKIP"
else
  log "Installing VSCode..."
  if curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
       | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg && \
     echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
       | tee /etc/apt/sources.list.d/vscode.list && \
     apt update && apt install -y code; then
    ok "VSCode installed"
    track "Visual Studio Code" "OK"
  else
    err "VSCode installation failed"
    track "Visual Studio Code" "FAIL"
  fi
fi

# ----------------------------------------------------------------
# Obsidian
# ----------------------------------------------------------------
log "Verifying Obsidian..."
if command -v obsidian &>/dev/null; then
  skip "Obsidian already installed"
  track "Obsidian" "SKIP"
else
  log "Installing Obsidian..."
  OBSIDIAN_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
    | grep "browser_download_url.*amd64\.deb" \
    | cut -d '"' -f 4 | head -1)
  if [[ -n "$OBSIDIAN_URL" ]] && \
     curl -fsSL "$OBSIDIAN_URL" -o /tmp/obsidian.deb && \
     apt install -y /tmp/obsidian.deb; then
    rm -f /tmp/obsidian.deb
    ok "Obsidian installed"
    track "Obsidian" "OK"
  else
    err "Obsidian installation failed"
    track "Obsidian" "FAIL"
  fi
fi
