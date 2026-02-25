#!/data/data/com.termux/files/usr/bin/bash

if ! command -v dialog &> /dev/null; then
    pkg install -y dialog >/dev/null 2>&1
fi

declare -A PKGS
declare -A USAGE

PKGS[1]="apktool"; USAGE[1]="apktool d app.apk"
PKGS[2]="lazygit"; USAGE[2]="lazygit"
PKGS[3]="jujutsu"; USAGE[3]="jj init"
PKGS[4]="tmate"; USAGE[4]="tmate"
PKGS[5]="yt-dlp"; USAGE[5]="yt-dlp <URL>"
PKGS[6]="ffmpeg"; USAGE[6]="ffmpeg -i in.mp4 out.mp3"
PKGS[7]="tmux"; USAGE[7]="tmux new -s dev"
PKGS[8]="nmap"; USAGE[8]="nmap -sV localhost"
PKGS[9]="proot-distro"; USAGE[9]="proot-distro install ubuntu"
PKGS[10]="ncdu"; USAGE[10]="ncdu /"
PKGS[11]="aria2"; USAGE[11]="aria2c <URL>"
PKGS[12]="htop"; USAGE[12]="htop"
PKGS[13]="fastfetch"; USAGE[13]="fastfetch"
PKGS[14]="imagemagick"; USAGE[14]="magick in.jpg out.png"
PKGS[15]="rclone"; USAGE[15]="rclone config"
PKGS[16]="jq"; USAGE[16]="cat file.json | jq"
PKGS[17]="yq"; USAGE[17]="yq e '.key' file.yaml"
PKGS[18]="socat"; USAGE[18]="socat TCP-LISTEN:8080 STDOUT"
PKGS[19]="tsu"; USAGE[19]="tsu"
PKGS[20]="ranger"; USAGE[20]="ranger"
PKGS[21]="termshark"; USAGE[21]="termshark -i wlan0"
PKGS[22]="tcpdump"; USAGE[22]="tcpdump -i any"
PKGS[23]="aapt"; USAGE[23]="aapt d badging app.apk"
PKGS[24]="apksigner"; USAGE[24]="apksigner sign --ks key.jks app.apk"
PKGS[25]="zstd"; USAGE[25]="zstd file.txt"
PKGS[26]="openssh"; USAGE[26]="sshd"
PKGS[27]="wget"; USAGE[27]="wget <URL>"
PKGS[28]="gh"; USAGE[28]="gh auth login"
PKGS[29]="termux-services"; USAGE[29]="sv up sshd"
PKGS[30]="micro"; USAGE[30]="micro file.txt"

exec 3>&1
CHOICES=$(dialog --clear --title "REINHART ARSENAL" --checklist "Select tools (Space to select, Enter to confirm):" 22 75 15 \
1 "apktool" off 2 "lazygit" off 3 "jujutsu" off 4 "tmate" off 5 "yt-dlp" off \
6 "ffmpeg" off 7 "tmux" off 8 "nmap" off 9 "proot-distro" off 10 "ncdu" off \
11 "aria2" off 12 "htop" off 13 "fastfetch" off 14 "imagemagick" off 15 "rclone" off \
16 "jq" off 17 "yq" off 18 "socat" off 19 "tsu" off 20 "ranger" off \
21 "termshark" off 22 "tcpdump" off 23 "aapt" off 24 "apksigner" off 25 "zstd" off \
26 "openssh" off 27 "wget" off 28 "gh" off 29 "termux-services" off 30 "micro" off \
2>&1 1>&3)
EXIT_CODE=$?
exec 3>&-

if [ $EXIT_CODE -ne 0 ] || [ -z "$CHOICES" ]; then
    clear
    exit 0
fi

clear
echo -e "\033[1;36m>>> UPDATING PACKAGE LIST...\033[0m\n"
pkg update -y

CHOICES_CLEAN=$(echo "$CHOICES" | tr -d '"')
for choice in $CHOICES_CLEAN; do
    pkg_name=${PKGS[$choice]}
    echo -e "\n\033[1;34m[+] INSTALLING: $pkg_name...\033[0m"
    
    if pkg install -y "$pkg_name"; then
        echo -e "\033[1;32m[✔] $pkg_name installed successfully.\033[0m"
    else
        echo -e "\033[1;31m[✘] Failed to install $pkg_name.\033[0m"
    fi
    sleep 1
done

echo -e "\n\033[1;32m>>> DEPLOYMENT COMPLETE. CHEAT SHEET:\033[0m\n"
for choice in $CHOICES_CLEAN; do
    printf "\033[1;35m%-15s\033[0m : \033[1;37m%s\033[0m\n" "${PKGS[$choice]}" "${USAGE[$choice]}"
done
echo ""
