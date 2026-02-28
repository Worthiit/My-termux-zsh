#!/data/data/com.termux/files/usr/bin/bash

C_GRN='\033[1;32m'
C_CYN='\033[1;36m'
C_RED='\033[1;31m'
C_RST='\033[0m'

clear
echo -e "\n${C_CYN}>>> OK, LET'S GET THIS SET UP.${C_RST}\n"

echo -e "${C_CYN}[+] Refreshing the system...${C_RST}"
pkg update -y -o Dpkg::Options::="--force-confnew"
pkg upgrade -y -o Dpkg::Options::="--force-confnew"

echo -e "\n${C_CYN}[+] Grabbing the essentials...${C_RST}"
pkg install -y -o Dpkg::Options::="--force-confnew" \
    zsh git gh curl wget termux-api ncurses-utils make \
    clang tar bat grep eza fzf openssl python jq fontconfig fontconfig-utils \
    zoxide fd ripgrep neovim dialog fastfetch unzip unrar

mkdir -p ~/.termux/ascii ~/.config/fastfetch ~/.termux/icons
touch ~/.hushlogin
echo "Reinhart" > ~/.termux_user

REPO_USER="Worthiit"
REPO_NAME="My-termux-zsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"

echo -e "\n${C_CYN}[+] Pulling your configs from the repo...${C_RST}"
curl -fsSL "$BASE_URL/.zshrc" -o ~/.zshrc
curl -fsSL "$BASE_URL/.zshenv" -o ~/.zshenv
curl -fsSL "$BASE_URL/.nanorc" -o ~/.nanorc
curl -fsSL "$BASE_URL/.p10k.zsh" -o ~/.p10k.zsh
curl -fsSL "$BASE_URL/motd.sh" -o ~/motd.sh
curl -fsSL "$BASE_URL/ninja.sh" -o ~/ninja.sh
curl -fsSL "$BASE_URL/termux.properties" -o ~/.termux/termux.properties
curl -fsSL "$BASE_URL/colors.properties" -o ~/.termux/colors.properties
curl -fsSL "$BASE_URL/config.jsonc" -o ~/.config/fastfetch/config.jsonc

curl -fsSL "$BASE_URL/termux-nf" -o $PREFIX/bin/termux-nf
curl -fsSL "$BASE_URL/seticon" -o $PREFIX/bin/seticon
curl -fsSL "$BASE_URL/setframe" -o $PREFIX/bin/setframe
curl -fsSL "$BASE_URL/kawai" -o $PREFIX/bin/kawai
curl -fsSL "https://raw.githubusercontent.com/sabamdarif/termux-desktop/main/other/termux-color" -o $PREFIX/bin/termux-color

chmod +x ~/motd.sh ~/ninja.sh $PREFIX/bin/termux-nf $PREFIX/bin/termux-color $PREFIX/bin/kawai $PREFIX/bin/seticon $PREFIX/bin/setframe

echo -e "\n${C_CYN}[+] Syncing your ASCII art...${C_RST}"
rm -rf ~/.temp_sync
git clone --depth 1 "https://github.com/$REPO_USER/$REPO_NAME.git" ~/.temp_sync >/dev/null 2>&1
if [ -d ~/.temp_sync/ascii ]; then
    cp -r ~/.temp_sync/ascii/* ~/.termux/ascii/
fi
rm -rf ~/.temp_sync

echo -e "\n${C_CYN}[+] Fixing the font and icons...${C_RST}"
echo -e "꩜\n༯\n❀\n⋆.𐙚\n𓇢𓆸\n𝜗ৎ\nᝰ.ᐟ" > ~/.termux/icons/list.txt

bash $PREFIX/bin/termux-nf Meslo >/dev/null 2>&1

if [ -f ~/.termux/font.ttf ]; then
    echo -e "${C_GRN}[✔] Everything looks good. Icons should be visible now.${C_RST}"
else
    echo -e "${C_RED}[✘] Something went wrong with the font setup.${C_RST}"
fi

if [ ! -f ~/.termux/current_art.txt ]; then
    cp ~/.termux/ascii/default.txt ~/.termux/current_art.txt 2>/dev/null || echo "Welcome Reinhart" > ~/.termux/current_art.txt
fi

echo -e "\n${C_CYN}[+] Cleaning up...${C_RST}"
rm -f ~/setup.sh
rm -rf ~/.fonts
rm -f ~/JetBrainsMono*
rm -f ~/README.md
rm -f ~/.bashrc
chsh -s zsh

echo -e "\n${C_GRN}>>> ALL DONE. RESTART TERMUX TO SEE THE CHANGES.${C_RST}\n"
termux-setup-storage
exit 0
