#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\033[1;36m>>> INITIALIZING REINHART PROTOCOL <<<\033[0m"

pkg update -y && pkg upgrade -y
pkg install -y zsh git curl wget termux-api ncurses-utils make clang tar bat grep

mkdir -p ~/.termux
mkdir -p ~/.config/neofetch

curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf

cat > ~/.termux/colors.properties << 'EOF'
background=#101216
foreground=#d0d0d0
cursor=#00ff00
color0=#101216
color1=#ff5555
color2=#50fa7b
color3=#f1fa8c
color4=#bd93f9
color5=#ff79c6
color6=#8be9fd
color7=#bfbfbf
color8=#4d4d4d
color9=#ff6e67
color10=#5af78e
color11=#f4f99d
color12=#caa9fa
color13=#ff92d0
color14=#9aedfe
color15=#e6e6e6
EOF

termux-reload-settings

rm -rf ~/.zshrc ~/.bashrc ~/motd.sh ~/reinhart_motd.sh
rm -f $PREFIX/etc/motd

cat > ~/motd.sh << 'EOF'
#!/usr/bin/env zsh
export PATH=$PATH:/system/bin:/system/xbin
clear
C_ART='\033[1;36m'
C_LBL='\033[1;35m'
C_TXT='\033[1;37m'
C_GRY='\033[1;30m'
C_CMD='\033[0;32m'
C_RST='\033[0m'

user="Reinhart"
model=$(getprop ro.product.model 2>/dev/null || echo "Android")
kernel=$(uname -r | cut -d'-' -f1)
uptime=$(uptime | awk -F'( |,|:)+' '{if ($7=="min") print $6"m"; else print $6"h "$7"m"}')
pkgs=$(pkg list-installed 2>/dev/null | wc -l)
shell_v=$(zsh --version | awk '{print $2}')
storage=$(df -h /data 2>/dev/null | awk 'NR==2 {print $3 "/" $2}')

if [ -e /sys/class/power_supply/battery/capacity ]; then
    bat_lvl="$(cat /sys/class/power_supply/battery/capacity)%"
else
    bat_lvl="N/A"
fi

if [ -r /proc/meminfo ]; then
    tot=$(awk '/MemTotal/ {printf "%.1f", $2/1024/1024}' /proc/meminfo)
    avail=$(awk '/MemAvailable/ {printf "%.1f", $2/1024/1024}' /proc/meminfo)
    used=$(awk -v t=$tot -v a=$avail 'BEGIN {printf "%.1f", t-a}')
    ram="${used}G / ${tot}G"
else
    ram="N/A"
fi

ART_LINES=(
"        __"
"        / /\\"
"       / /  \\"
"      / /    \\__________"
"     / /      \\        /\\"
"    /_/        \\      / /"
" ___\\ \\      ___\\____/_/_"
"/____\\ \\    /___________/\\"
"\\     \\ \\   \\           \\ \\"
" \\     \\ \\   \\____       \\ \\"
"  \\     \\ \\  /   /\\       \\ \\"
"   \\   / \\_\\/   / /        \\ \\"
"    \\ /        / /__________\\/"
"     /        / /     /"
"    /        / /     /"
"   /________/ /\\    /"
"   \\________\\/\\ \\  /"
"               \\_\\/"
)

INFO_LINES=(
    ""
    ""
    "${C_LBL}USER     :: ${C_TXT}$user"
    "${C_LBL}MODEL    :: ${C_TXT}$model"
    "${C_LBL}SYSTEM   :: ${C_TXT}Android $(getprop ro.build.version.release)"
    "${C_LBL}KERNEL   :: ${C_TXT}$kernel"
    "${C_LBL}UPTIME   :: ${C_TXT}$uptime"
    "${C_LBL}BATTERY  :: ${C_TXT}$bat_lvl"
    "${C_LBL}RAM      :: ${C_TXT}$ram"
    "${C_LBL}STORAGE  :: ${C_TXT}$storage"
    "${C_LBL}PACKAGES :: ${C_TXT}$pkgs"
    "${C_LBL}SHELL    :: ${C_TXT}zsh $shell_v"
    "${C_LBL}NETWORK  :: ${C_GRY}[ ENCRYPTED ]"
    "${C_GRY}            (Type 'reveal')"
    ""
    ""
    ""
    ""
)

