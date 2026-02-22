#!/data/data/com.termux/files/usr/bin/bash

C_GRN='\033[1;32m'
C_CYN='\033[1;36m'
C_RST='\033[0m'

clear
echo -e "\n${C_CYN}>>> ONE MORE TIME. SQUASHING BUGS.${C_RST}\n"

dpkg --configure -a
pkg update -y -o Dpkg::Options::="--force-confnew"
pkg install -y -o Dpkg::Options::="--force-confnew" zsh git jq curl wget termux-api ncurses-utils make clang tar bat grep eza fzf openssl python fontconfig

mkdir -p ~/.termux ~/.config/neofetch

REPO_USER="Worthiit"
REPO_NAME="My-termux-zsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"

curl -L "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -o ~/.termux/font.ttf
curl -fL "$BASE_URL/.zshrc" -o ~/.zshrc
curl -fL "$BASE_URL/.p10k.zsh" -o ~/.p10k.zsh
curl -fL "$BASE_URL/motd.sh" -o ~/motd.sh
chmod +x ~/motd.sh

curl -fL "$BASE_URL/termux-nf" -o $PREFIX/bin/termux-nf
curl -fL "$BASE_URL/termux-color" -o $PREFIX/bin/termux-color
chmod +x $PREFIX/bin/termux-nf $PREFIX/bin/termux-color

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
rm -f ~/.bashrc

echo -e "\n${C_GRN}>>> REINHART PROTOCOL ACTIVE. GO.${C_RST}"

chsh -s zsh
exec zsh -l
