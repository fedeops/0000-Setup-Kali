#!/usr/bin/env bash
log "================================================================"
log " MODULE 02 — Package Installation"
log "================================================================"

PACKAGES=(
  git curl wget zsh bat fastfetch unzip fontconfig
  zsh-autosuggestions zsh-syntax-highlighting
  nmap gobuster ffuf nikto enum4linux httrack
  sqlmap hydra
  john hashcat
  wireshark tcpdump burpsuite
  netcat-traditional smbclient
  telegram-desktop
  tmux
  xclip
)

pkg_check() { dpkg -s "$1" &>/dev/null; }
pkg_install() { apt install -y "$1" 2>/dev/null; }

for pkg in "${PACKAGES[@]}"; do
  if pkg_check "$pkg"; then
    skip "$pkg already installed"
    track "Package: $pkg" "SKIP"
  else
    log "Installing $pkg..."
    if pkg_install "$pkg"; then
      ok "$pkg installed"
      track "Package: $pkg" "OK"
    else
      err "$pkg installation failed"
      track "Package: $pkg" "FAIL"
    fi
  fi
done

# batcat → bat symlink
if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
  if ln -sf "$(which batcat)" /usr/local/bin/bat; then
    ok "bat symlink created"
    track "Symlink bat → batcat" "OK"
  else
    err "bat symlink failed"
    track "Symlink bat → batcat" "FAIL"
  fi
else
  skip "bat symlink already present"
  track "Symlink bat → batcat" "SKIP"
fi

# metasploit-framework
log "Verifying Metasploit Framework..."
if dpkg -s metasploit-framework &>/dev/null; then
  skip "metasploit-framework already installed"
  track "Metasploit Framework" "SKIP"
else
  if apt install -y metasploit-framework; then
    ok "metasploit-framework installed"
    track "Metasploit Framework" "OK"
  else
    err "metasploit-framework installation failed"
    track "Metasploit Framework" "FAIL"
  fi
fi

# impacket via pip3
log "Verifying impacket..."
if python3 -c "import impacket" &>/dev/null; then
  skip "impacket already installed"
  track "impacket" "SKIP"
else
  if pip3 install impacket --break-system-packages 2>/dev/null; then
    ok "impacket installed via pip3"
    track "impacket" "OK"
  else
    if apt install -y python3-impacket 2>/dev/null; then
      ok "impacket installed via apt"
      track "impacket" "OK"
    else
      err "impacket installation failed"
      track "impacket" "FAIL"
    fi
  fi
fi
