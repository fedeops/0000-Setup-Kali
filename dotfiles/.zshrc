# ================================================================
# POWERLEVEL10K INSTANT PROMPT
# ================================================================
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
fastfetch

# ================================================================
# OH MY ZSH
# ================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git sudo)
source $ZSH/oh-my-zsh.sh

# ================================================================
# PLUGINS
# ================================================================
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ================================================================
# HISTORY
# ================================================================
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# ================================================================
# ENVIRONMENT VARIABLES & WORDLIST PATHS
# ================================================================
export WL_ROCKYOU="/usr/share/wordlists/rockyou.txt"
export WL_COMMON="/usr/share/wordlists/dirb/common.txt"
export WL_MEDIUM="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
export WL_SECLISTS="/usr/share/wordlists/seclists"

# Usage examples:
# gobuster dir -u http://target.com -w $WL_ROCKYOU
# ffuf -u http://target.com/FUZZ -w $WL_MEDIUM
# hashcat -m 0 -a 0 hashes.txt $WL_ROCKYOU

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/bin

# ================================================================
# ALIASES
# ================================================================
alias ll='ls -lah --color=auto'
alias clear='clear && fastfetch'
alias cls='clear'
alias grep='grep --color=auto'

alias update='sudo apt update && sudo apt full-upgrade -y'

alias ports='ss -tulnp'
alias openports='nmap -sV -sT -p- --min-rate 1000 localhost'

alias tools='cd ~/tools'
alias pyserver='python3 -m http.server 8000'

alias chisel-server='chisel server -p 8000 --reverse'

alias brave='brave-browser'

# ================================================================
# CLIPBOARD UTILITIES
# ================================================================
copy() {
  if ! command -v xclip >/dev/null 2>&1; then
    echo "xclip is not installed"
    return 1
  fi

  if [[ $# -eq 0 ]]; then
    echo "Usage: copy <command> [args...]"
    return 1
  fi

  "$@" | tee >(xclip -selection clipboard)
  return ${pipestatus[1]}
}

run() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: run <command> [args...]"
    return 1
  fi

  "$@" | tee /tmp/last_output
  return ${pipestatus[1]}
}

copylast() {
  if ! command -v xclip >/dev/null 2>&1; then
    echo "xclip is not installed"
    return 1
  fi

  if [[ ! -s /tmp/last_output ]]; then
    echo "No previous output found. Use: run <command>"
    return 1
  fi

  xclip -selection clipboard < /tmp/last_output
  echo "Last command output copied to clipboard"
}

# ================================================================
# POWERLEVEL10K CONFIG
# ================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
