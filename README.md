# 🌑 Slate Minimalist Sway / SwayFX Dotfiles

A clean, aesthetic, and distraction-free dark desktop configuration for **Sway / SwayFX** on Wayland.

---

## ✨ Features

- **Window Manager**: [SwayFX](https://github.com/WillPower3309/swayfx) with smooth rounded corners (`16px`), drop shadows, and subtle gaps (`5px inner / 6px outer`).
- **Status Bar**: Clean, floating, transparent **Waybar** with graphite pill modules and perfectly centered status indicators.
- **Application Launcher**: Minimalist dark **Fuzzel** app runner styled to match the dark slate aesthetic.
- **Terminal**: Modern, high-performance **Kitty** terminal with clean slate monochrome color palette.
- **Lockscreen**: **Swaylock-effects** with 7x5 wallpaper blur, date/clock typography, and clean feedback ring.
- **Power Menu**: Fast dark modal **wlogout** for Lock, Suspend, Logout, Reboot, and Shutdown.
- **Icons**: Custom **Adwaita-Slate** dark graphite folder icons with crisp white glyph emblems.
- **Fonts**: **Inter** variable typography for ultra-crisp UI rendering.
- **Wallpapers**: Curated minimalist Arch & Graphite dark wave wallpapers.

---

## 📦 Required & Recommended Packages (Arch Linux)

Install the recommended packages via `pacman` and `yay`/`paru`:

```bash
# Core desktop packages
sudo pacman -S sway waybar kitty fuzzel swaybg swaync wlogout \
               thunar thunar-archive-plugin btop fastfetch \
               grim slurp wl-clipboard brightnessctl pamixer

# SwayFX (for rounded corners & window shadows) and Swaylock-effects
# Install swayfx if not already installed:
sudo pacman -S swayfx swaylock-effects
# Or via AUR if needed:
# yay -S swayfx swaylock-effects-git
```

---

## 🚀 Easy Installation

1. Clone or extract this folder to your machine.
2. Open a terminal inside this directory and run the automated installer:

```bash
chmod +x install.sh
./install.sh
```

### What `install.sh` does:
1. Automatically creates a timestamped backup of your existing configs in `~/.config/dotfiles_backup_<timestamp>`.
2. Copies all configuration files to `~/.config/`.
3. Copies all wallpapers to `~/Pictures/Wallpapers/`.
4. Copies the `Adwaita-Slate` custom dark icon theme to `~/.local/share/icons/` and rebuilds the icon cache.
5. Copies the `Inter` font family to `~/.local/share/fonts/` and refreshes the font cache.
6. Sets GTK theme to `Adwaita-dark`, icon theme to `Adwaita-Slate`, and enables dark mode preferences.
7. Reloads Sway live if a session is currently active.

---

## ⌨️ Keybindings Cheatsheet

| Keybinding | Action |
| :--- | :--- |
| `Super + T` | Open Terminal (Kitty) |
| `Super + D` | Application Launcher (Fuzzel) |
| `Super + E` | File Manager (Thunar) |
| `Super + X` | Lock Screen (Swaylock) |
| `Super + Shift + X` | Power Menu (wlogout) |
| `Super + Shift + Q` | Close Active Window |
| `Super + Space` | Toggle Floating Window |
| `Super + F` | Toggle Fullscreen |
| `Super + Shift + Space` | Swap Focus between Tiling & Floating |
| `Super + [1 - 9]` | Switch to Workspace 1 - 9 |
| `Super + Shift + [1 - 9]` | Move Window to Workspace 1 - 9 |
| `Super + Shift + C` | Reload Sway Configuration |
| `Print` | Interactive Screenshot (`grim` + `slurp`) |

---

## 📂 Directory Structure

```text
dotfiles/
├── .config/
│   ├── sway/             # SwayFX window manager configuration & scripts
│   ├── waybar/           # Floating transparent Waybar config, style & icons
│   ├── kitty/            # Terminal theme & settings
│   ├── fuzzel/           # Minimalist app launcher styling
│   ├── swaylock/         # Blurred lockscreen config
│   ├── swaync/           # Notification center dark theme
│   ├── wlogout/          # Glassmorphic power menu
│   ├── gtk-3.0/          # GTK3 dark theme & CSS tweaks
│   ├── gtk-4.0/          # GTK4 dark theme & CSS tweaks
│   ├── btop/             # System monitor dark configuration
│   └── fastfetch/        # Minimal system fetch display
├── wallpapers/           # High-resolution slate & graphite wallpapers
├── icons/                # Adwaita-Slate custom icon theme
├── fonts/                # Inter variable font files
├── install.sh            # One-click installation & backup script
└── README.md             # Documentation & guide
```
