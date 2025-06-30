import requests

BASE_URL = "http://127.0.0.1:5000"

def test_recommend_defual():
    resp = requests.get(f"{BASE_URL}/recommend")
    assert resp.status_code == 200
    data = resp.json()
    assert "recommended_jingdians" in data
    assert "nums" in data
    assert data['nums']<=10 and data['nums']>0    

def test_recommend_success():
    resp = requests.get(f"{BASE_URL}/recommend?city=杭州&lat=30.25&lon=120.15&n=30")
    assert resp.status_code == 200
    data = resp.json()
    assert "recommended_jingdians" in data
    assert "nums" in data
    assert data['nums']<=30 and data['nums']>0
    resp = requests.get(f"{BASE_URL}/recommend?city=上海&lat=31.14&lon=121.29&n=10")
    assert resp.status_code == 200
    data = resp.json()
    assert "recommended_jingdians" in data
    assert "nums" in data
    assert data['nums']<=30 and data['nums']>0

def test_city_not_found():
    resp = requests.get(f"{BASE_URL}/recommend?city=不存在")
    assert resp.status_code == 400

def test_jingdian_not_found():
    resp = requests.get(f"{BASE_URL}/recommend?city=杭州&lat=1&lon=1&n=10")
    assert resp.status_code == 404
    data = resp.json()
    assert "message" in data
    assert data["message"]=="附近没有推荐的景点"
    assert "recommended_jingdians" in data and not data['recommended_jingdians']
    assert "nums" not in data


def test_invalid_param_n_LessThanZero():
    resp = requests.get(f"{BASE_URL}/recommend?n=-1")
    assert resp.status_code == 400
    data=resp.json()
    assert "error" in data
    assert "message" in data
    assert data['error']=='参数错误'
    assert data['message']=='参数 n 必须是 1 到 50 之间的整数。'
def test_invalid_param_n_LargeThan50():
    resp = requests.get(f"{BASE_URL}/recommend?n=100")
    assert resp.status_code == 400
    data=resp.json()
    assert "error" in data
    assert "message" in data
    assert data['error']=='参数错误'
    assert data['message']=='参数 n 必须是 1 到 50 之间的整数。'

def test_invalid_param_n_Not_Int():
    resp = requests.get(f"{BASE_URL}/recommend?n=abc")
    assert resp.status_code == 400
    data=resp.json()
    assert "error" in data
    assert "message" in data
    assert data['error']=='参数错误'
    assert data['message']=='参数 n 必须是 1 到 50 之间的整数。'


def test_invalid_param_Lon_OutOfRange():
    resp = requests.get(f"{BASE_URL}/recommend?lon=-181")
    assert resp.status_code == 400
    data=resp.json()
    assert "error" in data
    assert "message" in data
    assert data['error']=='参数错误'
    assert data['message']=="经度 lon 必须是 -180 到 180 之间的浮点数。"

    resp = requests.get(f"{BASE_URL}/recommend?lon=181")
    assert resp.status_code == 400
    data=resp.json()
    assert "error" in data
    assert "message" in data
    assert data['error']=='参数错误'
    assert data['message']=="经度 lon 必须是 -180 到 180 之间的浮点数。"

def test_invalid_param_Lon_NotFloat():
    resp = requests.get(f"{BASE_URL}/recommend?lon=abc")
    assert resp.status_code == 400
    data=resp.json()
    assert "error" in data
    assert "message" in data
    assert data['error']=='参数错误'
    assert data['message']=="经度 lon 必须是 -180 到 180 之间的浮点数。"

def test_invalid_param_Lat_OutOfRange():
    resp = requests.get(f"{BASE_URL}/recommend?lat=-91")
    assert resp.status_code == 400
    data=resp.json()
    assert "error" in data
    assert "message" in data
    assert data['error']=='参数错误'
    assert data['message']=="纬度 lat 必须是 -90 到 90 之间的浮点数。"

    resp = requests.get(f"{BASE_URL}/recommend?lat=91")
    assert resp.status_code == 400
    data=resp.json()
    assert "error" in data
    assert "message" in data
    assert data['error']=='参数错误'
    assert data['message']=="纬度 lat 必须是 -90 到 90 之间的浮点数。"


def test_invalid_param_Lat_OutOfRange():
    resp = requests.get(f"{BASE_URL}/recommend?lat=abc")
    assert resp.status_code == 400
    data=resp.json()
    assert "error" in data
    assert "message" in data
    assert data['error']=='参数错误'
    assert data['message']=="纬度 lat 必须是 -90 到 90 之间的浮点数。"


