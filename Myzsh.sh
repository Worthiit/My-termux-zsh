#!/data/data/com.termux/files/usr/bin/bash

C_GRN='\033[1;32m'
C_CYN='\033[1;36m'
C_RST='\033[0m'

bar() {
    echo -ne "${C_CYN}[+] $1...${C_RST}\r"
    sleep 0.5
    echo -e "${C_GRN}[✔] $1${C_RST}"
}

clear
echo -e "\n${C_CYN}>>> MYZSH INSTALLER // RELAX, I'M ON IT.${C_RST}\n"

# 1. Update & Dependencies
bar "Updating Termux repositories"
pkg update -y >/dev/null 2>&1 && pkg upgrade -y >/dev/null 2>&1

bar "Grabbing necessary binaries (git, gh, zsh, tools)"
pkg install -y zsh git gh curl wget termux-api ncurses-utils make clang tar bat grep eza fzf openssl python >/dev/null 2>&1

# 2. Filesystem Setup
mkdir -p ~/.termux ~/.config/neofetch
bar "Setting up directories"

# 3. Fetch Configs from GitHub
REPO_USER="Worthiit"
REPO_NAME="My-termux-zsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"

bar "Downloading Meslo Nerd Font"
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf >/dev/null 2>&1

bar "Downloading Reinhart Configs (.zshrc, .p10k, motd)"
curl -fsSL "$BASE_URL/.zshrc" -o ~/.zshrc
curl -fsSL "$BASE_URL/.p10k.zsh" -o ~/.p10k.zsh
curl -fsSL "$BASE_URL/motd.sh" -o ~/motd.sh
chmod +x ~/motd.sh

# 4. Color Scheme
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

# 5. Cleanup & Switch cuz it's my zsh bruh
rm -f ~/.bashrc
bar "Cleaning up trash"

echo -e "\n${C_GRN}>>> DONE. SO NOW LET'S HAVE A LOOK AT THIS SHIt.${C_RST}"
chsh -s zsh
zsh
