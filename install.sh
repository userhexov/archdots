#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Arch Linux Dotfiles Installer ===${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install package
install_package() {
    if ! command_exists "$1"; then
        echo -e "${YELLOW}Устанавливаем $1...${NC}"
        sudo pacman -S --noconfirm "$2"
    else
        echo -e "${GREEN}$1 уже установлен${NC}"
    fi
}

# Function to install AUR package
install_aur_package() {
    if ! command_exists "$1"; then
        echo -e "${YELLOW}Устанавливаем $1 из AUR...${NC}"
        if command_exists yay; then
            yay -S --noconfirm "$2"
        elif command_exists paru; then
            paru -S --noconfirm "$2"
        else
            echo -e "${RED}Ошибка: Не найден AUR helper (yay или paru)${NC}"
            echo "Установите yay или paru вручную:"
            echo "git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
            exit 1
        fi
    else
        echo -e "${GREEN}$1 уже установлен${NC}"
    fi
}

# Update system
echo -e "${BLUE}Обновляем систему...${NC}"
sudo pacman -Syu --noconfirm

# Install essential packages
echo -e "${BLUE}Устанавливаем основные пакеты...${NC}"

# Hyprland compositor
install_package hyprland hyprland

# Terminal
install_package kitty kitty

# Shell
install_package zsh zsh
install_package curl curl  # для oh-my-zsh

# Wayland essentials
install_package waybar waybar
install_package fuzzel fuzzel
install_package wofi wofi  # альтернатива fuzzel

# Utilities
install_package fastfetch fastfetch
install_package htop htop
install_package neofetch neofetch

# File manager
install_package thunar thunar

# Network manager
install_package networkmanager networkmanager
install_package network-manager-applet network-manager-applet

# Audio
install_package pulseaudio pulseaudio
install_package pulseaudio-alsa pulseaudio-alsa
install_package pavucontrol pavucontrol

# Fonts
install_package ttf-font-awesome ttf-font-awesome
install_package ttf-jetbrains-mono ttf-jetbrains-mono
install_package noto-fonts noto-fonts
install_package noto-fonts-emoji noto-fonts-emoji

# AUR packages (если нужны)
echo -e "${BLUE}Проверяем AUR пакеты...${NC}"

# Spotify-tui (spotify клиент в терминале)
if ! command_exists spt; then
    install_aur_package spt spotify-tui
fi

# Spicetify (кастомизация Spotify)
if [ ! -d ~/.spicetify ]; then
    install_aur_package spicetify-cli spicetify-cli
fi

# Install AUR helper if not exists
if ! command_exists yay && ! command_exists paru; then
    echo -e "${YELLOW}Устанавливаем yay (AUR helper)...${NC}"
    sudo pacman -S --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
fi

# Install Oh My Zsh if not installed
if [ ! -d ~/.oh-my-zsh ]; then
    echo -e "${YELLOW}Устанавливаем Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Install zsh plugins
    echo -e "${YELLOW}Устанавливаем zsh плагины...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

# Copy config files
echo -e "${BLUE}Копируем конфигурационные файлы...${NC}"

# Создаем папки если их нет
mkdir -p ~/.config/hypr ~/.config/hyprpaper ~/.config/waybar ~/.config/kitty ~/.config/fuzzel ~/.config/fastfetch

# Копируем конфиги
cp -r hyprland/* ~/.config/hypr/
cp -r hyprpaper/* ~/.config/hyprpaper/
cp -r waybar/* ~/.config/waybar/
cp -r kitty/* ~/.config/kitty/
cp -r fuzzel/* ~/.config/fuzzel/
cp fastfetch/config.conf ~/.config/fastfetch/ 2>/dev/null || true
cp zsh/.zshrc ~/

# Make scripts executable
chmod +x ~/.config/hypr/*.sh 2>/dev/null || true

# Set zsh as default shell
if [ "$SHELL" != "/bin/zsh" ]; then
    echo -e "${YELLOW}Устанавливаем zsh как оболочку по умолчанию...${NC}"
    chsh -s $(which zsh)
fi

# Enable NetworkManager
echo -e "${YELLOW}Включаем NetworkManager...${NC}"
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# Final messages
echo -e "${GREEN}=== Установка завершена! ===${NC}"
echo -e "${YELLOW}Что сделать дальше:${NC}"
echo "1. Перезапустите терминал или выполните: source ~/.zshrc"
echo "2. Перезайдите в систему и выберите Hyprland в дисплейном менеджере"
echo "3. Настройте обои: hyprpaper"
echo "4. Проверьте аудио: pavucontrol"
echo ""
echo -e "${BLUE}Для применения обоев создайте файл ~/.config/hypr/hyprpaper.conf${NC}"
echo "Пример содержимого:"
echo "preload = ~/Pictures/wallpaper.jpg"
echo "wallpaper = ,~/Pictures/wallpaper.jpg"

# Create example hyprpaper config if not exists
if [ ! -f ~/.config/hypr/hyprpaper.conf ]; then
    echo -e "${YELLOW}Создаем пример конфига hyprpaper...${NC}"
    cat > ~/.config/hypr/hyprpaper.conf << EOF
preload = ~/Pictures/wallpaper.jpg
wallpaper = ,~/Pictures/wallpaper.jpg
EOF
    mkdir -p ~/Pictures
    echo -e "${YELLOW}Добавьте свои обои в ~/Pictures/wallpaper.jpg${NC}"
fi
