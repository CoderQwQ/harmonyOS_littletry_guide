import os
import csv
from collections import namedtuple

Attraction = namedtuple('Attraction', ['city', 'name', 'lat', 'lon', 'rating', 'description', 'cover_image'])

def load_attractions(city):
    filename = f"data/pois_{city}.csv"
    if not os.path.exists(filename):
        raise FileNotFoundError(f"城市数据文件不存在: {filename}")

    attractions = []
    with open(filename, encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            try:
                attractions.append(Attraction(
                    city=row['city'],
                    name=row['名称'],
                    lat=float(row['纬度']),
                    lon=float(row['经度']),
                    rating=float(row['评价分数']),
                    description=row['介绍'],
                    cover_image=row['封面图片']
                ))
            except (KeyError, ValueError):
                continue
    return attractions
