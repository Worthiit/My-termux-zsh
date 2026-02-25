if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f ~/motd.sh ]] && source ~/motd.sh

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt AUTO_CD
setopt nonomatch

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

zi ice wait"0" lucid; snippet OMZL::completion.zsh
zi ice wait"0" lucid; snippet OMZL::git.zsh
zi ice wait"0" lucid; snippet OMZL::key-bindings.zsh
zi ice wait"0" lucid; load zsh-users/zsh-autosuggestions
zi ice wait"0" lucid atinit"ZINIT[COMPLIST_HIGHLIGHT]='preview'"; load zdharma-continuum/fast-syntax-highlighting

zi for ohmyzsh/ohmyzsh path:plugins/extract
zi ice zsh-users/zsh-completions
zi ice atload'bindkey "^I" menu-select; bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete'
zi light marlonrichert/zsh-autocomplete

eval "$(zoxide init zsh)"

alias q="exit"
alias c="clear"
alias cls="clear"
alias v="nvim"
alias up='pkg update -y && pkg upgrade -y'
alias rf='rm -rf'
alias g='git'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias py='python3'
alias myip="curl ifconfig.me"
alias ports='netstat -tulpn'
alias startssh='ssh -p 8022 localhost'
alias stopssh='pkill sshd'
alias reload="termux-reload-settings"
alias cd="z"
alias ..='cd ..'
alias ...='cd ../..'
alias h='cd ~'
alias dl="cd /sdcard/Download"
alias sd="cd /sdcard"
alias ls="eza --icons"
alias ll="eza --icons -lgha --group-directories-first"
alias la="eza --icons -lgha --group-directories-first"
alias lt="eza --icons --tree"
alias cat='bat --theme OneHalfDark -p'
alias texpo="mkdir -p /sdcard/Download/Tmux-expo && cp -r -t /sdcard/Download/Tmux-expo"
alias rep="termux-clipboard-get >"
alias runclip='termux-clipboard-get > temp_script.py && python3 temp_script.py'
alias arsenal="~/gettools.sh"

chpwd() {
    eza --icons -lgha --group-directories-first
}

mkcd() {
    mkdir -p "$1" && cd "$1"
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

copyclip() { termux-clipboard-set < "$1" && echo "\e[32m[✔] Copied $1\e[0m"; }

reveal() {
    printf "\n\033[1;36m[ NETWORK REVEAL ]\033[0m\n"
    printf "\033[1;35mLocal IP  :: \033[1;37m%s\033[0m\n" "$(ifconfig wlan0 2>/dev/null | awk '/inet /{print $2}')"
    printf "\033[1;35mPublic IP :: \033[1;37m%s\033[0m\n" "$(curl -s https://api.ipify.org)"
    printf "\n"
}

bring() {
    [[ -z "$1" ]] && echo -e "\e[31mUsage: bring <path>\e[0m" && return 1
    cp -rf "$@" . && echo -e "\e[32m[+] Retrieved object to current sector.\e[0m"
}

xport() {
    [[ -z "$1" ]] && echo -e "\e[31mUsage: xport <file>\e[0m" && return 1
    cp -rf "$@" "/sdcard/Download/" && echo -e "\e[32m[+] Exported to Download storage.\e[0m"
}

setname() {
    [[ -z "$1" ]] && echo -e "\e[31mUsage: setname \"New Name\"\e[0m" && return 1
    echo "$1" > ~/.termux_user
    echo -e "\e[32m[✔] Identity updated to $1\e[0m"
}

setlook() { termux-nf; }
setstyle() { termux-color; }
setprompt() { p10k configure; }
ftext() { rg -i "$1"; }
findbig() { fd -S +100M; }

zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
