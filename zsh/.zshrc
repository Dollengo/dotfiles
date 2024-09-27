# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
#typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

[[ $- != *i* ]] && return

# Initialization code
export VISUAL="${EDITOR}"
export EDITOR='geany'
export BROWSER='firefox'
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export SUDO_PROMPT="Deploying root access for %u. Password pls: "

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

autoload -Uz compinit
compinit -C -d ~/.config/zsh/zcompdump

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
precmd() { vcs_info }

# Completion settings
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  '+r:|[._-]=* r:|=*' \
  '+l:|=*'
zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

# History settings
HISTFILE=~/.config/zsh/zhistory
HISTSIZE=5000
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Enable auto CD and other options
setopt AUTOCD              # change directory just by typing its name
setopt PROMPT_SUBST        # enable command substitution in prompt
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED         # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.

# Define a function for directory icon
function dir_icon {
  if [[ "$PWD" == "$HOME" ]]; then
    echo "%B%F{cyan}%f%b"
  else
    echo "%B%F{cyan}%f%b"
  fi
}

PS1='%B%F{blue}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{green}.%F{red})%f%b '

# Command not found handler
command_not_found_handler() {
  printf "%s%s? I don't know what is it\n" "$acc" "$0" >&2
  return 127
}

# Plugins

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

plugins=(
    archlinux
    git
    history-substring-search
    colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Bind keys for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[3~' delete-char

# Aliases
alias mirrors="sudo reflector --verbose --latest 5 --country 'United States' --age 6 --sort rate --save /etc/pacman.d/mirrorlist"
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias mantenimiento="yay -Sc && sudo pacman -Scc"
alias purga="sudo pacman -Rns \$(pacman -Qtdq) ; sudo fstrim -av"
alias update="paru -Syu --nocombinedupgrade"
alias music="ncmpcpp"
alias cat="bat --theme=base16"
alias ls='eza --icons=always --color=always -a'
alias ll='eza --icons=always --color=always -la'
alias q="exit"
alias :q="exit"
alias c="clear"
alias cls="clear"

# Git open alias
alias gitopen='function _gitopen() {
    if [ -d ".git" ]; then
        local url=$(git config --get remote.origin.url)
        if [ -n "$url" ]; then
            brave "$url"
        else
            echo "Não foi possível encontrar a URL do repositório remoto."
        fi
    else
        echo "O diretório atual não é um repositório Git."
    fi
}; _gitopen'

alias code="flatpak run com.visualstudio.code"
alias brave="flatpak run com.brave.Browser"
alias emacs="emacs -nw"
alias codecrashy="cd /mnt/Dados/Projetos/crashy"
alias thebrain="cd /mnt/Dados/Obsidian/TheBrain"
alias rmfuse="find . -name '.fuse_hidden*' -exec rm -f {} +"
#alias android="source ~/pythonvenv/bin/activate && cd ~/TuxDex/ && python3 tuxdex.py"
alias android="scrcpy"

#export VULKAN_SDK=~/vulkan-1.3.290/x86_64
#export PATH=$VULKAN_SDK/bin:$PATH
#export LD_LIBRARY_PATH=$VULKAN_SDK/lib:$LD_LIBRARY_PATH
#export VK_LAYER_PATH=$VULKAN_SDK/etc/vulkan/explicit_layer.d

# Thefuck alias
eval $(thefuck --alias)

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Vi mode
#bindkey -v
#export KEYTIMEOUT=1

# Cursor shape for different vi modes
#function zle-keymap-select {
#  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
#dmesg | grep -i amdgpu
#dmesg | grep -i amdgpu
#dmesg | grep -i amdgpu
#dmesg | grep -i ath10k
#dmesg | grep -i ath10k
#dmesg | grep -i ath10k
#    echo -ne '\e[1 q'
#  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 = 'beam' ]]; then
#    echo -ne '\e[5 q'
#  fi
#}
#zle -N zle-keymap-select

# Use lf to switch directories
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e
#autoload edit-command-line; zle -N edit-command-line
#bindkey '^e' edit-command-line

# Deno and .NET configuration
export DENO_INSTALL="/home/dollengo/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export DOTNET_ROOT="/snap/dotnet-runtime-80/current"

# Defina o caminho correto para o Vulkan SDK
#export VULKAN_SDK="$HOME/vulkan-1.3.290/x86_64"
export VULKAN_SDK="/home/dollengo/vulkan-1.3.290/x86_64"
export PATH="$VULKAN_SDK/bin:$PATH"
export LD_LIBRARY_PATH="$VULKAN_SDK/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export VK_LAYER_PATH="$VULKAN_SDK/etc/vulkan/explicit_layer.d"

# Init display
clear
echo 
pfetch
echo
date
echo

bindkey '^F' autosuggest-accept

#source ~/powerlevel10k/powerlevel10k.zsh-theme

# Powerlevel10k configuration
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
