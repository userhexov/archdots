<div align="center">

# 🐧 Arch Linux Dotfiles

![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-4338CA?style=for-the-badge)
![Zsh](https://img.shields.io/badge/Shell-Zsh-1E8CBE?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Kitty](https://img.shields.io/badge/Terminal-Kitty-302D41?style=for-the-badge&logo=windowsterminal&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

> Элегантная, минималистичная и высокопроизводительная конфигурация Arch Linux с окружением Hyprland

</div>

## ✨ Особенности

<div class="feature-table">

| Компонент | Описание | Статус |
|-----------|----------|--------|
| **🪟 Hyprland** | Современный динамический тайловый композитор для Wayland | ✅ Работает |
| **🎨 Waybar** | Кастомная панель с модулями сети, звука, батареи и пр. | ✅ Работает |
| **🖼️ Hyprpaper** | Легковесный менеджер обоев | ✅ Работает |
| **🐱 Kitty** | GPU-ускоренный терминал с поддержкой тем | ✅ Работает |
| **🐚 Zsh** | Мощная оболочка с кастомным приглашением и плагинами | ✅ Работает |
| **🚀 Fastfetch** | Мгновенное отображение информации о системе | ✅ Работает |
| **🔍 Fuzzel** | Запускатель приложений в стиле Rofi для Wayland | ✅ Работает |
| **🎵 Spicetify** | Кастомизация Spotify с темами и расширениями | ✅ Работает |

</div>

## 🎨 Галерея

<div class="gallery-grid">

| Рабочий процесс | Терминал и приложения |
|-----------------|----------------------|
| ![Desktop](https://drive.google.com/file/d/1bc2qo2_s1OqPCFvzZrPApXOmD0j9Ykk7/view?usp=drivesdk/400x250/161616/FFFFFF/?text=Рабочий+стол) | ![Terminal](https://via.placeholder.com/400x250/161616/FFFFFF/?text=Терминал) |

| Настройки и утилиты | Мультимедиа |
|---------------------|-------------|
| ![Settings](https://via.placeholder.com/400x250/161616/FFFFFF/?text=Настройки) | ![Media](https://via.placeholder.com/400x250/161616/FFFFFF/?text=Музыка) |

</div>

## 📦 Предварительные требования

Перед установкой убедитесь, что у вас есть:

- **Arch Linux** (или производные, такие как EndeavourOS, Manjaro)
- **Базовая система** с установленными ядром и драйверами
- **Git** для клонирования репозитория
- **Пакетный менеджер** (pacman, yay, или paru)

## 🚀 Установка

### Автоматическая установка (рекомендуется)

```bash
# Клонируйте репозиторий
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles

# Перейдите в директорию
cd ~/.dotfiles

# Дайте права на выполнение скрипта
chmod +x install.sh

# Запустите скрипт установки
./install.sh