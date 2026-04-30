#!/usr/bin/env bash
log "================================================================"
log " MODULE 05 — Shell (Zsh + Oh My Zsh + Powerlevel10k + dotfiles)"
log "================================================================"

# ----------------------------------------------------------------
# Oh My Zsh
# ----------------------------------------------------------------
log "Verifying Oh My Zsh..."
if [[ -d "$REAL_HOME/.oh-my-zsh" ]]; then
  skip "Oh My Zsh already installed"
  track "Oh My Zsh" "SKIP"
else
  log "Installing Oh My Zsh..."
  if sudo -u "$REAL_USER" sh -c \
       "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
       "" --unattended; then
    ok "Oh My Zsh installed"
    track "Oh My Zsh" "OK"
  else
    err "Oh My Zsh installation failed"
    track "Oh My Zsh" "FAIL"
  fi
fi

# ----------------------------------------------------------------
# Powerlevel10k
# ----------------------------------------------------------------
P10K_DIR="$REAL_HOME/.oh-my-zsh/custom/themes/powerlevel10k"
log "Verifying Powerlevel10k..."
if [[ -d "$P10K_DIR" ]]; then
  skip "Powerlevel10k already installed"
  track "Powerlevel10k" "SKIP"
else
  log "Installing Powerlevel10k..."
  if sudo -u "$REAL_USER" git clone --depth=1 \
       https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"; then
    ok "Powerlevel10k installed"
    track "Powerlevel10k" "OK"
  else
    err "Powerlevel10k installation failed"
    track "Powerlevel10k" "FAIL"
  fi
fi

# ----------------------------------------------------------------
# Dotfiles: .zshrc
# ----------------------------------------------------------------
log "Deploying .zshrc..."
[[ -f "$REAL_HOME/.zshrc" ]] && \
  cp "$REAL_HOME/.zshrc" "$REAL_HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)"

if cp "$SCRIPT_DIR/dotfiles/.zshrc" "$REAL_HOME/.zshrc" && \
   chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.zshrc"; then
  ok ".zshrc deployed"
  track "Dotfile .zshrc" "OK"
else
  err ".zshrc deploy failed"
  track "Dotfile .zshrc" "FAIL"
fi

# ----------------------------------------------------------------
# Dotfiles: .p10k.zsh
# ----------------------------------------------------------------
log "Deploying .p10k.zsh..."
if cp "$SCRIPT_DIR/dotfiles/.p10k.zsh" "$REAL_HOME/.p10k.zsh" && \
   chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.p10k.zsh"; then
  ok ".p10k.zsh deployed"
  track "Dotfile .p10k.zsh" "OK"
else
  err ".p10k.zsh deploy failed"
  track "Dotfile .p10k.zsh" "FAIL"
fi

# ----------------------------------------------------------------
# Set Zsh as default shell
# ----------------------------------------------------------------
log "Verifying default shell..."
if [[ "$(getent passwd "$REAL_USER" | cut -d: -f7)" == "$(which zsh)" ]]; then
  skip "Zsh already default shell"
  track "Default shell (zsh)" "SKIP"
else
  if chsh -s "$(which zsh)" "$REAL_USER"; then
    ok "Zsh set as default shell"
    track "Default shell (zsh)" "OK"
  else
    err "Failed to set Zsh as default shell"
    track "Default shell (zsh)" "FAIL"
  fi
fi
