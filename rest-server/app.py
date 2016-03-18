#!flask/bin/python
from flask import Flask, jsonify
from flask import abort
from flask import make_response
from flask import request
from flask import url_for
from types import *

'''
    TUTORIAL:
    http://blog.miguelgrinberg.com/post/designing-a-restful-api-with-python-and-flask

    For DigitalOcean Droplet:
    https://www.digitalocean.com/community/tutorials/how-to-deploy-a-flask-application-on-an-ubuntu-vps
'''

app = Flask(__name__)

geocaches = [
    {
        'id': 1,
        'name': 'Geocache 1',
        'lat': '33.424544',
        'long': '-111.930920',
        'description': 'Wells fargo arena',
    },
    {
        'id': 1,
        'name': 'Geocache 2',
        'lat': '33.426629',
        'long': '-111.932567',
        'description': 'ASU football stadium',
    }
]


@app.route('/geocaches', methods=['GET'])
def get_geocodes():
    return jsonify({'geocaches': geocaches})


@app.route('/geocaches/<int:gc_id>', methods=['GET'])
def get_geocode(gc_id):
    geocache = [geocache for geocache in geocaches if geocache['id'] == gc_id]
    if len(geocache) == 0:
        abort(404)
    return jsonify({'task': geocache[0]})


@app.route('/new/', methods=['POST'])
def create_geocode():
    if not request.json or not 'title' in request.json:
        abort(400)
    geocache = {
        'id': geocaches[-1]['id'] + 1,
        'name': request.json['name'],
        'lat': request.json['lat'],
        'lon': request.json['lon'],
        'description': request.json.get('description', ""),
    }
    geocaches.append(geocache)
    return jsonify({'task': geocache}), 201


@app.route('/update/<int:gc_id>', methods=['PUT'])
def update_geocode(gc_id):
    geocache = [geocache for geocache in geocaches if geocache['id'] == gc_id]
    if len(geocache) == 0:
        abort(404)
    if not request.json:
        abort(400)
    if 'id' in request.json and type(request.json['id']) is not int:
        abort(400)
    if 'name' in request.json and not type(request.json['name']) is not unicode:
        abort(400)
    if 'lat' in request.json and type(request.json['lat']) is not unicode:
        abort(400)
    if 'lon' in request.json and type(request.json['lon']) is not unicode:
        abort(400)
    if 'description' in request.json and type(request.json['description']) is not type.unicode:
        abort(400)
    geocache[0]['id'] = request.json.get('id', geocache[0]['id'])
    geocache[0]['name'] = request.json.get('name', geocache[0]['name'])
    geocache[0]['lat'] = request.json.get('lat', geocache[0]['lat'])
    geocache[0]['lon'] = request.json.get('lon', geocache[0]['lon'])
    geocache[0]['description'] = request.json.get('description', geocache[0]['description'])
    print(geocache)
    return jsonify({'geocode': geocache[0]})


@app.route('/delete/<int:gc_id>', methods=['DELETE'])
def delete_geocode(gc_id):
    geocache = [geocache for geocache in geocaches if geocache['id'] == gc_id]
    if len(geocache) == 0:
        abort(404)
    geocaches.remove(geocache[0])
    return jsonify({'result': True})


@app.route('/todo/api/v1.0/tasks', methods=['GET'])
def get_geocaches():
    return jsonify({'tasks': [make_public_geocode(geocache) for geocache in geocaches]})


def make_public_geocode(geocache):
    new_geocache = {}
    for field in geocache:
        if field == 'id':
            new_geocache['uri'] = url_for('get_geocache', geocache_id=geocache['id'], _external=True)
        else:
            new_geocache[field] = geocache[field]
    return new_geocache


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)


if __name__ == '__main__':
    app.run(debug=True)