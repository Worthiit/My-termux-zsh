#!/data/data/com.termux/files/usr/bin/zsh
export PATH=$PATH:/system/bin:/system/xbin

C_ART='\033[38;5;103m'
C_LBL='\033[38;5;60m'
C_TXT='\033[38;5;250m'
C_GRY='\033[38;5;240m'
C_CMD='\033[38;5;245m'
C_RST='\033[0m'

clear

user=$(cat ~/.termux_user 2>/dev/null || echo "Reinhart")
model=$(getprop ro.product.model 2>/dev/null || echo "Android")
kernel=$(uname -r | cut -d'-' -f1)
uptime=$(awk '{printf "%dh %dm\n", $1/3600, ($1%3600)/60}' /proc/uptime 2>/dev/null)
pkgs=$(ls $PREFIX/var/lib/dpkg/info/*.list 2>/dev/null | wc -l)
shell_v=$ZSH_VERSION
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

if [ -f ~/.termux/current_art.txt ]; then
    ART_LINES=("${(@f)$(< ~/.termux/current_art.txt)}")
else
    ART_LINES=("" "  [!] NO ART" "  Run 'kawai'")
fi

INFO_LINES=(
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
)

printf "\n"
MAX_LINES=${#ART_LINES[@]}
[[ ${#INFO_LINES[@]} -gt $MAX_LINES ]] && MAX_LINES=${#INFO_LINES[@]}

for ((i=1; i<=MAX_LINES; i++)); do
    ART_STR="${ART_LINES[$i]:-}"
    INFO_STR="${INFO_LINES[$i]:-}"
    printf "  ${C_ART}%-32s${C_RST} %b\n" "$ART_STR" "$INFO_STR"
done

quotes=(
    "Talk is cheap. Show me the code."
    "Code never lies, comments sometimes do."
    "Simplicity is the soul of efficiency."
    "Linux is only free if your time has no value."
    "Power comes not from knowledge kept but from knowledge shared."
    "Stay hungry, stay foolish."
    "It works on my machine."
    "There is no place like 127.0.0.1"
    "Deleted code is debugged code."
    "Experience is the name everyone gives to their mistakes."
    "Java is to JavaScript what car is to Carpet."
    "First, solve the problem. Then, write the code."
    "In order to understand recursion, one must first understand recursion."
    "The best error message is the one that never shows up."
    "I have not failed. I've just found 10,000 ways that won't work."
    "Make it work, make it right, make it fast."
)

tips=(
    "Use 'Ctrl+R' to search history backward."
    "Type 'cd <folder>' (Zoxide enabled for fast jumps)."
    "Alt+. inserts the last argument of the previous command."
    "Type 'ftext <string>' to fast-search file contents."
    "Type 'findbig' to locate files > 100MB."
    "Type 'ninja' to open the tool installer."
    "Type 'setbg' to change your terminal background."
    "Type 'texpo' to backup download files."
    "Use 'cp2clip file.txt' to copy file content to clipboard."
    "Use 'extract archive.zip' to unpack anything."
    "Type '!!' to run the last command again."
    "Type 'cd -' to toggle previous directory."
    "Type 'kawai' to switch your ASCII art."
    "Type 'setstyle' to change colors."
)

rand_q=$(( RANDOM % ${#quotes[@]} + 1 ))
rand_t=$(( RANDOM % ${#tips[@]} + 1 ))

printf "\n  ${C_GRY}>> ${C_TXT}\033[1m${quotes[$rand_q]}${C_RST}"
printf "\n  ${C_GRY}>> ${C_CMD}TIP: ${C_TXT}${tips[$rand_t]}${C_RST}\n\n"
