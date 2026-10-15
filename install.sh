#!/usr/bin/env bash
# ==============================================================================
#  Slate Minimalist Sway / SwayFX Dotfiles Installer
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════════════════════════╗"
echo "  ║      Slate Minimalist Dark SwayFX Dotfiles Installer      ║"
echo "  ╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# 1. Dependency Check
echo -e "${BLUE}[*] Checking recommended packages...${NC}"
RECOMMENDED_PKGS=("sway" "waybar" "kitty" "fuzzel" "swaylock" "swaync" "wlogout" "swaybg" "grim" "slurp" "wl-clipboard")
MISSING_PKGS=()

for pkg in "${RECOMMENDED_PKGS[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}[!] Note: The following packages were not found in your PATH:${NC}"
    echo "    ${MISSING_PKGS[*]}"
    echo -e "${YELLOW}    On Arch Linux, you can install them with:${NC}"
    echo "    sudo pacman -S swayfx waybar kitty fuzzel swaylock-effects swaync wlogout swaybg grim slurp wl-clipboard"
    echo ""
fi

# 2. Backup existing configs
echo -e "${BLUE}[*] Backing up existing configurations to: ${BACKUP_DIR}${NC}"
mkdir -p "$BACKUP_DIR"
for item in sway waybar kitty fuzzel swaylock swaync wlogout gtk-3.0 gtk-4.0 fastfetch btop; do
    if [ -e "$HOME/.config/$item" ]; then
        cp -r "$HOME/.config/$item" "$BACKUP_DIR/"
    fi
done

# 3. Install Configs
echo -e "${BLUE}[*] Copying configuration files to ~/.config/...${NC}"
mkdir -p "$HOME/.config"
cp -r "$DOTFILES_DIR/.config/"* "$HOME/.config/"

# Fix any hardcoded paths in swaylock config for current user
if [ -f "$HOME/.config/swaylock/config" ]; then
    sed -i "s|/home/[^/]*/Pictures/Wallpapers|$HOME/Pictures/Wallpapers|g" "$HOME/.config/swaylock/config"
fi

# Make scripts executable
if [ -d "$HOME/.config/sway/scripts" ]; then
    chmod +x "$HOME/.config/sway/scripts/"*.sh
fi

# 4. Install Wallpapers
echo -e "${BLUE}[*] Installing wallpapers to ~/Pictures/Wallpapers/...${NC}"
mkdir -p "$HOME/Pictures/Wallpapers"
cp -r "$DOTFILES_DIR/wallpapers/"* "$HOME/Pictures/Wallpapers/"

# 5. Install Fonts
echo -e "${BLUE}[*] Installing fonts to ~/.local/share/fonts/...${NC}"
mkdir -p "$HOME/.local/share/fonts"
cp -r "$DOTFILES_DIR/fonts/"* "$HOME/.local/share/fonts/"
if command -v fc-cache &>/dev/null; then
    echo -e "    Updating font cache..."
    fc-cache -fv "$HOME/.local/share/fonts" >/dev/null 2>&1 || true
fi

# 6. Install Custom Icons
echo -e "${BLUE}[*] Installing custom icon theme (Adwaita-Slate) to ~/.local/share/icons/...${NC}"
mkdir -p "$HOME/.local/share/icons"
cp -r "$DOTFILES_DIR/icons/"* "$HOME/.local/share/icons/"
if command -v gtk-update-icon-cache &>/dev/null; then
    echo -e "    Updating icon cache..."
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons/Adwaita-Slate" >/dev/null 2>&1 || true
fi

# 7. Apply GTK & Desktop Theme Preferences
echo -e "${BLUE}[*] Applying GTK and interface theme settings...${NC}"
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita-Slate' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name 'Inter 10' 2>/dev/null || true
fi

# 8. Reload Sway (if active)
if [ -n "$SWAYSOCK" ] && command -v swaymsg &>/dev/null; then
    echo -e "${BLUE}[*] Sway session detected. Reloading Sway and Waybar...${NC}"
    swaymsg reload 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}✓ Setup completed successfully!${NC}"
echo -e "${CYAN}Keybindings Overview:${NC}"
echo "  • Super + T           : Launch Terminal (Kitty)"
echo "  • Super + D           : Application Launcher (Fuzzel)"
echo "  • Super + E           : File Manager (Thunar)"
echo "  • Super + X           : Lock Screen (Swaylock)"
echo "  • Super + Shift + X   : Power Menu (wlogout)"
echo "  • Super + Shift + Q   : Close Window"
echo ""
echo "Enjoy your clean, minimalist desktop!"
