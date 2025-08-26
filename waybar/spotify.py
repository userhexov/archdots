#!/usr/bin/env python3

import dbus
import json
import sys
import subprocess

def get_spotify_info():
    try:
        # Проверяем, запущен ли Spotify
        result = subprocess.run(
            ['pgrep', '-x', 'spotify'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        
        if result.returncode != 0:
            # Spotify не запущен
            return {
                'text': " жду запуск спотифай",
                'class': 'waiting',
                'tooltip': "Spotify не запущен"
            }
        
        # Подключаемся к Spotify через D-Bus
        bus = dbus.SessionBus()
        spotify = bus.get_object(
            'org.mpris.MediaPlayer2.spotify',
            '/org/mpris/MediaPlayer2'
        )
        player = dbus.Interface(spotify, 'org.freedesktop.DBus.Properties')
        
        # Получаем статус воспроизведения
        status = player.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')
        
        # Получаем метаданные
        metadata = player.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
        
        # Извлекаем информацию о треке
        title = str(metadata.get('xesam:title', 'Unknown Title'))
        artist = ', '.join(metadata.get('xesam:artist', ['Unknown Artist']))
        
        # Обрезаем слишком длинные названия
        max_length = 25
        if len(title) > max_length:
            title = title[:max_length-3] + '...'
        if len(artist) > max_length:
            artist = artist[:max_length-3] + '...'
        
        # Форматируем вывод
        return {
            'text': f" {artist} - {title}",
            'class': status.lower(),
            'tooltip': f"{artist} - {title}"
        }
        
    except dbus.exceptions.DBusException as e:
        # Ошибка подключения к D-Bus
        return {
            'text': " ошибка DBus",
            'class': 'error',
            'tooltip': str(e)
        }
    except Exception as e:
        # Общая обработка ошибок
        return {
            'text': " ошибка",
            'class': 'error',
            'tooltip': str(e)
        }

if __name__ == '__main__':
    try:
        info = get_spotify_info()
        print(json.dumps(info))
    except Exception as e:
        print(json.dumps({
            'text': " ошибка скрипта",
            'class': 'error',
            'tooltip': str(e)
        }))
