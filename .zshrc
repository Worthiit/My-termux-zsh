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
cpg() { if[ -d "$2" ]; then cp "$1" "$2" && cd "$2" || return; else cp "$1" "$2"; fi }
mvg() { if [ -d "$2" ]; then mv "$1" "$2" && cd "$2" || return; else mv "$1" "$2"; fi }
mkdirg() { mkdir -p "$1" && cd "$1" || return; }

setbg() {
    if [[ "$1" == "--default" ]]; then
        rm -f ~/.termux/background.jpeg
        termux-reload-settings
        echo "\033[1;32m[✔] Background reset to default.\033[0m"
        return
    fi

    if ! command -v fzf &> /dev/null; then
        echo "\033[1;31m[!] fzf is not installed. Run: pkg install fzf\033[0m"
        return
    fi
    
    echo "\033[1;36m>>> SELECT IMAGE FROM STORAGE (Volume Up/Down to move, Enter to select)...\033[0m"
    local file
    file=$(find /sdcard -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null | fzf)

    if [[ -n "$file" ]]; then
        cp "$file" ~/.termux/background.jpeg
        termux-reload-settings
        echo "\033[1;32m[✔] Background updated: $file\033[0m"
        echo "\033[1;33m[!] Note: If transparency is low, you might not see it.\033[0m"
    else
        echo "\033[1;31m[!] No file selected.\033[0m"
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
    grep -l "$search" $pattern 2>/dev/null || return 1
    read -p "Continue with replacement? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sed -i.bak "s/$search/$replace/g" $pattern
    fi
}

duf() {
    local target="${1:-.}"
    du -h "$target"/* 2>/dev/null | sort -hr | head -20
}

note() {
    local note_file="$HOME/.notes"
    if [[ $# -eq 0 ]]; then
        cat "$note_file" 2>/dev/null
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $*" >>"$note_file"
    fi
}

encrypt() {
    local file="$1"
    [[ -z "$file" ]] && return 1
    openssl enc -aes-256-cbc -salt -in "$file" -out "${file}.enc"
}

decrypt() {
    local file="$1"
    [[ -z "$file" ]] && return 1
    local output="${file%.enc}"
    openssl enc -d -aes-256-cbc -in "$file" -out "$output"
}

checksum() {
    local file="$1"
    [[ -z "$file" || ! -f "$file" ]] && return 1
    echo "  MD5:    $(md5sum "$file" | cut -d' ' -f1)"
    echo "  SHA1:   $(sha1sum "$file" | cut -d' ' -f1)"
    echo "  SHA256: $(sha256sum "$file" | cut -d' ' -f1)"
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
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

cp2clip() {
    [[ $# -eq 0 ]] && return 1
    [[ ! -f "$1" ]] && return 1
    if command -v termux-clipboard-set >/dev/null; then
        cat "$1" | termux-clipboard-set
    elif command -v xclip >/dev/null; then
        cat "$1" | xclip -selection clipboard
    elif command -v xsel >/dev/null; then
        cat "$1" | xsel --clipboard --input
    fi
}

copyclip() { termux-clipboard-set < "$1"; }

reveal() {
    printf "\n\033[1;36m[ NETWORK REVEAL ]\033[0m\n"
    printf "\033[1;35mLocal IP  :: \033[1;37m%s\033[0m\n" "$(ifconfig wlan0 2>/dev/null | awk '/inet /{print $2}')"
    printf "\033[1;35mPublic IP :: \033[1;37m%s\033[0m\n" "$(curl -s https://api.ipify.org)"
    printf "\n"
}

bring() {
    [[ -z "$1" ]] && return 1
    cp -rf "$@" .
}

xport() {
    [[ -z "$1" ]] && return 1
    cp -rf "$@" "/sdcard/Download/"
}

setname() {
    [[ -z "$1" ]] && return 1
    echo "$1" > ~/.termux_user
}

setlook() { termux-nf; }
setstyle() { termux-color; }
setprompt() { p10k configure; }
ftext() { rg -i "$1"; }
findbig() { fd -S +100M; }

zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
