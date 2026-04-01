# Disabled: was auto-launching Fish
# if type "fish" > /dev/null; then
# 	fish --login
# fi

# User local binaries (fish functions live here)
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/hypnodroid/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# >>> conda initialize (LAZY) >>>
# Only load conda when first called - saves 300ms on startup
conda() {
  unfunction conda  # Remove this lazy-loader
  __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
      . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
      export PATH="/opt/miniconda3/bin:$PATH"
    fi
  fi
  unset __conda_setup
  conda "$@"  # Now run the actual command
}
# <<< conda initialize <<<

AWS_VAULT_BACKEND=file
AWS_VAULT_FILE_DIR=~/.aws-vault
export AWS_VAULT_BACKEND=file
export AWS_VAULT_FILE_DIR=~/.aws-vault
export AWS_VAULT_FILE_PASSPHRASE=""
eval "$(zoxide init zsh)"

# ============================================
# ZSH OPTIONS - The Good Stuff
# ============================================
setopt AUTO_CD              # Just type directory name to cd
setopt AUTO_PUSHD           # Push directory onto stack on cd
setopt PUSHD_IGNORE_DUPS    # No duplicates in dir stack
setopt PUSHD_SILENT         # Don't print stack after pushd/popd
setopt CORRECT              # Spell check commands
setopt CDABLE_VARS          # cd into named directories
setopt EXTENDED_GLOB        # Extended globbing (#, ~, ^)
setopt NO_CASE_GLOB         # Case insensitive globbing
setopt GLOB_DOTS            # Include dotfiles in globbing
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell

# ============================================
# History Configuration (Massive & Smart)
# ============================================
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY       # Save timestamp
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first
setopt HIST_IGNORE_ALL_DUPS   # Don't save duplicates
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching
setopt HIST_IGNORE_SPACE      # Don't save commands starting with space
setopt HIST_REDUCE_BLANKS     # Remove extra blanks
setopt HIST_VERIFY            # Show command before executing from history
setopt INC_APPEND_HISTORY     # Add commands as they're typed

# ============================================
# Completions (Tab-completion Magic)
# ============================================
# Hardcoded brew prefix (avoids slow subprocess)
FPATH="/opt/homebrew/share/zsh-completions:/opt/homebrew/share/zsh/site-functions:$FPATH"

# fnm (Fast Node Manager)
eval "$(fnm env --use-on-cd)"

# Only rebuild completions once per day
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -u
else
  compinit -C -u
fi

# Completion styling
zstyle ':completion:*' menu select                       # Menu selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colorful completions
zstyle ':completion:*' group-name ''                     # Group by category
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*' squeeze-slashes true              # /u/l/b -> /usr/local/bin
zstyle ':completion:*' use-cache on                      # Cache completions
zstyle ':completion:*' cache-path ~/.zsh/cache

# ============================================
# Fish-like Plugins
# ============================================
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestion styling (more subtle gray)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ============================================
# Keybindings (Emacs-style + extras)
# ============================================
bindkey -e                              # Emacs keybindings

# Make Ctrl+W stop at path separators (/, -, _, .)
# Default WORDCHARS: *?_-.[]~=/&;!#$%^(){}<>
WORDCHARS='*?[]~=&;!#$%^(){}<>'
bindkey '^[[A' history-search-backward  # Up arrow - search history
bindkey '^[[B' history-search-forward   # Down arrow - search history
bindkey '^[[C' forward-char             # Right arrow - accept suggestion
bindkey '^[[D' backward-char            # Left arrow
bindkey '^[[H' beginning-of-line        # Home
bindkey '^[[F' end-of-line              # End
bindkey '^[[3~' delete-char             # Delete
bindkey '^[[1;5C' forward-word          # Ctrl+Right - forward word
bindkey '^[[1;5D' backward-word         # Ctrl+Left - backward word
bindkey '^U' backward-kill-line         # Ctrl+U - kill line backward
bindkey '^K' kill-line                  # Ctrl+K - kill line forward
bindkey '^ ' autosuggest-accept         # Ctrl+Space - accept suggestion

# ============================================
# fzf - Fuzzy Finder (GAME CHANGER)
# ============================================
source <(fzf --zsh)  # Enable fzf keybindings: Ctrl+R (history), Ctrl+T (files), Alt+C (cd)

