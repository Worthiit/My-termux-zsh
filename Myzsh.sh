#!/data/data/com.termux/files/usr/bin/bash

C_GRN='\033[1;32m'
C_CYN='\033[1;36m'
C_RED='\033[1;31m'
C_RST='\033[0m'

clear
echo -e "\n${C_CYN}>>> MYZSH INSTALLER // Grab a coffee while I'm installing.${C_RST}\n"

echo -e "${C_CYN}[+] Updating system...${C_RST}"
pkg update -y -o Dpkg::Options::="--force-confnew"
pkg upgrade -y -o Dpkg::Options::="--force-confnew"

echo -e "\n${C_CYN}[+] Installing core tools...${C_RST}"
pkg install -y -o Dpkg::Options::="--force-confnew" \
    zsh git gh curl wget termux-api ncurses-utils make \
    clang tar bat grep eza fzf openssl python jq fontconfig fontconfig-utils \
    zoxide fd ripgrep neovim dialog fastfetch unzip unrar

mkdir -p ~/.termux/ascii ~/.config/fastfetch
touch ~/.hushlogin
echo "Reinhart" > ~/.termux_user

REPO_USER="Worthiit"
REPO_NAME="My-termux-zsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"

echo -e "\n${C_CYN}[+] Downloading configurations...${C_RST}"
curl -fsSL "$BASE_URL/.zshrc" -o ~/.zshrc
curl -fsSL "$BASE_URL/.zshenv" -o ~/.zshenv
curl -fsSL "$BASE_URL/.nanorc" -o ~/.nanorc
curl -fsSL "$BASE_URL/.p10k.zsh" -o ~/.p10k.zsh
curl -fsSL "$BASE_URL/motd.sh" -o ~/motd.sh
curl -fsSL "$BASE_URL/ninja.sh" -o ~/ninja.sh
curl -fsSL "$BASE_URL/termux.properties" -o ~/.termux/termux.properties
curl -fsSL "$BASE_URL/colors.properties" -o ~/.termux/colors.properties
curl -fsSL "$BASE_URL/config.jsonc" -o ~/.config/fastfetch/config.jsonc

curl -fsSL "https://raw.githubusercontent.com/sabamdarif/termux-desktop/main/other/termux-nf" -o $PREFIX/bin/termux-nf
curl -fsSL "https://raw.githubusercontent.com/sabamdarif/termux-desktop/main/other/termux-color" -o $PREFIX/bin/termux-color
curl -fsSL "$BASE_URL/kawai" -o $PREFIX/bin/kawai

chmod +x ~/motd.sh ~/ninja.sh $PREFIX/bin/termux-nf $PREFIX/bin/termux-color $PREFIX/bin/kawai

echo -e "\n${C_CYN}[+] Syncing ASCII Arsenal...${C_RST}"
rm -rf ~/.temp_sync
git clone --depth 1 "https://github.com/$REPO_USER/$REPO_NAME.git" ~/.temp_sync >/dev/null 2>&1
if [ -d ~/.temp_sync/ascii ]; then
    cp -r ~/.temp_sync/ascii/* ~/.termux/ascii/
fi
rm -rf ~/.temp_sync

echo -e "\n${C_CYN}[+] Injecting Base Nerd Font...${C_RST}"
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf >/dev/null 2>&1

if [ -f ~/.termux/font.ttf ]; then
    fc-cache -fv >/dev/null 2>&1
    termux-reload-settings
    echo -e "${C_GRN}[✔] Font System Done bruh.${C_RST}"
else
    echo -e "${C_RED}[✘] Font Sync Failed.${C_RST}"
fi

if [ ! -f ~/.termux/current_art.txt ]; then
    if [ -f ~/.termux/ascii/default.txt ]; then
        cp ~/.termux/ascii/default.txt ~/.termux/current_art.txt
    else
        echo "Protocol Reinhart Active" > ~/.termux/current_art.txt
    fi
fi

echo -e "\n${C_CYN}[+] Cleaning cache...${C_RST}"
rm -rf ~/.fonts
rm -f ~/JetBrainsMono*
rm -f ~/README.md
rm -f ~/.bashrc
chsh -s zsh

echo -e "\n${C_GRN}>>> SETUP COMPLETE. RESTART TERMUX NOW ಥ⁠‿⁠ಥ.${C_RST}\n"
termux-setup-storage
exit 0
