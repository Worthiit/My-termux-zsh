if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f ~/motd.sh ]] && source ~/motd.sh

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history
setopt AUTO_CD
setopt nonomatch

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey '^Z' undo
bindkey '^Y' redo
bindkey ' ' magic-space
autoload -Uz zmv

ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
typeset -gAH ZINIT
ZINIT[HOME_DIR]="$HOME/.local/share/zinit"
ZINIT[PLUGINS_DIR]="$ZINIT[HOME_DIR]/plugins"
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1

# --- FIXED PLUGIN LOADING ---
zi ice wait"0" lucid
zi snippet OMZL::completion.zsh

zi ice wait"0" lucid
zi snippet OMZL::git.zsh

zi ice wait"0" lucid
zi snippet OMZL::key-bindings.zsh

zi ice wait"0" lucid
zi load zsh-users/zsh-autosuggestions

zi ice wait"0" lucid atinit"ZINIT[COMPLIST_HIGHLIGHT]='preview'"
zi load zdharma-continuum/fast-syntax-highlighting

zi ice wait"0" lucid
zi load zsh-users/zsh-completions

zi ice wait"0" lucid atload'bindkey "^I" menu-select; bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete'
zi load marlonrichert/zsh-autocomplete

zi for ohmyzsh/ohmyzsh path:plugins/extract

# --- TOOLS & ALIASES ---
eval "$(zoxide init zsh)"

alias q="exit"
alias c="clear"
alias cls="clear"
alias v="nvim"
alias vi='nvim'
alias vim='nvim'
alias n='nvim'
alias up='pkg update -y && pkg upgrade -y'
alias rf='rm -rf'
alias g='git'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias py='python3'
alias sd="cd /sdcard"
alias pf='cd "$PREFIX"'
alias ss="cd /sdcard/Pictures/Screenshots/"
alias ms="cd /sdcard/Movies"
alias dl="cd /sdcard/Download"
alias ds="cd /sdcard/Documents"
alias cd="z"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias h='cd ~'
alias ls="eza --icons"
alias la="eza --icons -lgha --group-directories-first"
alias l="eza --icons -lgha --group-directories-first"
alias ly="eza --icons -lgha --group-directories-first"
alias lt="eza --icons --tree"
alias lta="eza --icons --tree -lgha"
alias preview="fzf --preview='bat --color=always --style=numbers --theme OneHalfDark {}' --preview-window=down"
alias fnvim='nvim $(fzf -m --preview="bat --color=always --style=numbers --theme OneHalfDark {}" --preview-window=down)'
alias fvim='vim $(fzf -m --preview="bat --color=always --style=numbers --theme OneHalfDark {}" --preview-window=down)'
alias fcd="cd \$(find . -type d | fzf)"
alias mkdir='mkdir -p'
alias psu="ps aux"
alias psg="ps aux | grep -i"
alias kill9="kill -9"
alias startssh='ssh -p 8022 localhost'
alias stopssh='pkill sshd'
alias myip="curl ifconfig.me"
alias ports='netstat -tulpn'
alias speedtest="curl -s https://raw.githubusercontent.com/noreplyui5/speedtest-cli/master/speedtest.py | python"
alias neofetch='fastfetch'
alias largefile="du -h -x -s -- * | sort -r -h | head -20"
alias listfont="magick convert -list font | grep -iE 'font:.*'"
alias reload="termux-reload-settings"
alias texpo="mkdir -p /sdcard/Download/Tmux-expo && cp -r -t /sdcard/Download/Tmux-expo"
alias rep="termux-clipboard-get >"
alias runclip='termux-clipboard-get > temp_script.py && python3 temp_script.py'
alias ninja="bash ~/ninja.sh"

if command -v batcat &>/dev/null; then
    alias cat='batcat --theme OneHalfDark -p'
else
    alias cat='bat --theme OneHalfDark -p'
fi

