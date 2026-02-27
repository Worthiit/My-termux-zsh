# My-termux-zsh



I was tired of manually installing Zsh, fonts, themes, and plugins every time I reset Termux. I wanted a "Ducking" setup that installs everything in one command without covering storage with Termux desktop. ( it's for personal use but if you like ,you can also use it )

So I built this.

**It Includes:**
- **Zsh + Zinit** (The brain/cool-shi)
- **Powerlevel10k** (The look)
- **Meslo Nerd Font** (The icons)
- **Zinit Plugin Manager** (The speed)
- **Simple Dashboard** (Custom MOTD with live system stats)
- **Auto-Suggestions & Syntax Highlighting** (The cheat codes)
- **Font, Color & Prompt Switchers** (For customization)
- 
## Installation

One line command cuz why not ?

```bash
curl -fsSL https://raw.githubusercontent.com/Worthiit/My-termux-zsh/main/Myzsh.sh -o setup.sh && bash setup.sh
```

## Features & my Shortcuts

| Command | Action |
| :--- | :--- |
| `up` | Update & Upgrade System |
| `ninja` | Open the Tool Arsenal (Install 30+ Tools) |
| kawai | [NEW] Open the ASCII Art Selector (fzf-powered) |
| `setbg` | Set custom background image from storage , still incomplete |
| `setname` | Change the username shown in the welcome screen |
| `setlook` | Change Fonts instantly |
| `setstyle`| Change Color Scheme |
| `setprompt`| Configure the Zsh prompt style |
| `runclip` | Run Python script directly from Clipboard |
| `copyclip` | Copy file content to Clipboard |
| `reveal` | Show hidden IP details |
| `g` / `gp` / `gl` | Git, Git Push, Git Pull |
| `texpo` | Backup Tmux to Downloads |
| `..` | Go back one folder |

### 🛠 The Arsenal (Tool Manager , still incomplete)
I built a CLI interface to let you instantly bulk-install 30+ God-Tier Termux tools (like `apktool`, `lazygit`, `tmate`, `nmap`, etc.) without typing `pkg install` over and over.

Type this to open the menu:
```bash
ninja
```
It installs what you pick and spits out a cheat sheet on how to use them immediately.( still incomplete )

### The ASCII System (Kawai)
I moved away from hardcoded art of motd to a different path ,Now you can hot-swap your MOTD visuals.
 * Art Location: ~/.termux/ascii/
 * Adding Art: Drop any .txt file into that folder.
 * Execution: Type kawai and use arrow keys to preview. Hit Enter to swap the ARCII In MOTD.
  

###  Automated System Tricks
I automated the annoying manual stuff in `.zshrc`.
- **Auto-LS:** Just `cd` into a directory, and it will automatically list all files visually using `eza`.
- **`mkcd <folder>`:** Creates a folder and instantly jumps into it.
- **`extract <file>`:** won't needa remember flags anymore , drop any `.tar.gz`, `.zip`, `.rar`, or `.bz2` into it, and it will figure out the right command to extract it automatically ( hope so )

### Summary of Changes ( i mean i just updated again cuz old one sucks )

1.  `motd.sh` now uses `dpkg` instead of `pkg`. It will load instantly.
2.  **Async:** `.zshrc` now uses `wait"0"` for heavy plugins, so the prompt appears faster
3.  **Style:** Added `setlook` command. Type it to change fonts anytime, now don't tell me that you could do it with Termux setting too ik that buddy
4. **Private:** Made all my other repos private cuz yeah it was necessary
5. **Mess:**  i made a mess while trying to make it better 

## Credits
This script is mine which is a simple code/commands, there is no need to even take credit BUT
The font (`setlook`) and color (`setstyle`) management scripts are modified versions of tools (termux-nf & termux-colors) originally created by **Md arif** ( ig yes ) 

- Original Project: [termux-desktop](https://github.com/sabamdarif/termux-desktop)
- Author: [sabamdarif](https://github.com/sabamdarif)

Respect to the open-source community.

