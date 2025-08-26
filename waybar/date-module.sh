#!/usr/bin/env bash

# Устанавливаем временную зону GMT+4
export TZ="Etc/GMT-4"

# Получаем текущее время в формате: Час:Минута (24h)
current_time=$(date +"%H:%M")

# Получаем текущую дату в формате: День-Месяц-Год
current_date=$(date +"%d-%m-%Y")

# Генерируем календарь с выделением текущей даты
calendar=$(cal | sed "s/$(date +%e)/<u><b>&<\/b><\/u>/")

# Формируем вывод в формате JSON
cat <<EOF
{
    "text": "$current_time $current_date",
    "tooltip": "$calendar"
}
EOF