chpwd() { eza --icons -lgha --group-directories-first; }
mkcd() { mkdir -p "$1" && cd "$1"; }
cpg() { if [ -d "$2" ]; then cp "$1" "$2" && cd "$2" || return; else cp "$1" "$2"; fi }
mvg() { if [ -d "$2" ]; then mv "$1" "$2" && cd "$2" || return; else mv "$1" "$2"; fi }
mkdirg() { mkdir -p "$1" && cd "$1" || return; }

setbg() {
    if [[ "$1" == "--default" ]]; then
        rm -f ~/.termux/background.jpeg
        termux-reload-settings
        echo "\033[1;32m[✔] Background reset to default.\033[0m"
        return
    fi

    if [ ! -d "$HOME/storage" ]; then
        echo "\033[1;33m[!] Storage access required. Requesting permission...\033[0m"
        termux-setup-storage
        echo "\033[1;33m[!] Please click 'Allow' and try 'setbg' again.\033[0m"
        return
    fi

    if [[ -n "$1" ]]; then
        if [[ -f "$1" ]]; then
            cp "$1" ~/.termux/background.jpeg
            am broadcast --user 0 -a com.termux.app.reload_style com.termux >/dev/null 2>&1
            termux-reload-settings
            echo "\033[1;32m[✔] Background updated from path.\033[0m"
            return
        else
            echo "\033[1;31m[✘] File not found: $1\033[0m"
            return
        fi
    fi

    if ! command -v fzf &> /dev/null; then
        echo "\033[1;31m[!] fzf is missing. Run: pkg install fzf\033[0m"
        return
    fi
    
    echo "\033[1;36m>>> SCANNING IMAGES (Downloads, Pictures, DCIM)...\033[0m"
    local img_list
    
    if command -v fd &> /dev/null; then
        img_list=$(fd -e jpg -e jpeg -e png . ~/storage/downloads ~/storage/pictures ~/storage/dcim 2>/dev/null)
    else
        img_list=$(find ~/storage/downloads ~/storage/pictures ~/storage/dcim -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null)
    fi

    if [[ -z "$img_list" ]]; then
        echo "\033[1;33m[!] No images found in standard folders.\033[0m"
        return
    fi

    local file
    file=$(echo "$img_list" | fzf --prompt="Wallpaper > " --height=50% --layout=reverse --border)

    if [[ -n "$file" ]]; then
        cp "$file" ~/.termux/background.jpeg
        am broadcast --user 0 -a com.termux.app.reload_style com.termux >/dev/null 2>&1
        termux-reload-settings
        echo "\033[1;32m[✔] Background updated: $file\033[0m"
    fi
}

fkill() {
    local pid
    local tmpfile
    tmpfile=$(mktemp)
    ps -eo user,pid,cmd --sort=-%mem | sed 1d | fzf --multi --reverse --header=" Select processes to kill (Tab to mark, Enter to kill)" --preview 'ps -p {2} -o pid,user,%cpu,%mem,cmd' --bind 'ctrl-s:toggle-sort' >"$tmpfile"
    if [[ ! -s $tmpfile ]]; then
        rm -f "$tmpfile"
        return 1
    fi
    while IFS= read -r line; do
        pid=$(echo "$line" | awk '{print $2}')
        if [[ -n "$pid" ]]; then
            if kill -TERM "$pid" 2>/dev/null; then : ; else kill -KILL "$pid" 2>/dev/null; fi
        fi
    done <"$tmpfile"
    rm -f "$tmpfile"
}

backup() {
    local item="$1"
    [[ -z "$item" ]] && return 1
    local backup_name="${item}.backup.$(date +%Y%m%d_%H%M%S)"
    if [[ -d "$item" ]]; then
        cp -rv "$item" "$backup_name"
    else
        cp -v "$item" "$backup_name"
    fi
}

freplace() {
    [[ $# -ne 3 ]] && return 1
    local search="$1"
    local replace="$2"
    local pattern="$3"
    grep -l "$search" $pattern 2>
