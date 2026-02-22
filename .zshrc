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
zi ice atload'bindkey "^I" menu-select; bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete; bindkey -M menuselect "^[[A" up-line-or-history; bindkey -M menuselect "^[[B" down-line-or-history; bindkey -M menuselect "^[[C" forward-char; bindkey -M menuselect "^[[D" backward-char'
zi light marlonrichert/zsh-autocomplete

alias q="exit"
alias c="clear"
alias g="git"
alias f="find . | grep "
alias sd="cd /sdcard"
alias pf='cd "$PREFIX"'
alias ss="cd /sdcard/Pictures/Screenshots/"
alias ms="cd /sdcard/Movies"
alias dl="cd /sdcard/Download"
alias ds="cd /sdcard/Documents"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
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
alias vi='nvim'
alias vim='nvim'
alias n='nvim'
alias cat='bat --theme OneHalfDark -p'
alias mkdir='mkdir -p'
alias reload="termux-reload-settings"
alias psu="ps aux"
alias psg="ps aux | grep -i"
alias kill9="kill -9"
alias startssh='termux-ssh'
alias stopssh='termux-ssh stop'
alias myip="curl ifconfig.me"
alias speedtest="curl -s https://raw.githubusercontent.com/noreplyui5/speedtest-cli/master/speedtest-cli.py | python3"
alias neofetch='fastfetch'
alias largefile="du -h -x -s -- * | sort -r -h | head -20"
alias listfont="magick convert -list font | grep -iE 'font:.*'"
alias texpo="mkdir -p /sdcard/Download/Tmux-expo && cp -r -t /sdcard/Download/Tmux-expo"
alias rep="termux-clipboard-get >"
alias runclip='termux-clipboard-get > temp_script.py && python3 temp_script.py'

extract() {
	local archive="$1"
	if [[ ! -f "$archive" ]]; then return 1; fi
	case "$archive" in
	*.tar.gz | *.tgz) tar -xzvf "$1" ;;
	*.tar.xz | *.txz) tar -xJvf "$1" ;;
	*.zip | *.jar | *.apk) unzip "$1" ;;
	*.rar) unrar x "$1" ;;
	*.7z) 7z x "$1" ;;
	*) 7z x "$1" ;;
	esac
}

ftext() { grep -iIHrn --color=always "$1" . | less -r; }
cpg() { cp "$1" "$2" && cd "$2"; }
mvg() { mv "$1" "$2" && cd "$2"; }
mkdirg() { mkdir -p "$1" && cd "$1"; }
backup() { cp -r "$1" "${1}.backup.$(date +%Y%m%d_%H%M%S)"; }
duf() { du -h "${1:-.}"/* 2>/dev/null | sort -hr | head -20; }
reveal() { printf "\n\033[1;36m[ NETWORK REVEAL ]\033[0m\n"; printf "\033[1;35mLocal IP  :: \033[1;37m%s\033[0m\n" "$(ifconfig | grep -oE '192\.168\.[0-9]+\.[0-9]+' | head -n 1)"; printf "\033[1;35mPublic IP :: \033[1;37m%s\033[0m\n" "$(curl -s https://api.ipify.org)"; printf "\n"; }
copyclip() { termux-clipboard-set < "$1" && echo "\e[32m[✔] Copied $1\e[0m"; }
bring() { cp -rf "$@" .; }
xport() { cp -rf "$@" "/sdcard/Download/"; }
setlook() { termux-nf; }
setstyle() { termux-color; }
setprompt() { p10k configure; }

zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ -f ~/motd.sh ]] && source ~/motd.sh
