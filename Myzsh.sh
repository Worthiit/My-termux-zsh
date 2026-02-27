#!/data/data/com.termux/files/usr/bin/bash

C_GRN='\033[1;32m'
C_CYN='\033[1;36m'
C_RST='\033[0m'

clear
echo -e "\n${C_CYN}>>> MYZSH INSTALLER // Grab a coffee while I'm Installing.${C_RST}\n"

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

echo -e "\n${C_CYN}[+] Setting defaults...${C_RST}"
curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf >/dev/null 2>&1

cat << 'EOF' > ~/.termux/current_art.txt
        __
        / /\
       / /  \
      / /    \__________
     / /      \        /\
    /_/        \      / /
 ___\ \      ___\____/_/_
/____\ \    /___________/\
\     \ \   \           \ \
 \     \ \   \____       \ \
  \     \ \  /   /\       \ \
   \   / \_\/   / /        \ \
    \ /        / /__________\/
     /        / /     /
    /        / /     /
   /________/ /\    /
   \________\/\ \  /
               \_\/
EOF

cp ~/.termux/current_art.txt ~/.termux/ascii/default.txt

termux-reload-settings

rm -f ~/.bashrc
chsh -s zsh

echo -e "\n${C_GRN}>>> SETUP COMPLETE. RESTART TERMUX NOW.${C_RST}\n"

termux-setup-storage
exit 0