# fzf configuration
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border=rounded
  --info=inline
  --margin=1
  --padding=1
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Preview files with bat
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# ============================================
# thefuck - Auto-correct mistakes (lazy-loaded)
# ============================================
fuck() {
  unfunction fuck fk 2>/dev/null
  eval $(thefuck --alias)
  fuck "$@"
}
fk() { fuck "$@"; }

# ============================================
# Modern CLI Tools (available by their own names)
# ============================================
# eza, bat, fd, rg, dust, duf, btop are all installed
# Use them directly: eza, bat, fd, rg, dust, btop
# Standard commands (ls, cat, find, grep, du, top) work normally

alias ll='ls -la'
alias la='ls -a'

# ============================================
# Git Aliases (Inspired by popular dotfiles)
# ============================================
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gp='git push'
alias gpu='git push -u origin HEAD'
alias gpl='git pull'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git stash'
alias gstp='git stash pop'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gm='git merge'
alias gcp='git cherry-pick'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias gclean='git clean -fd'
alias gwip='git add -A && git commit -m "WIP"'

# lazygit - Terminal UI for git
alias lg='lazygit'

# ============================================
# Useful Aliases & Functions
# ============================================
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Standard rm/cp/mv (no interactive prompts - use caution)

# Quick edits
alias zshrc='${EDITOR:-code} ~/.zshrc'
alias reload='source ~/.zshrc && echo "Reloaded!"'

# Network
alias myip='curl -s ifconfig.me'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P -n | grep LISTEN'

# Development
alias serve='python3 -m http.server'
alias json='jq .'
alias yaml='yq .'

# System
alias path='echo $PATH | tr ":" "\n"'
alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# Markdown viewer
alias md='glow'

# HTTPie shortcuts
alias GET='http GET'
alias POST='http POST'
alias PUT='http PUT'
alias DELETE='http DELETE'

# Quick lookup
alias help='tldr'

# ============================================
# Useful Functions
# ============================================
# Make directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick git commit all with message
gitall() {
  git add -A && git commit -m "$1"
}

# Find process by name
psg() {
  ps aux | rg "$1"
}

# Quick HTTP server with optional port
server() {
  local port="${1:-8000}"
  python3 -m http.server "$port"
}

# Show system info (rainbow style!)
sysinfo() {
  fastfetch
}

# ============================================
# Custom Functions
# ============================================
source ~/mechs/zsh/worktree.zsh

# ============================================
# Starship Prompt (Fast & Beautiful)
# ============================================
eval "$(starship init zsh)"

# Slack Pulse - ADHD Assist
export SLACK_PULSE_DOCS_DIR="$HOME/THE_SINK/docs"

# bun completions
[ -s "/Users/hypnodroid/.bun/_bun" ] && source "/Users/hypnodroid/.bun/_bun"

# Slack with debug port for caption capture
alias slack='open -a Slack --args --remote-debugging-port=9222'
alias kill-port="/Users/hypnodroid/mechs/tmp/zsh-commands/kill-port"

# OBS with browser source mic permissions
# Wrapper prevents OBS from blocking lid-close sleep
obs() {
  /Applications/OBS.app/Contents/MacOS/OBS --enable-media-stream --use-fake-ui-for-media-stream &
  local obs_pid=$!

  (
    while kill -0 "$obs_pid" 2>/dev/null; do
      local lid displays
      lid=$(ioreg -r -k AppleClamshellState -d 4 2>/dev/null | grep AppleClamshellState | awk '{print $NF}')
      displays=$(system_profiler SPDisplaysDataType 2>/dev/null | grep -c "Resolution:")
      if [[ "$lid" == "Yes" && $displays -lt 2 ]]; then
        osascript -e 'tell application "System Events" to sleep'
      fi
      sleep 5
    done
  ) &
  disown
}
claude-usage() {
  npx ccusage@latest blocks --active --json --token-limit max 2>/dev/null | python3 -c "
import json, sys
d = json.load(sys.stdin)
b = next(x for x in d['blocks'] if x['isActive'])
pct = b.get('tokenLimitStatus', {}).get('percentUsed', 0)
end = b['endTime'][11:16]
print(f'{pct:.0f}% (resets {end} UTC)')
"
}

export PATH=$PATH:$HOME/.maestro/bin
