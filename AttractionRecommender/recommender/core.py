from recommender.data_loader import load_attractions
from recommender.utils import vectorized_distances, calculate_scores, format_attraction
from functools import lru_cache

city_list = ['宁波','温州','绍兴','湖州','金华','丽水','舟山',
    '杭州','北京', '天津', '上海', '重庆', '太原', '呼和浩特', '沈阳', '长春', '哈尔滨',
    '南京',  '合肥', '福州', '南昌', '济南',
    '郑州', '武汉', '长沙', '广州', '南宁', '海口',
    '成都', '贵阳', '昆明', '拉萨', '西安', '兰州',
    '西宁', '银川', '乌鲁木齐', '香港', '澳门'
]

class AttractionRecommender:
    def __init__(self, city='杭州', lon=120.343229, lat=30.314244):
        self.city = city
        self.n = 10
        self.lon = lon
        self.lat = lat
        self.decay_factor = 50

    def setPos(self, lon, lat, n):
        self.lon = lon
        self.lat = lat
        self.n = n

    def recommend(self):
        try:
            attractions = self.get_cached_attractions()
        except Exception as e:
            return [], str(e)

        if not attractions:
            return [], f"该城市{self.city}没有景点数据"

        distances = vectorized_distances(attractions, self.lat, self.lon)
        if distances.size == 0:
            return [], f"计算{self.city}景点距离失败"

        scores = calculate_scores(attractions, distances, self.decay_factor)
        if scores.size == 0:
            return [], f"计算{self.city}景点分数失败"

        scored = [{
            'attraction': a,
            'distance': distances[i],
            'score': scores[i]
        } for i, a in enumerate(attractions)]
        # 先筛掉低于 0.5 分的
        filtered = [x for x in scored if x['score'] >= 0.5]

# 按分数排序


        filtered.sort(key=lambda x: x['score'], reverse=True)
        return filtered[:self.n], None

    def get_recommendation_result(self):
        try:
            recommended, error_msg = self.recommend()
            if error_msg:
                raise Exception(error_msg)
                # return {"message": error_msg, "recommended_jingdians": []}
            elif len(recommended)==0:
                return {"message":"附近没有推荐的景点","recommended_jingdians":[]}
            return {
                "nums":len(recommended),
                "recommended_jingdians": [format_attraction(r) for r in recommended],
            }
        except Exception as e:
            return {
                "error": str(e),
                "message": "推荐系统发生错误",
                "recommended_jingdians": [],
            }

    @lru_cache(maxsize=10)
    def get_cached_attractions(self):
        return load_attractions(self.city)

_recommenders = {city: AttractionRecommender(city=city) for city in city_list}

def get_recommender(city):
    return _recommenders[city]
