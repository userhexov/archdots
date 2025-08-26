#!/usr/bin/env python3
import argparse
import random
import math
import tempfile
import os
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

def create_particle_image(char, output_path, size=24):
    """Создает изображение частицы для символа"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Случайный цвет с прозрачностью
    color = (random.randint(180, 255), random.randint(180, 255), 
             random.randint(180, 255), random.randint(150, 200))
    
    # Рисуем символ как частицу
    try:
        from fontTools.ttLib import TTFont
        from fontTools.pens.imagePen import ImagePen
        
        # Используем шрифт терминала
        font_path = "/usr/share/fonts/TTF/JetBrainsMono-Regular.ttf"  # Измените на ваш шрифт
        font = ImageFont.truetype(font_path, size - 4)
        bbox = draw.textbbox((0, 0), char, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        
        x = (size - text_width) / 2
        y = (size - text_height) / 2
        
        draw.text((x, y), char, font=font, fill=color)
    except:
        # Fallback: простой круг с символом внутри
        draw.ellipse([2, 2, size-2, size-2], fill=color)
        draw.text((size/2-4, size/2-6), char, fill=(0, 0, 0, 255))

    # Добавляем размытие для эффекта частицы
    img = img.filter(ImageFilter.GaussianBlur(radius=1))
    img.save(output_path)

def generate_particle_animation(char, position, duration=0.5):
    """Генерирует анимацию частиц для символа"""
    temp_dir = tempfile.mkdtemp()
    frames = 10
    particles = 3
    
    # Создаем кадры анимации
    frame_files = []
    for frame in range(frames):
        frame_img = Image.new('RGBA', (100, 100), (0, 0, 0, 0))
        
        for i in range(particles):
            # Случайное направление и скорость для каждой частицы
            angle = random.uniform(0, 2 * math.pi)
            distance = (frame / frames) * 30
            x_offset = math.cos(angle) * distance
            y_offset = math.sin(angle) * distance - (frame / frames) * 10  # Немного вверх
            
            # Создаем частицу
            particle_file = os.path.join(temp_dir, f"particle_{i}.png")
            create_particle_image(char, particle_file)
            
            # Добавляем частицу на кадр
            particle_img = Image.open(particle_file)
            frame_img.paste(particle_img, 
                           (int(50 + x_offset - particle_img.width/2), 
                            int(50 + y_offset - particle_img.height/2)), 
                           particle_img)
        
        # Сохраняем кадр
        frame_file = os.path.join(temp_dir, f"frame_{frame:02d}.png")
        frame_img.save(frame_file)
        frame_files.append(frame_file)
    
    return frame_files, temp_dir

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate particle animation for deleted character')
    parser.add_argument('char', help='The deleted character')
    parser.add_argument('x', type=int, help='X position')
    parser.add_argument('y', type=int, help='Y position')
    args = parser.parse_args()
    
    frames, temp_dir = generate_particle_animation(args.char, (args.x, args.y))
    
    # Выводим пути к файлам для использования в shell
    print(":".join(frames))
    print(temp_dir)
