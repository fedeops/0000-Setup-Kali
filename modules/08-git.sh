#!/usr/bin/env bash
log "================================================================"
log " MODULE 08 — Git Configuration"
log "================================================================"

if git config --global user.name &>/dev/null; then
  skip "Git already configured"
  track "Git configuration" "SKIP"
else
  git config --global user.name "Federico"
  git config --global user.email "federico@localhost"
  git config --global core.editor "code --wait"
  git config --global alias.st "status"
  git config --global alias.co "checkout"
  git config --global alias.br "branch"
  git config --global alias.lg "log --oneline --graph --all"
  git config --global alias.last "log -1 HEAD"
  git config --global alias.unstage "reset HEAD --"
  git config --global push.default simple
  ok "Git configured"
  track "Git configuration" "OK"
fi

# Copy .gitconfig dotfile (always overwrites to keep aliases in sync)
if [[ -f "$SCRIPT_DIR/dotfiles/.gitconfig" ]]; then
  cp "$SCRIPT_DIR/dotfiles/.gitconfig" "$REAL_HOME/.gitconfig"
  chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.gitconfig"
fi
