#!/data/data/com.termux/files/usr/bin/zsh
export PATH=$PATH:/system/bin:/system/xbin

C_ART='\033[1;36m'
C_LBL='\033[1;35m'
C_TXT='\033[1;37m'
C_GRY='\033[1;30m'
C_CMD='\033[0;32m'
C_RST='\033[0m'

clear

user=$(cat ~/.termux_user 2>/dev/null || echo "Termux")
model=$(getprop ro.product.model 2>/dev/null || echo "Android")
kernel=$(uname -r | cut -d'-' -f1)
uptime=$(uptime | awk -F'( |,|:)+' '{if ($7=="min") print $6"m"; else print $6"h "$7"m"}')
pkgs=$(dpkg --get-selections 2>/dev/null | grep -v deinstall | wc -l)
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
    "Stay hungry, stay foolish."
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
