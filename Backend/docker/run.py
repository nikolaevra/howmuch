from flask import Flask, request

app = Flask(__name__)

@app.route('/get-location', methods=['POST'])
def createCategory():
    lat=request.form['lat']
    lon=request.form['lon']
    price=request.form['price']
    print(lat + " " + lon + " " + price)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
