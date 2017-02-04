from flask import Flask, request, jsonify
import json
import requests

app = Flask(__name__)

@app.route('/get-location', methods=['POST'])
def getLocation():
    lat = request.form['lat']
    lon = request.form['lon']
    price = request.form['price']

    return curl_request(lat, lon)

def curl_request(lat, lon):
    headers = {
        'content-type': 'application/json',
        'user-key': '892a31736bd16f15eedd942201d67ca2'
        }

    url = 'https://developers.zomato.com/api/v2.1/search?lat={lat}&lon={lon}&q=pizza'.format(lat=lat, lon=lon)

    try:
        r = requests.get(url, headers=headers)
        return json.dumps(r)
    except URLError, e:
        return jsonify('No API!'), e

if __name__ == '__main__':
    app.debug=True
    app.run(host='0.0.0.0', port=5000)
