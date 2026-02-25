#!/data/data/com.termux/files/usr/bin/bash

if ! command -v dialog &> /dev/null; then
    echo -e "\033[1;33m[!] Installing UI dependencies...\033[0m"
    pkg install -y dialog >/dev/null 2>&1
fi

pkg install -y tur-repo x11-repo root-repo python git wget curl >/dev/null 2>&1

declare -A TOOLS
declare -A DESC
declare -A CMD
declare -A USAGE

TOOLS[1]="apktool";    DESC[1]="Rev-Engineer Android APKs";     USAGE[1]="apktool d app.apk"
TOOLS[2]="lazygit";    DESC[2]="Simple terminal Git UI";        USAGE[2]="lazygit"
TOOLS[3]="yt-dlp";     DESC[3]="Video Downloader (Pip)";        USAGE[3]="yt-dlp <url>"
TOOLS[4]="nmap";       DESC[4]="Network Scanner/Mapper";        USAGE[4]="nmap -sV google.com"
TOOLS[5]="sqlmap";     DESC[5]="SQL Injection Tool (Git)";      USAGE[5]="python sqlmap.py -u <url>"
TOOLS[6]="metasploit"; DESC[6]="Pen-testing Framework";         USAGE[6]="msfconsole"
TOOLS[7]="sherlock";   DESC[7]="Social Media Hunter (Git)";     USAGE[7]="python sherlock.py user"
TOOLS[8]="blackbird";  DESC[8]="OSINT Username Search (Pip)";   USAGE[8]="blackbird -u user"
TOOLS[9]="zoxide";     DESC[9]="Smarter 'cd' command";          USAGE[9]="z foldername"
TOOLS[10]="bat";       DESC[10]="Cat clone with colors";        USAGE[10]="bat filename.py"
TOOLS[11]="eza";       DESC[11]="Modern 'ls' replacement";      USAGE[11]="ls -a"
TOOLS[12]="fzf";       DESC[12]="Fuzzy Finder";                 USAGE[12]="fzf"
TOOLS[13]="proot-distro"; DESC[13]="Install Linux Distros";     USAGE[13]="proot-distro login ubuntu"
TOOLS[14]="tmate";     DESC[14]="Share Terminal Session";       USAGE[14]="tmate"
TOOLS[15]="ffmpeg";    DESC[15]="Media Converter";              USAGE[15]="ffmpeg -i in.mp4 out.mp3"
TOOLS[16]="jq";        DESC[16]="JSON Processor";               USAGE[16]="cat data.json | jq"
TOOLS[17]="micro";     DESC[17]="Easy Terminal Editor";         USAGE[17]="micro file.txt"
TOOLS[18]="httpie";    DESC[18]="Modern Curl Alternative";      USAGE[18]="http google.com"
TOOLS[19]="ncdu";      DESC[19]="Disk Usage Analyzer";          USAGE[19]="ncdu /"
TOOLS[20]="neofetch";  DESC[20]="Classic System Info";          USAGE[20]="neofetch"
TOOLS[21]="cmatrix";   DESC[21]="Matrix Rain Effect";           USAGE[21]="cmatrix"
TOOLS[22]="sl";        DESC[22]="Steam Locomotive (Fun)";       USAGE[22]="sl"
TOOLS[23]="figlet";    DESC[23]="ASCII Text Banner";            USAGE[23]="figlet Hello"
TOOLS[24]="toilet";    DESC[24]="Colorful Text Banner";         USAGE[24]="toilet -f mono12 -F gay Hi"
TOOLS[25]="termux-api"; DESC[25]="Access Hardware APIs";        USAGE[25]="termux-battery-status"
TOOLS[26]="python";    DESC[26]="Python 3 Environment";         USAGE[26]="python3"
TOOLS[27]="nodejs";    DESC[27]="NodeJS Environment";           USAGE[27]="node index.js"
TOOLS[28]="golang";    DESC[28]="Go Language Environment";      USAGE[28]="go run main.go"
TOOLS[29]="ruby";      DESC[29]="Ruby Language Environment";    USAGE[29]="irb"
TOOLS[30]="php";       DESC[30]="PHP Language Environment";     USAGE[30]="php -S localhost:8080"

OPTS=()
for i in {1..30}; do
    OPTS+=("$i" "${TOOLS[$i]} : ${DESC[$i]}" "off")
done

exec 3>&1
CHOICES=$(dialog --clear \
                 --backtitle "REINHART PROTOCOLS" \
                 --title "NINJA ARSENAL" \
                 --checklist "Select weapons to equip:" \
                 22 76 16 \
                 "${OPTS[@]}" \
                 2>&1 1>&3)
EXIT_CODE=$?
exec 3>&-

if[ $EXIT_CODE -ne 0 ] || [ -z "$CHOICES" ]; then
    clear
    echo -e "\033[1;31m[!] Mission Aborted.\033[0m"
    exit 0
fi

clear
echo -e "\033[1;36m>>> INITIATING DEPLOYMENT SEQUENCE...\033[0m"

CHOICES_CLEAN=$(echo "$CHOICES" | tr -d '"')

for id in $CHOICES_CLEAN; do
    TOOL=${TOOLS[$id]}
    echo -e "\n\033[1;35m[+] TARGET: $TOOL\033[0m"
    
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
                cd sherlock
                python3 -m pip install -r requirements.txt
                cd ..
            else
                echo "Sherlock already cloned."
            fi
            ;;
        "sqlmap")
             if [ ! -d "sqlmap" ]; then
                git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
            else
                echo "SQLMap already cloned."
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

echo -e "\n\033[1;32m>>> ARSENAL UPDATED. INTEL ACQUIRED:\033[0m"
echo -e "\033[1;30m--------------------------------------------------\033[0m"
for id in $CHOICES_CLEAN; do
    printf "\033[1;36m%-15s\033[0m : \033[0;37m%s\033[0m\n" "${TOOLS[$id]}" "${USAGE[$id]}"
done
echo -e "\033[1;30m--------------------------------------------------\033[0m\n"
