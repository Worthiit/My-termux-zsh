if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt AUTO_CD
setopt nonomatch
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

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

zi for \
    ohmyzsh/ohmyzsh path:plugins/z \
    ohmyzsh/ohmyzsh path:plugins/extract

zi ice zsh-users/zsh-completions
zi ice atload'bindkey "^I" menu-select; bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete'
zi light marlonrichert/zsh-autocomplete

alias q="exit"
alias c="clear"
alias cls="clear"
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
alias startssh='termux-ssh'
alias stopssh='termux-ssh stop'
alias reload="termux-reload-settings"

alias ..='cd ..'
alias ...='cd ../..'
alias h='cd ~'
alias dl="cd /sdcard/Download"
alias sd="cd /sdcard"

alias ls="eza --icons"
alias la="eza --icons -lgha --group-directories-first"
alias lt="eza --icons --tree"
alias cat='bat --theme OneHalfDark -p'
alias mkdir='mkdir -p'
alias speedtest="curl -s https://raw.githubusercontent.com/noreplyui5/speedtest-cli/master/speedtest-cli.py | python3"

alias texpo="mkdir -p /sdcard/Download/Tmux-expo && cp -r -t /sdcard/Download/Tmux-expo"
alias rep="termux-clipboard-get >"
alias runclip='termux-clipboard-get > temp_script.py && python3 temp_script.py'

copyclip() { termux-clipboard-set < "$1" && echo "\e[32m[✔] Copied $1\e[0m"; }

reveal() {
    printf "\n\033[1;36m[ NETWORK REVEAL ]\033[0m\n"
    printf "\033[1;35mLocal IP  :: \033[1;37m%s\033[0m\n" "$(ifconfig | grep -oE '192\.168\.[0-9]+\.[0-9]+' | head -n 1)"
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

setlook() {
    echo -e "\033[1;32m>>> DOWNLOADING FONT MANAGER...\033[0m"
    curl -fsSL https://raw.githubusercontent.com/sabamdarif/termux-desktop/main/other/termux-nf -o $PREFIX/bin/termux-nf
    chmod +x $PREFIX/bin/termux-nf
    echo -e "\033[1;32m>>> LAUNCHING SELECTOR...\033[0m"
    termux-nf
}

ftext() { grep -iIHrn --color=always "$1" . | less -r; }

zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ -f ~/motd.sh ]] && source ~/motd.sh
