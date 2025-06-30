from flask import Flask, request, jsonify
from recommender.core import get_recommender, city_list

app = Flask(__name__)

@app.route('/recommend', methods=['GET'])
def recommend_attractions():
    city = request.args.get('city', '杭州')

    # 验证 n
    try:
        n = int(request.args.get('n', 10))
        if n <= 0 or n > 50:
            raise ValueError("n out of range")
    except ValueError as e:
        return jsonify({
            "error": "参数错误",
            "message": "参数 n 必须是 1 到 50 之间的整数。",
        }), 400

    # 验证纬度
    try:
        lat = float(request.args.get('lat', 30.314244))
        if not (-90 <= lat <= 90):
            raise ValueError("lat out of range")
    except ValueError:
        return jsonify({
            "error": "参数错误",
            "message": "纬度 lat 必须是 -90 到 90 之间的浮点数。",
        }), 400

    # 验证经度
    try:
        lon = float(request.args.get('lon', 120.343229))
        if not (-180 <= lon <= 180):
            raise ValueError("lon out of range")
    except ValueError:
        return jsonify({
            "error": "参数错误",
            "message": "经度 lon 必须是 -180 到 180 之间的浮点数。",
        }), 400

    # 验证城市
    if city not in city_list:
        return jsonify({
            "error": "城市不存在",
            "message": "输入的城市名称错误或该城市数据未被收集。",
        }), 400

    recommender = get_recommender(city)
    recommender.setPos(lon, lat, n)
    result = recommender.get_recommendation_result()

    status_code = 200
    if "error" in result:
        status_code = 500
    elif "message" in result and not result.get("recommended_jingdians"):
        status_code = 404

    return jsonify(result), status_code

if __name__ == '__main__':
    print("\n启动Flask服务...")
    app.run(host='0.0.0.0', port=5000, debug=True)
