import os
import json

from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    hostname = {'hostname': os.environ.get('HOSTNAME', 'HOSTNAME unset')}
    return json.dumps(hostname)
