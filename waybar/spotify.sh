#!/usr/bin/env bash

# Явно устанавливаем переменные окружения
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export DISPLAY=:0
export WAYLAND_DISPLAY=wayland-1

# Файл логов для диагностики
LOG_FILE="/tmp/waybar-spotify.log"
echo "$(date) - Скрипт запущен" > $LOG_FILE

# Проверяем, запущен ли Spotify
if ! pgrep -x "spotify" > /dev/null; then
    echo '{"text": " жду запуск спотифай", "class": "waiting", "tooltip": "Spotify не запущен"}' | tee -a $LOG_FILE
    exit 0
fi

# Получаем статус и метаданные
status=$(playerctl -p spotify status 2>&1 | tee -a $LOG_FILE)
artist=$(playerctl -p spotify metadata artist 2>&1 | tee -a $LOG_FILE)
title=$(playerctl -p spotify metadata title 2>&1 | tee -a $LOG_FILE)

echo "Статус: $status" >> $LOG_FILE
echo "Артист: $artist" >> $LOG_FILE
echo "Название: $title" >> $LOG_FILE

# Проверяем данные
if [[ -z "$status" || -z "$artist" || -z "$title" ]]; then
    echo '{"text": " ошибка данных", "class": "error", "tooltip": "Не удалось получить данные"}' | tee -a $LOG_FILE
    exit 0
fi

# Обрезаем длинные строки
max_len=25
if [[ ${#title} -gt $max_len ]]; then
    title="${title:0:$((max_len-3))}..."
fi
if [[ ${#artist} -gt $max_len ]]; then
    artist="${artist:0:$((max_len-3))}..."
fi

# Формируем JSON
echo "{\"text\": \" $artist - $title\", \"class\": \"${status,,}\", \"tooltip\": \"$artist - $title\"}" | tee -a $LOG_FILE
