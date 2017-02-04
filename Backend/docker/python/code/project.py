from flask import Flask, render_template, request, redirect, jsonify, url_for
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine, asc
from sqlalchemy.orm import sessionmaker
from database_setup import Base, Category, Item, User
from flask import session as login_session
import random
import string
from oauth2client.client import flow_from_clientsecrets
from oauth2client.client import FlowExchangeError
import httplib2
import json
from flask import make_response
import requests

app = Flask(__name__)

CLIENT_ID = json.loads(
    open('client_secrets.json', 'r').read())['web']['client_id']
APPLICATION_NAME = "Catalog Application"

# Connect to Database and create database session
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///catalog.db'
db = SQLAlchemy(app)

session = db.session

# engine = create_engine('sqlite:///catalog.db')
# Base.metadata.bind = engine
#
# DBSession = sessionmaker(bind=engine)
# session = DBSession()

# Create anti-forgery state token
@app.route('/login')
def login():
    state = ''.join(random.choice(string.ascii_uppercase + string.digits) for x in xrange(32))
    login_session['state'] = state
    return render_template('login.html', STATE=state)

@app.route('/gconnect', methods=['POST'])
def gconnect():
    # Validate state token
    if request.args.get('state') != login_session['state']:
        response = make_response(json.dumps('Invalid state parameter.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response
    # Obtain authorization code
    code = request.data

    try:
        # Upgrade the authorization code into a credentials object
        oauth_flow = flow_from_clientsecrets('client_secrets.json', scope='')
        oauth_flow.redirect_uri = 'postmessage'
        credentials = oauth_flow.step2_exchange(code)
    except FlowExchangeError:
        response = make_response(
            json.dumps('Failed to upgrade the authorization code.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Check that the access token is valid.
    access_token = credentials.access_token
    url = ('https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=%s'
           % access_token)
    h = httplib2.Http()
    result = json.loads(h.request(url, 'GET')[1])
    # If there was an error in the access token info, abort.
    if result.get('error') is not None:
        response = make_response(json.dumps(result.get('error')), 500)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Verify that the access token is used for the intended user.
    gplus_id = credentials.id_token['sub']
    if result['user_id'] != gplus_id:
        response = make_response(
            json.dumps("Token's user ID doesn't match given user ID."), 401)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Verify that the access token is valid for this app.
    if result['issued_to'] != CLIENT_ID:
        response = make_response(
            json.dumps("Token's client ID does not match app's."), 401)
        print "Token's client ID does not match app's."
        response.headers['Content-Type'] = 'application/json'
        return response

    stored_credentials = login_session.get('credentials')
    stored_gplus_id = login_session.get('gplus_id')
    if stored_credentials is not None and gplus_id == stored_gplus_id:
        response = make_response(json.dumps('Current user is already connected.'),
                                 200)
        response.headers['Content-Type'] = 'application/json'
        return response

    # Store the access token in the session for later use.
    login_session['credentials'] = credentials.to_json()
    login_session['gplus_id'] = gplus_id

    # Get user info
    userinfo_url = "https://www.googleapis.com/oauth2/v1/userinfo"
    params = {'access_token': credentials.access_token, 'alt': 'json'}
    answer = requests.get(userinfo_url, params=params)

    data = answer.json()

    login_session['username'] = data['name']
    login_session['picture'] = data['picture']
    login_session['email'] = data['email']
    # ADD PROVIDER TO LOGIN SESSION
    login_session['provider'] = 'google'

    # see if user exists, if it doesn't make a new one
    user_id = getUserID(data["email"])
    if not user_id:
        user_id = createUser(login_session)
    login_session['user_id'] = user_id

    output = {}
    output['username'] = login_session['username']
    output['image'] = login_session['picture']
    return json.dumps(output)

# DISCONNECT - Revoke a current user's token and reset their login_session
@app.route('/gdisconnect')
def gdisconnect():
    # Only disconnect a connected user.
    credentials = login_session.get('credentials')
    if credentials is None:
        response = make_response(
            json.dumps('Current user not connected.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response
    access_token = json.loads(credentials).get('access_token')
    url = 'https://accounts.google.com/o/oauth2/revoke?token=%s' % access_token
    h = httplib2.Http()
    result = h.request(url, 'GET')[0]
    print(result)
    if result['status'] != '200':
        # For whatever reason, the given token was invalid.
        response = make_response(
            json.dumps('Failed to revoke token for given user.'), 400)
        response.headers['Content-Type'] = 'application/json'
        return response

# Disconnect based on provider
@app.route('/disconnect')
def disconnect():
    if 'provider' in login_session:
        if login_session['provider'] == 'google':
            gdisconnect()
            del login_session['gplus_id']
            del login_session['credentials']

        del login_session['username']
        del login_session['email']
        del login_session['picture']
        del login_session['user_id']
        del login_session['provider']

        return redirect(url_for('showCatalog'))
    else:
        return redirect(url_for('showCatalog'))

# User Helper Functions
def createUser(login_session):
    newUser = User(name=login_session['username'], email=login_session[
                   'email'], picture=login_session['picture'])
    session.add(newUser)
    session.commit()
    user = session.query(User).filter_by(email=login_session['email']).one()
    return user.id

def getUserInfo(user_id):
    user = session.query(User).filter_by(id=user_id).one()
    return user

def getUserID(email):
    try:
        user = session.query(User).filter_by(email=email).one()
        return user.id
    except:
        return None

# JSON APIs to view Catalog Information
@app.route('/catalog/json/')
def catalogJSON():
    categories = session.query(Category).all()
    arr=[]
    items = []
    for category in categories:
        items = session.query(Item).filter_by(category_id=category.id).all()
        category_json = category.serialize
        category_json['items'] = [item.serialize for item in items]
        arr.append(category_json)
    return jsonify(categories=arr)

# Show catalog redirect
@app.route('/')
@app.route('/catalog/')
def showCatalog():
    return redirect('/catalog/0/')

# Show catalog
@app.route('/<int:category_id>/')
@app.route('/catalog/<int:category_id>/')
def showCatalogMain(category_id):
    categories = session.query(Category).order_by(asc(Category.name))

    items = []
    current_category = []
    if category_id == 0:
        items = session.query(Item).order_by(asc(Item.name))
    else:
        current_category = session.query(Category).filter_by(id=category_id).one()
        if categories.first():
            items = session.query(Item).filter_by(category_id=category_id).order_by(asc(Item.name))
    if 'username' not in login_session:
        return render_template('catalog.html', current_category=current_category, category_id=category_id, categories=categories, items=items, user=False)
    else:
        return render_template('catalog.html', current_category=current_category,category_id=category_id, categories=categories, items=items, user=login_session['user_id'])

# Create a new category
@app.route('/category/create/', methods=['GET', 'POST'])
def createCategory():
    if 'username' not in login_session:
        return redirect('/login')
    if request.method == 'POST':
        newCategory = Category(
            name=request.form['name'], user_id=login_session['user_id'])
        session.add(newCategory)
        session.commit()
        return redirect(url_for('showCatalog'))
    else:
        return render_template('createCategory.html')

# Update a category
@app.route('/category/<int:category_id>/update/', methods=['GET', 'POST'])
def updateCategory(category_id):
    updatedCategory = session.query(
        Category).filter_by(id=category_id).one()
    if 'username' not in login_session:
        return redirect('/login')
    if updatedCategory.user_id != login_session['user_id']:
        return "<script>function myFunction() {alert('You are not authorized to update this category. Please create your own category in order to update.');window.location = '/';}</script><body onload='myFunction()''>"
    if request.method == 'POST':
        if request.form['name']:
            updatedCategory.name = request.form['name']
            session.add(updatedCategory)
            session.commit()
            return redirect(url_for('showCatalog'))
    else:
        return render_template('updateCategory.html', category=updatedCategory)

# Delete a category
@app.route('/category/<int:category_id>/delete/', methods=['GET', 'POST'])
def deleteCategory(category_id):
    categoryToDelete = session.query(Category).filter_by(id=category_id).one()
    items = session.query(Item).filter_by(category_id=category_id).order_by(asc(Item.name))
    if 'username' not in login_session:
        return redirect('/login')
    if categoryToDelete.user_id != login_session['user_id']:
        return "<script>function myFunction() {alert('You are not authorized to delete this category. Please create your own category in order to delete.');window.location = '/';}</script><body onload='myFunction()''>"
    if items.first():
        for item in items:
            session.delete(item)
        session.commit()
    if request.method == 'GET':
        session.delete(categoryToDelete)
        session.commit()
        return redirect(url_for('showCatalog'))
    else:
        return redirect(url_for('showCatalog'))

# Create a new category item
@app.route('/category/<int:category_id>/item/create/', methods=['GET', 'POST'])
def createItem(category_id):
    if 'username' not in login_session:
        return redirect('/login')
    category = session.query(Category).filter_by(id=category_id).one()
    if request.method == 'POST':
        newItem = Item(name=request.form['name'], description=request.form['description'], category_id=category_id, user_id=login_session['user_id'])
        session.add(newItem)
        session.commit()
        return redirect(url_for('showCatalog'))
    else:
        return render_template('createItem.html', category_id=category_id)

# Update an item
@app.route('/category/item/<int:item_id>/update/', methods=['GET', 'POST'])
def updateItem(item_id):
    if 'username' not in login_session:
        return redirect('/login')
    updatedItem = session.query(Item).filter_by(id=item_id).one()
    if login_session['user_id'] != updatedItem.user_id:
        return "<script>function myFunction() {alert('You are not authorized to update items to this category. Please create your own item in order to edit.');window.location = '/';}</script><body onload='myFunction()''>"
    if request.method == 'POST':
        if request.form['name']:
            updatedItem.name = request.form['name']
        if request.form['description']:
            updatedItem.description = request.form['description']
        session.add(updatedItem)
        session.commit()
        return redirect(url_for('showCatalog'))
    else:
        return render_template('updateItem.html', item=updatedItem)

# Delete an item
@app.route('/category/item/<int:item_id>/delete/', methods=['GET', 'POST'])
def deleteItem(item_id):
    if 'username' not in login_session:
        return redirect('/login')
    itemToDelete = session.query(Item).filter_by(id=item_id).one()
    if login_session['user_id'] != itemToDelete.user_id:
        return "<script>function myFunction() {alert('You are not authorized to delete items to this category. Please create your own item in order to delete.');window.location = '/';}</script><body onload='myFunction()''>"
    if request.method == 'GET':
        session.delete(itemToDelete)
        session.commit()
        return redirect(url_for('showCatalog'))
    else:
        return redirect(url_for('showCatalog'))


if __name__ == '__main__':
    app.secret_key = '$up3r_$3cr3t_k3y'
    app.debug = True
    app.run(host='0.0.0.0', port=5000)
