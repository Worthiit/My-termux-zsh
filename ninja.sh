#!/data/data/com.termux/files/usr/bin/bash

if ! command -v dialog &> /dev/null; then
    pkg install -y dialog >/dev/null 2>&1
fi

cat << 'EOF' > ~/.dialogrc
use_shadow = OFF
use_colors = ON
screen_color = (CYAN,BLUE,OFF)
dialog_color = (BLACK,WHITE,OFF)
title_color = (BLUE,WHITE,ON)
border_color = (WHITE,WHITE,ON)
button_active_color = (WHITE,BLACK,ON)
button_inactive_color = (BLACK,WHITE,OFF)
button_key_active_color = (WHITE,BLACK,ON)
button_key_inactive_color = (RED,WHITE,OFF)
button_label_active_color = (WHITE,BLACK,ON)
button_label_inactive_color = (BLACK,WHITE,ON)
inputbox_color = (BLACK,WHITE,OFF)
inputbox_border_color = (BLACK,WHITE,OFF)
searchbox_color = (BLACK,WHITE,OFF)
searchbox_border_color = (BLACK,WHITE,OFF)
searchbox_title_color = (BLUE,WHITE,ON)
position_indicator_color = (BLUE,WHITE,ON)
menubox_color = (BLACK,WHITE,OFF)
menubox_border_color = (WHITE,WHITE,ON)
item_color = (BLACK,WHITE,OFF)
item_selected_color = (WHITE,BLACK,ON)
tag_color = (BLUE,WHITE,ON)
tag_selected_color = (CYAN,BLACK,ON)
tag_key_color = (RED,WHITE,OFF)
tag_key_selected_color = (RED,BLACK,ON)
check_color = (BLACK,WHITE,OFF)
check_selected_color = (WHITE,BLACK,ON)
uarrow_color = (GREEN,WHITE,ON)
darrow_color = (GREEN,WHITE,ON)
EOF

if [ ! -f ~/.ninja_prepped ]; then
    echo -e "\033[1;36m[+] First run, just getting things ready...\033[0m"
    pkg install -y tur-repo x11-repo root-repo python git wget curl >/dev/null 2>&1
    touch ~/.ninja_prepped
fi

declare -A TOOLS
declare -A DESC
declare -A USAGE

TOOLS[1]="apktool";    DESC[1]="Decompile and build APKs";      USAGE[1]="apktool d app.apk"
TOOLS[2]="lazygit";    DESC[2]="Better way to manage Git";      USAGE[2]="lazygit"
TOOLS[3]="yt-dlp";     DESC[3]="Download videos from anywhere"; USAGE[3]="yt-dlp <url>"
TOOLS[4]="nmap";       DESC[4]="Scan networks for open ports";  USAGE[4]="nmap -sV google.com"
TOOLS[5]="sqlmap";     DESC[5]="Test for SQL injection";        USAGE[5]="python sqlmap.py -u <url>"
TOOLS[6]="metasploit"; DESC[6]="The big pentest framework";      USAGE[6]="msfconsole"
TOOLS[7]="sherlock";   DESC[7]="Find social media accounts";    USAGE[7]="python sherlock.py user"
TOOLS[8]="blackbird";  DESC[8]="Find usernames (OSINT)";        USAGE[8]="blackbird -u user"
TOOLS[9]="zoxide";     DESC[9]="Better way to jump folders";    USAGE[9]="z foldername"
TOOLS[10]="bat";       DESC[10]="Cat but with colors";          USAGE[10]="bat filename.py"
TOOLS[11]="eza";       DESC[11]="Modern ls replacement";        USAGE[11]="ls -a"
TOOLS[12]="fzf";       DESC[12]="Quick file finder";            USAGE[12]="fzf"
TOOLS[13]="proot-distro"; DESC[13]="Run Linux distros";         USAGE[13]="proot-distro login ubuntu"
TOOLS[14]="tmate";     DESC[14]="Share your terminal screen";   USAGE[14]="tmate"
TOOLS[15]="ffmpeg";    DESC[15]="Convert videos and audio";     USAGE[15]="ffmpeg -i in.mp4 out.mp3"
TOOLS[16]="jq";        DESC[16]="Read and format JSON files";   USAGE[16]="cat data.json | jq"
TOOLS[17]="micro";     DESC[17]="A better terminal editor";     USAGE[17]="micro file.txt"
TOOLS[18]="httpie";    DESC[18]="Better way to test APIs";      USAGE[18]="http google.com"
TOOLS[19]="ncdu";      DESC[19]="See what's taking up space";   USAGE[19]="ncdu /"
TOOLS[20]="neofetch";  DESC[20]="Check your system info";       USAGE[20]="neofetch"
TOOLS[21]="cmatrix";   DESC[21]="The classic matrix rain";      USAGE[21]="cmatrix"
TOOLS[22]="sl";        DESC[22]="Just a steam locomotive";      USAGE[22]="sl"
TOOLS[23]="figlet";    DESC[23]="Big ASCII text banners";       USAGE[23]="figlet Hello"
TOOLS[24]="toilet";    DESC[24]="Banners with colors";          USAGE[24]="toilet -f mono12 -F gay Hi"
TOOLS[25]="termux-api"; DESC[25]="Control phone hardware";      USAGE[25]="termux-battery-status"
TOOLS[26]="python";    DESC[26]="The full Python 3 setup";      USAGE[26]="python3"
TOOLS[27]="nodejs";    DESC[27]="NodeJS for javascript";        USAGE[27]="node index.js"
TOOLS[28]="golang";    DESC[28]="Go language environment";      USAGE[28]="go run main.go"
TOOLS[29]="ruby";      DESC[29]="Ruby language environment";    USAGE[29]="irb"
TOOLS[30]="php";       DESC[30]="PHP for web development";      USAGE[30]="php -S localhost:8080"

