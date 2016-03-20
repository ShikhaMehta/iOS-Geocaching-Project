#!flask/bin/python

# TUTORIAL:
# http://blog.miguelgrinberg.com/post/designing-a-restful-api-with-python-and-flask
# For DigitalOcean Droplet:
# https://www.digitalocean.com/community/tutorials/how-to-deploy-a-flask-application-on-an-ubuntu-vps

from flask import Flask, jsonify, abort, make_response, request, url_for
from filehelper import FileHelper
from geopy.distance import great_circle
from copy import deepcopy
import json

server = Flask(__name__)

filepath = "./geocaches.json"
fh = None
geocaches = []
counter = 1


def new_id():
    global counter
    counter += 1
    return counter


def make_public_geocache(geocache):
    global geocaches
    new_geocache = {}
    for field in geocache:
        if field == 'id':
            new_geocache['uri'] = url_for('get_geocache', gc_id=geocache['id'], _external=True)
        else:
            new_geocache[field] = geocache[field]
    return new_geocache


# URI PARAMS:   None
# BODY PARAMS:  None
# RETURN:       JSON object containing JSON array of all geocaches
@server.route("/URIs", methods=['GET'])
def get_geocache_uris():
    global geocaches
    return jsonify({'geocaches': [make_public_geocache(geocache) for geocache in geocaches], "success": True})


# URI PARAMS:   None
# BODY PARAMS:  None
# RETURN:       JSON Object containing JSON array of all Geocaches
@server.route("/all", methods=["GET"])
def get_geocaches():
    return jsonify({"geocaches": geocaches, "success": True})


# URI PARAMS:   Geocache ID (INT)
# BODY PARAMS:  None
# RETURN:       JSON object containing the requested Geocache
@server.route("/get/<int:gc_id>", methods=["GET"])
def get_geocache(gc_id):
    global geocaches
    geocache = [geocache for geocache in geocaches if geocache["id"] == gc_id]
    if len(geocache) == 0:
        abort(404)
    return jsonify({"geocache": geocache[0], "success": True})


# URI PARAMS:   Latitude (Float), Longitude (Float), Radius (Float)
# BODY PARAMS:  None
# RETURN:       JSON object containing JSON array of geocaches within given coordinates
@server.route("/radius/<lat>/<lon>/<radius>", methods=["GET"])
def get_within_radius(lat, lon, radius):
    global geocaches
    within_radius = []
    try:
        lat = float(lat)
        lon = float(lon)
        radius = float(radius)
    except ValueError:
        abort(400)

    coord1 = (lat, lon)
    for geocache in geocaches:
        coord2 = (geocache["lat"], geocache["lon"])
        dist = great_circle(coord1, coord2).miles
        if dist <= radius:
            copy = deepcopy(geocache)
            copy["distance"] = dist
            within_radius.append(copy)

    return jsonify({"geocaches": within_radius, "success": True})


# URI PARAMS:   None
# BODY PARAMS:  {"name":STRING,"lat":FLOAT,"lon":FLOAT,"description":STRING}
# RETURN:       JSON object containing JSON array of geocaches (after insertion)
@server.route("/new", methods=["POST"])
def create_geocache():
    global geocaches
    if not request.json:
        abort(400)
    if "name" not in request.json or type(request.json["name"]) is not unicode:
        abort(400)
    if "lat" not in request.json or type(request.json["lat"]) is not float:
        abort(400)
    if "lon" not in request.json or type(request.json["lon"]) is not float:
        abort(400)
    if "description" not in request.json or type(request.json["description"]) is not unicode:
        abort(400)
    geocache = {
        "id": new_id(),
        "name": request.json["name"],
        "lat": request.json["lat"],
        "lon": request.json["lon"],
        "description": request.json.get("description", ""),
        "log": []
    }
    geocaches.append(geocache)
    fh.replace_contents(json.dumps(indent=2, obj={"geocaches": geocaches}))
    return jsonify({"geocaches": geocaches, "success": True}), 201


