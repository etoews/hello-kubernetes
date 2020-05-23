import logging
import socket
import time

from flask import Flask, request, jsonify

app = Flask(__name__)
logger = logging.getLogger(__name__)

logging.basicConfig(
    format='%(asctime)s.%(msecs)03d, %(levelname)s, %(message)s',
    datefmt='%Y-%m-%dT%H:%M:%S', level=logging.DEBUG)


@app.route('/')
def hello_world():
    result = {'hostname': socket.gethostname()}
    return jsonify(result)


@app.route('/sleep')
def sleep():
    seconds = request.args.get('seconds', default=60, type=int)

    logger.debug("sleep for %ss", seconds)
    time.sleep(seconds)

    result = {
        'hostname': socket.gethostname(),
        'seconds': seconds
    }

    return jsonify(result)