printf "\n"
MAX=${#ART_LINES[@]}
for ((i=1; i<=MAX; i++)); do
    printf "  ${C_ART}%-30s${C_RST} %b\n" "${ART_LINES[$i]}" "${INFO_LINES[$i]}"
done

quotes=(
    "Talk is cheap. Show me the code."
    "Code never lies, comments sometimes do."
    "Simplicity is the soul of efficiency."
    "Linux is only free if your time has no value."
    "Power comes not from knowledge kept but from knowledge shared."
)
tips=(
    "Use 'Ctrl+R' to search history backward."
    "Type '!!' to run the last command again."
    "Alt+. inserts the last argument of the previous command."
    "Use 'cd -' to toggle between the last two directories."
    "Command 'top' shows real-time process info."
)
rand_q=$(( RANDOM % ${#quotes[@]} + 1 ))
rand_t=$(( RANDOM % ${#tips[@]} + 1 ))
printf "\n  ${C_GRY}>> ${C_TXT}\033[1m${quotes[$rand_q]}${C_RST}\n"
printf "  ${C_GRY}>> ${C_CMD}TIP: ${C_TXT}${tips[$rand_t]}${C_RST}\n\n"
EOF

chmod +x ~/motd.sh

cat > ~/.zshrc << 'EOF'
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt AUTO_CD
setopt nonomatch
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

typeset -gAH ZINIT
ZINIT[HOME_DIR]="$HOME/.local/share/zinit"
ZINIT[PLUGINS_DIR]="$ZINIT[HOME_DIR]/plugins"
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1

zi for is-snippet \
    OMZL::{completion,git,key-bindings}.zsh \
    PZT::modules/{history}

zi for \
    ohmyzsh/ohmyzsh path:plugins/z \
    ohmyzsh/ohmyzsh path:plugins/extract

zi ice zsh-users/zsh-completions
zi ice atload'_zsh_autosuggest_start' \
    atinit'ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50; bindkey "^_" autosuggest-execute; bindkey "^ " autosuggest-accept'
zi light zsh-users/zsh-autosuggestions

zi light-mode for \
    zdharma-continuum/fast-syntax-highlighting

zi ice joshskidmore/zsh-fzf-history-search

zi ice atload'bindkey "^I" menu-select; bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete'
zi light marlonrichert/zsh-autocomplete

alias up='pkg update -y && pkg upgrade -y'
alias ins='pkg install'
alias rem='pkg uninstall'
alias cls='clear'
alias rf='rm -rf'
alias md='mkdir -p'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lah --color=auto --group-directories-first'
alias ..='cd ..'
alias ...='cd ../..'
alias h='cd ~'
alias d='cd ~/storage/downloads'
alias g='git'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gs='git status -s'
alias py='python3'
alias myip='curl -s https://api.ipify.org'
alias ports='netstat -tulpn'
alias runclip='termux-clipboard-get > temp_script.py && python3 temp_script.py'

reveal() {
    printf "\n\033[1;36m[ NETWORK REVEAL ]\033[0m\n"
    printf "\033[1;35mLocal IP  :: \033[1;37m%s\033[0m\n" "$(ifconfig | grep -oE '192\.168\.[0-9]+\.[0-9]+' | head -n 1)"
    printf "\033[1;35mPublic IP :: \033[1;37m%s\033[0m\n" "$(curl -s https://api.ipify.org)"
    printf "\n"
}
copyclip() { 
    termux-clipboard-set < "$1" && echo "\033[1;32m[✔] Copied $1\033[0m" 
}

zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ -f ~/motd.sh ]] && source ~/motd.sh
EOF

cat > ~/.bashrc << 'EOF'
alias runclip='termux-clipboard-get > temp_script.py && python3 temp_script.py'
if [ -f ~/motd.sh ]; then
    bash ~/motd.sh
fi
EOF

chsh -s zsh
echo -e "\033[1;32m>>> INSTALLATION COMPLETE. RESTART TERMUX NOW. <<<\033[0m"
