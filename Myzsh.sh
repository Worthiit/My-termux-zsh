#!/data/data/com.termux/files/usr/bin/bash

C_GRN='\033[1;32m'
C_CYN='\033[1;36m'
C_RST='\033[0m'

bar() {
    echo -e "${C_GRN}[✔] $1${C_RST}"
}

clear
echo -e "\n${C_CYN}>>> MYZSH INSTALLER // GO GRAB A COFFEE, I'LL HANDLE THIS.${C_RST}\n"

echo -e "${C_CYN}>>> PHASE 1: SYSTEM PREP & DEPENDENCIES...${C_RST}"
pkg update -y -o Dpkg::Options::="--force-confnew"
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install -y -o Dpkg::Options::="--force-confnew" \
    zsh git gh curl wget termux-api ncurses-utils make \
    clang tar bat grep eza fzf openssl python jq fontconfig

bar "System is up to date and dependencies are locked in."

echo -e "\n${C_CYN}>>> PHASE 2: CONFIGURATION DEPLOYMENT...${C_RST}"
mkdir -p ~/.termux

REPO_USER="Worthiit"
REPO_NAME="My-termux-zsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"

curl -fsSL "$BASE_URL/.zshrc" -o ~/.zshrc
curl -fsSL "$BASE_URL/.p10k.zsh" -o ~/.p10k.zsh
curl -fsSL "$BASE_URL/motd.sh" -o ~/motd.sh
curl -fsSL "$BASE_URL/termux-nf" -o $PREFIX/bin/termux-nf
curl -fsSL "$BASE_URL/termux-color" -o $PREFIX/bin/termux-color
chmod +x ~/motd.sh $PREFIX/bin/termux-nf $PREFIX/bin/termux-color

bar "Reinhart configs pulled from your repo."

echo -e "\n${C_CYN}>>> PHASE 3: AESTHETICS...${C_RST}"
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
bar "Nerd Font and Cyberpunk color scheme injected."

echo -e "\n${C_CYN}>>> FINALIZING...${C_RST}"
rm -f ~/.bashrc
bar "Old junk purged."

echo -e "\n${C_GRN}>>> DONE. LET'S SEE WHAT WE'VE GOT.${C_RST}"
chsh -s zsh
zsh