OPTS=()
for i in {1..30}; do
    OPTS+=("$i" "${TOOLS[$i]} : ${DESC[$i]}" "off")
done

exec 3>&1
CHOICES=$(dialog --clear \
                 --backtitle "Worthiit Toolkit" \
                 --title "The Arsenal" \
                 --ok-label "Install" \
                 --cancel-label "Exit" \
                 --checklist "Space to check, Enter to start:" \
                 22 76 16 \
                 "${OPTS[@]}" \
                 2>&1 1>&3)
EXIT_CODE=$?
exec 3>&-

rm -f ~/.dialogrc

if [ $EXIT_CODE -ne 0 ]; then
    clear
    echo -e "\033[1;31mAlright, maybe next time.\033[0m"
    exit 0
fi

clear
if [ -z "$CHOICES" ]; then
    echo -e "\033[1;33mYou didn't pick anything to install.\033[0m"
    exit 0
fi

echo -e "\033[1;36m>>> Starting the setup for your picks...\033[0m"

for id in $CHOICES; do
    id=$(echo $id | tr -d '"')
    TOOL=${TOOLS[$id]}
    echo -e "\n\033[1;35m[+] Working on: $TOOL\033[0m"
    
    case $TOOL in
        "yt-dlp")
            pip install yt-dlp
            ;;
        "blackbird")
            pip install blackbird-osint
            ;;
        "sherlock")
            if [ ! -d "sherlock" ]; then
                git clone https://github.com/sherlock-project/sherlock.git
                cd sherlock && python3 -m pip install -r requirements.txt && cd ..
            else
                echo "Sherlock is already here."
            fi
            ;;
        "sqlmap")
             if [ ! -d "sqlmap-dev" ]; then
                git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
            else
                echo "SQLMap is already here."
            fi
            ;;
        "metasploit")
            pkg install unstable-repo -y
            pkg install metasploit -y
            ;;
        *)
            pkg install -y "$TOOL"
            ;;
    esac
done

echo -e "\n\033[1;32mEverything is set up. Here is how to use them:\033[0m"
echo -e "\033[1;30m--------------------------------------------------\033[0m"
for id in $CHOICES; do
    id=$(echo $id | tr -d '"')
    printf "\033[1;36m%-15s\033[0m : \033[0;37m%s\033[0m\n" "${TOOLS[$id]}" "${USAGE[$id]}"
done
echo -e "\033[1;30m--------------------------------------------------\033[0m\n"
