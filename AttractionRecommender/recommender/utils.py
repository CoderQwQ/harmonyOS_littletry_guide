import numpy as np
import math

def vectorized_distances(attractions, user_lat, user_lon):
    if not attractions:
        return np.array([])

    lats = np.array([a.lat for a in attractions])
    lons = np.array([a.lon for a in attractions])

    user_lat_rad = math.radians(user_lat)
    user_lon_rad = math.radians(user_lon)
    lats_rad = np.radians(lats)
    lons_rad = np.radians(lons)

    dlat = lats_rad - user_lat_rad
    dlon = lons_rad - user_lon_rad
    avg_lat = (user_lat_rad + lats_rad) / 2.0

    x = dlon * np.cos(avg_lat)
    distances = np.sqrt(x**2 + dlat**2) * 6371.0

    return distances

def calculate_scores(attractions, distances, decay_factor=50):
    ratings = np.array([a.rating for a in attractions])
    distance_scores = np.exp(-distances / decay_factor)
    return ratings * distance_scores

def format_attraction(data):
    a = data['attraction']
    return {
        'name': a.name,
        'city': a.city,
        'latitude': a.lat,
        'longitude': a.lon,
        'rating': a.rating,
        'distance_km': round(data['distance'], 2),
        'score': round(data['score'], 4),
        'description': a.description,
        'cover_image': a.cover_image
    }
