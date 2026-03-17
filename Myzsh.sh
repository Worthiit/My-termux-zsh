#!/data/data/com.termux/files/usr/bin/bash

C_GRN='\033[1;32m'
C_CYN='\033[1;36m'
C_RED='\033[1;31m'
C_RST='\033[0m'

clear
echo -e "\n${C_CYN}>>> OK, LET'S SEE WHAT WE'RE WORKING WITH...${C_RST}\n"

if [ -d "/data/data/com.termux" ]; then
    IS_TERMUX=true
    PKGER="pkg"
    PYTHON_PKG="python"
    FD_PKG="fd"
    echo -e "${C_GRN}[+] Looks like native Termux. Nice.${C_RST}"
else
    IS_TERMUX=false
    PKGER="sudo apt"
    PYTHON_PKG="python3"
    FD_PKG="fd-find"
    echo -e "${C_CYN}[+] WOW Mate that's a Standard Linux environment . Swapping to apt...${C_RST}"
fi

echo -e "${C_CYN}[+] Getting the system up to date...${C_RST}"
$PKGER update -y
$PKGER upgrade -y

echo -e "\n${C_CYN}[+] Grabbing the essentials iykyk...${C_RST}"
$PKGER install -y \
    zsh git gh curl wget ncurses-utils make \
    clang tar bat grep eza fzf openssl $PYTHON_PKG jq fontconfig fontconfig-utils \
    zoxide $FD_PKG ripgrep neovim fastfetch unzip unrar ttyd iproute2 atuin dialog

if [ "$IS_TERMUX" = true ]; then
    pkg install -y termux-api
fi

mkdir -p ~/.termux/ascii ~/.config/fastfetch ~/.termux/icons
touch ~/.hushlogin
echo "Reinhart" > ~/.termux_user

REPO_USER="Worthiit"
REPO_NAME="My-termux-zsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"

echo -e "\n${C_CYN}[+] Pulling the configs...${C_RST}"
curl -fsSL "$BASE_URL/.zshrc" -o ~/.zshrc
curl -fsSL "$BASE_URL/.zshenv" -o ~/.zshenv
curl -fsSL "$BASE_URL/.nanorc" -o ~/.nanorc
curl -fsSL "$BASE_URL/.p10k.zsh" -o ~/.p10k.zsh
curl -fsSL "$BASE_URL/motd.sh" -o ~/motd.sh
curl -fsSL "$BASE_URL/ninja.sh" -o ~/ninja.sh
curl -fsSL "$BASE_URL/termux.properties" -o ~/.termux/termux.properties
curl -fsSL "$BASE_URL/colors.properties" -o ~/.termux/colors.properties
curl -fsSL "$BASE_URL/config.jsonc" -o ~/.config/fastfetch/config.jsonc

for bin in termux-nf seticon setframe setpill kawai beam warp peek scrub host amv ftext snatch tssh setrepo gfix; do
    curl -fsSL "$BASE_URL/$bin" -o "$PREFIX/bin/$bin"
    chmod +x "$PREFIX/bin/$bin"
done

if [ "$IS_TERMUX" = true ]; then
    curl -fsSL "https://raw.githubusercontent.com/sabamdarif/termux-desktop/main/other/termux-color" -o $PREFIX/bin/termux-color
    chmod +x $PREFIX/bin/termux-color
fi

chmod +x ~/motd.sh ~/ninja.sh

echo -e "\n${C_CYN}[+] Grabbing the ASCII art collection...${C_RST}"
rm -rf ~/.temp_sync
git clone --depth 1 "https://github.com/$REPO_USER/$REPO_NAME.git" ~/.temp_sync >/dev/null 2>&1
if [ -d ~/.temp_sync/ascii ]; then
    cp -r ~/.temp_sync/ascii/* ~/.termux/ascii/
fi
rm -rf ~/.temp_sync

if [ "$IS_TERMUX" = true ]; then
    echo -e "\n${C_CYN}[+] Fixing the font and icons...${C_RST}"
    echo -e "꩜\n༯\n❀\n⋆.𐙚\n𓇢𓆸\n𝜗ৎ\nᝰ.ᐟ" > ~/.termux/icons/list.txt
    bash $PREFIX/bin/termux-nf Meslo >/dev/null 2>&1
fi

echo -e "\n${C_CYN}[+] Tidying up...${C_RST}"
rm -f ~/setup.sh
chsh -s zsh

echo -e "\n${C_GRN}>>> EVERYTHING IS SET. RESTART TO SEE THE CHANGES.${C_RST}\n"
[ "$IS_TERMUX" = true ] && termux-setup-storage
exit 0
