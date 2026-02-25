#!/data/data/com.termux/files/usr/bin/bash

C_GRN='\033[1;32m'
C_CYN='\033[1;36m'
C_RST='\033[0m'

clear
echo -e "\n${C_CYN}>>> MYZSH INSTALLER // INITIALIZING.${C_RST}\n"

pkg update -y -o Dpkg::Options::="--force-confnew" >/dev/null 2>&1
pkg upgrade -y -o Dpkg::Options::="--force-confnew" >/dev/null 2>&1
pkg install -y -o Dpkg::Options::="--force-confnew" \
    zsh git gh curl wget termux-api ncurses-utils make \
    clang tar bat grep eza fzf openssl python jq fontconfig \
    zoxide fd ripgrep neovim dialog fastfetch >/dev/null 2>&1

echo -e "${C_GRN}[✔] Dependencies locked.${C_RST}"

mkdir -p ~/.termux ~/.config/fastfetch
touch ~/.hushlogin
echo -n > $PREFIX/etc/motd
echo "Reinhart" > ~/.termux_user

REPO_USER="Worthiit"
REPO_NAME="My-termux-zsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"

curl -fsSL "$BASE_URL/.zshrc" -o ~/.zshrc
curl -fsSL "$BASE_URL/.zshenv" -o ~/.zshenv
curl -fsSL "$BASE_URL/.nanorc" -o ~/.nanorc
curl -fsSL "$BASE_URL/.p10k.zsh" -o ~/.p10k.zsh
curl -fsSL "$BASE_URL/motd.sh" -o ~/motd.sh
curl -fsSL "$BASE_URL/gettools.sh" -o ~/gettools.sh
curl -fsSL "$BASE_URL/termux.properties" -o ~/.termux/termux.properties
curl -fsSL "$BASE_URL/colors.properties" -o ~/.termux/colors.properties
curl -fsSL "$BASE_URL/config.jsonc" -o ~/.config/fastfetch/config.jsonc

curl -fsSL "https://raw.githubusercontent.com/sabamdarif/termux-desktop/main/other/termux-nf" -o $PREFIX/bin/termux-nf
curl -fsSL "https://raw.githubusercontent.com/sabamdarif/termux-desktop/main/other/termux-color" -o $PREFIX/bin/termux-color

chmod +x ~/motd.sh ~/gettools.sh $PREFIX/bin/termux-nf $PREFIX/bin/termux-color

echo -e "${C_GRN}[✔] Configs injected.${C_RST}"

curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf >/dev/null 2>&1
termux-reload-settings

rm -f ~/.bashrc
chsh -s zsh

echo -e "\n${C_GRN}>>> SETUP COMPLETE. RESTART TERMUX TO INITIALIZE.${C_RST}\n"
