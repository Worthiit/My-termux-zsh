# My-termux-zsh

I was tired of manually installing Zsh, fonts, themes, and plugins every time I reset Termux. I wanted a "Ducking" setup that installs everything in one command. ( it's for personal use but if you like ,you can also use it )

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
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Worthiit/My-termux-zsh/main/Myzsh.sh)"
```

## Features & my Shortcuts

| Command | Action |
| :--- | :--- |
| `up` | Update & Upgrade System |
| `setlook` | Change Fonts instantly |
| `setstyle`| Change Color Scheme |
| `setprompt`| Configure the Zsh prompt style |
| `runclip` | Run Python script directly from Clipboard |
| `copyclip` | Copy file content to Clipboard |
| `reveal` | Show hidden IP details |
| `g` / `gp` / `gl` | Git, Git Push, Git Pull |
| `texpo` | Backup Tmux to Downloads |
| `..` | Go back one folder |


### Summary of Changes ( i mean i just updated again cuz old one sucks )

1.  `motd.sh` now uses `dpkg` instead of `pkg`. It will load instantly.
2.  **Async:** `.zshrc` now uses `wait"0"` for heavy plugins, so the prompt appears faster
3.  **Style:** Added `setlook` command. Type it to change fonts anytime, now don't tell me that you could do it with Termux setting too ik that buddy
4. **Private:** Made all my other repos private cuz yeah it was necessary 



## Credits
This script is mine which is a simple code/commands, there is no need to even take credit BUT
The font (`setlook`) and color (`setstyle`) management scripts are modified versions of tools (termux-nf & termux-colors) originally created by **Md arif** ( ig yes )

- Original Project: [termux-desktop](https://github.com/sabamdarif/termux-desktop)
- Author: [sabamdarif](https://github.com/sabamdarif)

Respect to the open-source community.

