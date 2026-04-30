# Kali Linux Pentest Environment Setup

Automated provisioning for Kali Linux penetration testing environments. Modular, idempotent, safe to re-run.

## Quick Start

```bash
git clone https://github.com/fedeops/0000-Kali_setup.git
cd kali-setup
sudo ./setup.sh
```

## Options

```bash
sudo ./setup.sh              # Default
sudo ./setup.sh --lightdm    # Use LightDM instead of gdm3
```

## What Gets Installed

| Module | Contents |
|--------|----------|
| 00-preflight | OS check (Kali only), internet connectivity |
| 01-system | apt full upgrade + broken repo auto-disable |
| 02-packages | nmap, gobuster, ffuf, nikto, sqlmap, hydra, john, hashcat, wireshark, metasploit, impacket, tmux, ... |
| 03-applications | Brave Browser, VSCode, Obsidian |
| 04-fonts | JetBrainsMono Nerd Font |
| 05-shell | Zsh + Oh My Zsh + Powerlevel10k + dotfiles |
| 06-tools | LinPeas |
| 07-wordlists | rockyou.txt decompression + SecLists |
| 08-git | Git global config + .gitconfig |
| 09-ssh | ed25519 SSH key generation |
| 10-pivoting | Chisel + Ligolo-ng (agent + proxy) |
| 11-git-repos | Clone repos from `config/git-repos.txt` |
| 12-tmux | .tmux.conf deployment |
| 13-display | gdm3 / lightdm setup |

## Log Output

```
[✓] Package installed        ← green  = completed now
[●] Git already installed    ← blue   = already present (skip)
[✗] Obsidian failed          ← red    = error
[*] Downloading LinPeas...   ← yellow = info
```

Each run saves a timestamped log to `~/kali-setup-YYYYMMDD-HHMMSS.log`.

## Customizing Git Repos

Edit `config/git-repos.txt`:

```
### My Custom Tool
https://github.com/user/tool.git
~/tools/tool
```

Re-run `sudo ./setup.sh` to clone new entries (existing dirs are skipped).

## Project Structure

```
kali-setup/
├── setup.sh               # Master orchestrator
├── modules/               # 13 independent modules
├── dotfiles/              # .zshrc .p10k.zsh .tmux.conf .gitconfig
├── config/
│   └── git-repos.txt      # Repos to clone
└── core/
    ├── colors.sh
    ├── logger.sh
    └── summary.sh

```

