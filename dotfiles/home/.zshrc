typeset -U path cdpath fpath manpath
for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

HELPDIR="/nix/store/m2w5grgw9wl1r76qxzs5l3i4d0skblmc-zsh-5.9/share/zsh/$ZSH_VERSION/help"

autoload -U compinit && compinit
# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

# HISTFILE="/Users/abayoumy/.zsh_history"
# mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK

# Enabled history options
enabled_opts=(
  HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
)
for opt in "${enabled_opts[@]}"; do
  setopt "$opt"
done
unset opt enabled_opts

# Disabled history options
disabled_opts=(
  APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
  HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
)
for opt in "${disabled_opts[@]}"; do
  unsetopt "$opt"
done
unset opt disabled_opts

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# if [[ -f "/opt/homebrew/bin/brew" ]] then
#   # If you're using macOS, you'll want this enabled
#   eval "$(/opt/homebrew/bin/brew shellenv)"
# fi

# gemini
export GEMINI_API_KEY="AIzaSyCgApJh0V28aKq8N5yPkrcq_63XdVbp_PM"
# Proxmox server ip 
export proxmox_api_url_host="10.0.0.200"
#"AIzaSyDLMYfNrl9HKyYEEThJxC-ka46QPT3ejTA"
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k (disabled)
# zinit ice depth=1; zinit light romkatv/powerlevel10k

#   catppuccin_mocha-zsh-syntax-highlighting theme
source ~/.config/catppuccin_mocha-zsh-syntax-highlighting.zsh
# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey '^[c' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
# alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias clock='tty-clock -c -C 2 -b'
alias l='eza --icons --group --group-directories-first'
alias ls='eza --icons --group --group-directories-first'
# alias ll='eza --icons -l -T -L=1'
alias ll='eza --long --group --group-directories-first --icons --header --time-style long-iso'
alias la='eza --icons -la --all --long --group --group-directories-first --icons --header --time-style long-iso'
alias lt='eza --icons -T -L=1'
alias tree="eza --tree --all --ignore-glob='*.o|*.log' --git"
alias cat='bat'
# alias top='sudo mactop'
alias fd='fd -Lu'
alias weather='curl v2.wttr.in'
alias ff='clear && fastfetch'
alias mac-clean="nix-collect-garbage -d; nix-store --optimise"

ff

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"



# Created by `pipx` on 2026-01-05 22:35:17
export PATH="$PATH:$HOME/.local/bin"

alias -- eza='eza --icons auto --git'
