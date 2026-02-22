# My-termux-zsh

I was tired of manually installing Zsh, fonts, themes, and plugins every time I reset Termux. I wanted a "God-Mode" setup that installs everything in one command.

So I built this.

**It Includes:**
- **Zsh + Oh-My-Zsh** (The brain)
- **Powerlevel10k** (The look)
- **Meslo Nerd Font** (The icons)
- **Zinit Plugin Manager** (The speed)
- **Reinhart Dashboard** (Custom MOTD with live system stats)
- **Auto-Suggestions & Syntax Highlighting** (The cheat codes)
- **Font & Color Switcher** (Type `setlook` to change style)

## Installation

One line. No questions asked.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Worthiit/My-termux-zsh/main/install.sh)"
```

## Features & Shortcuts

| Command | Action |
| :--- | :--- |
| `up` | Update & Upgrade System |
| `setlook` | Change Fonts & Colors instantly |
| `runclip` | Run Python script directly from Clipboard |
| `copyclip` | Copy file content to Clipboard |
| `reveal` | Show hidden IP details |
| `g` / `gp` / `gl` | Git, Git Push, Git Pull |
| `texpo` | Backup Tmux to Downloads |
| `..` | Go back one folder |



### Summary of Changes ( i mean i just updated again cuz old one sucks )

1.  **Speed:** `motd.sh` now uses `dpkg` instead of `pkg`. It will load instantly.
2.  **Async:** `.zshrc` now uses `wait"0"` for heavy plugins, so the prompt appears faster.
3.  **Style:** Added `setlook` command. Type it to change fonts anytime.
4.  **Docs:** Professional `README.md`.
