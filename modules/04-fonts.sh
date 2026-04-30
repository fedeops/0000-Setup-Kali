#!/usr/bin/env bash
log "================================================================"
log " MODULE 04 — Nerd Fonts (JetBrainsMono)"
log "================================================================"

FONT_DIR="$REAL_HOME/.local/share/fonts"

if fc-list | grep -qi "JetBrainsMono"; then
  skip "JetBrainsMono Nerd Font already installed"
  track "Nerd Fonts (JetBrainsMono)" "SKIP"
else
  log "Installing JetBrainsMono Nerd Font..."
  sudo -u "$REAL_USER" mkdir -p "$FONT_DIR"
  if curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip \
       -o /tmp/NerdFonts.zip && \
     sudo -u "$REAL_USER" unzip -o /tmp/NerdFonts.zip -d "$FONT_DIR" && \
     fc-cache -fv "$FONT_DIR"; then
    rm -f /tmp/NerdFonts.zip
    ok "Nerd Fonts installed"
    track "Nerd Fonts (JetBrainsMono)" "OK"
  else
    err "Nerd Fonts installation failed"
    track "Nerd Fonts (JetBrainsMono)" "FAIL"
  fi
fi
