import httplib

import flask
from flask import request
from flask_restful import Resource, Api

app = flask.Flask(__name__)
api = Api(app)


def curl_request(lon, lat):
    headers = {
        'user-key': '892a31736bd16f15eedd942201d67ca2'
    }
    payload = "?lat={lat}&lon={lon}&q=pizza".format(lat=lat, lon=lon)

    conn = httplib.HTTPConnection("https://developers.zomato.com/api/v2.1/search" + payload)
    conn.request("GET", headers)
    response = conn.getresponse()

    return response


class HelloWorld(Resource):
    def get(self, lon, lat):
        return flask.jsonify(curl_request(lon, lat))

api.add_resource(HelloWorld, '/<string:lon><string:lat>')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
