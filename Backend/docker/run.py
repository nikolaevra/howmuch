from flask import Flask, request, jsonify
import json
import requests
from urllib2 import Request, urlopen, URLError

app = Flask(__name__)

@app.route('/get-location', methods=['POST'])
def getLocation():
    lat = request.form['lat']
    lon = request.form['lon']
    radius = request.form['radius']
    price = request.form['price']

    return curl_request(lat, lon, radius, price)

# give it an object, that we just parsed from zomato
def parse_data(restaurants, price):
    results = []

    for restaurant in restaurants['restaurants']:
        result = {}
        item = restaurant['restaurant']

        result['name'] = item['name']
        result['location'] = item['location']

        # check if the price is below allowed
        if item['average_cost_for_two'] + item['price_range'] < price:
            result['price'] = item['average_cost_for_two'] + item['price_range']

        result['rating'] = item['user_rating']
        result['photo_url'] = item['photos_url'][0]
        result['menu_url'] = item['menu_url']

        results.append(result)

    return json.dumps({'results': results})

def curl_request(lat, lon, radius, price):
    headers = {
        'content-type': 'application/json',
        'user-key': '892a31736bd16f15eedd942201d67ca2'
        }

    url = ('https://developers.zomato.com/api/v2.1/search'
           '?lat={lat}&lon={lon}&radius={rad}&sort=cost&'
           'order=asc').format(lat=lat, lon=lon, rad=radius)

    try:
        r = requests.get(url, headers=headers).content
        obj = json.loads(r)
        return json.dumps(obj)
    except URLError, e:
        return jsonify('No API!'), e

if __name__ == '__main__':
    app.debug=True
    app.run(host='0.0.0.0', port=5000)