# URI PARAMS:   Geocache ID
# BODY PARAMS:  {"id":INT,"name":STRING,"lat":FLOAT,"lon":FLOAT,"description":STRING}
# RETURN:       JSON object containing edited geocache
@server.route("/update", methods=["PUT"])
def update_geocache():
    global geocaches
    if not request.json:
        abort(400)
    if "id" not in request.json or type(request.json["id"]) is not int:
        abort(400)
    if "name" not in request.json or type(request.json["name"]) is not unicode:
        abort(400)
    if "lat" not in request.json or type(request.json["lat"]) is not float:
        abort(400)
    if "lon" not in request.json or type(request.json["lon"]) is not float:
        abort(400)
    if "description" not in request.json or type(request.json["description"]) is not unicode:
        abort(400)
    geocache = [geocache for geocache in geocaches if geocache["id"] == request.json["id"]]
    if len(geocache) == 0:
        abort(404)
    geocache[0]["name"] = request.json.get("name", geocache[0]["name"])
    geocache[0]["lat"] = request.json.get("lat", geocache[0]["lat"])
    geocache[0]["lon"] = request.json.get("lon", geocache[0]["lon"])
    geocache[0]["description"] = request.json.get("description", geocache[0]["description"])
    fh.replace_contents(json.dumps(indent=2, obj={"geocaches": geocaches}))
    return jsonify({"geocache": geocache[0], "success": True}), 200


# URI PARAMS:   None
# BODY PARAMS:  {"id":INT,"signature":STRING,"timestamp":INT,"item_taken":STRING,"item_left":STRING,"notes":STRING}
# RETURN:       JSON object containing updated geocache
@server.route("/checkin", methods=["POST"])
def checkin():
    global geocaches
    if "id" not in request.json or type(request.json["signature"]) is not unicode:
        abort(400)
    if "signature" not in request.json or type(request.json["signature"]) is not unicode:
        abort(400)
    if "timestamp" not in request.json or type(request.json["timestamp"]) is not int:
        abort(400)
    if "item_taken" not in request.json or type(request.json["item_taken"]) is not unicode:
        abort(400)
    if "item_left" not in request.json or type(request.json["item_left"]) is not unicode:
        abort(400)
    if "notes" not in request.json or type(request.json["notes"]) is not unicode:
        abort(400)
    geocache = [geocache for geocache in geocaches if geocache["id"] == request.json["id"]]
    if len(geocache) == 0:
        abort(404)
    geocache[0]["log"].insert(
        0,  # Insert into front of list so most recent is on top/front
        {
            "timestamp": request.json["timestamp"],
            "signature": request.json["signature"],
            "notes": request.json["notes"],
            "item_taken": request.json["item_taken"],
            "item_left": request.json["item_left"],
        })
    fh.replace_contents(json.dumps(indent=2, obj={"geocaches": geocaches}))
    return jsonify({"geocache": geocache[0], "success": True}), 200


# URI PARAMS:   Geocode ID (INT)
# BODY PARAMS:  None
# RETURN:       JSON object containing list of all geocache objects
@server.route('/delete/<int:gc_id>', methods=['DELETE'])
def delete_geocache(gc_id):
    global geocaches
    geocache = [geocache for geocache in geocaches if geocache['id'] == gc_id]
    if len(geocache) == 0:
        abort(404)
    geocaches.remove(geocache[0])
    fh.replace_contents(json.dumps(indent=2, obj={"geocaches": geocaches}))
    return jsonify({"geocaches": geocaches, "success": True}), 200


@server.errorhandler(404)
def not_found(error):
    print error
    return make_response(jsonify({'result': 'Not found', "success": False}), 404)


@server.errorhandler(400)
def not_found(error):
    print error
    return make_response(jsonify({'result': 'Bad request', "success": False}), 404)


if __name__ == '__main__':
    fh = FileHelper(filepath)
    geocaches = json.loads(fh.read())["geocaches"]
    counter = len(geocaches)
    print counter
    server.run(debug=True, port=8080, use_reloader=False)
