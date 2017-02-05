from flask import Flask, request, jsonify
import json
import requests
from urllib2 import URLError

app = Flask(__name__)

@app.route('/get-location', methods=['POST'])
def getLocation():
    lat = request.form['lat']
    lon = request.form['lon']
    radius = request.form['radius']
    price = request.form['price']

    return curl_request(lat, lon, radius, price)

# give it an object, that we just parsed from zomato
def parse_data_zomato(restaurants, price):
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

    return json.dumps({'data': results})

def parse_data_foursquare(restaurants, price):
    results = []

    for restaurant in restaurants['response']['venues']:
        result = {}
        
        restaurant_id = restaurant['id']
        result['lat'] = restaurant['location']['lat']
        result['lon'] = restaurant['location']['lng']
        result['restaurant_name'] = restaurant['name']
        menu_url = ('https://api.foursquare.com/v2/venues/{id}/menu?'
                      'client_id=H2KDEDO03T5D5UZHSG24XXMVP3WST2GWIHPBO2RQIEREJ2OW'
                      '&client_secret=2DHASPBYJDCPPZJHU2AWGKSNHI141CBASPZ5F4LJN5QUNI4H'
                      '&v=20170204').format(id=restaurant_id)
        result['menu_items'] = json.loads(requests.get(menu_url).content)['response']['menu']
        result['phone'] = restaurant['contant']['formattedPhone']
        result['address'] = restaurant['location']['formattedAddress']

        results.append(result)

    return json.dumps({'data': results})


def curl_request(lat, lon, radius, price):
    zomato_headers = {
        'content-type': 'application/json',
        'user-key': '892a31736bd16f15eedd942201d67ca2'
    }

    foursquare = ('https://api.foursquare.com/v2/venues/search?'
                  'categoryId=4d4b7105d754a06374d81259'
                  '&radius={rad}'
                  '&ll={lat},{lon}'
                  '&client_id=H2KDEDO03T5D5UZHSG24XXMVP3WST2GWIHPBO2RQIEREJ2OW'
                  '&client_secret=2DHASPBYJDCPPZJHU2AWGKSNHI141CBASPZ5F4LJN5QUNI4H'
                  '&v=20170204').format(lat=lat, lon=lon, rad=radius)

    zomato = ('https://developers.zomato.com/api/v2.1/search?'
           'lat={lat}&lon={lon}&radius={rad}&sort=cost&'
           'order=asc').format(lat=lat, lon=lon, rad=radius)

    try:
        zomato_request = requests.get(zomato, headers=zomato_headers).content
        foursquare_request = requests.get(foursquare).content

        zomato_dict = json.loads(zomato_request)
        foursquare_dict = json.loads(foursquare_request)

        zomato_data = parse_data_zomato(zomato_dict, price)
        foursquare_data = parse_data_foursquare(foursquare_dict, price)

        return zomato_data
    except URLError, e:
        return jsonify('No API!'), e

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
