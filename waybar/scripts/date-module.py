#!/usr/bin/env python3
import json
import subprocess
import os
import sys
from datetime import datetime

def main():
    # Устанавливаем временную зону GMT+4
    os.environ['TZ'] = 'Etc/GMT-4'
    
    # Получаем текущее время
    now = datetime.now()
    
    # Форматируем время и дату для основного вывода
    time_str = now.strftime("%H:%M")
    date_str = now.strftime("%d/%m/%y")
    
    try:
        # Генерируем календарь с помощью утилиты cal
        calendar = subprocess.check_output(
            ["cal"], 
            text=True, 
            stderr=subprocess.DEVNULL
        ).strip()
    except Exception as e:
        # В случае ошибки используем простой вывод даты
        calendar = now.strftime("%B %Y\n") + "Calendar Error"
    
    # Формируем результат в формате JSON
    result = {
        "text": f" {time_str}  {date_str}",
        "tooltip": calendar
    }
    
    print(json.dumps(result))

if __name__ == "__main__":
    main()
