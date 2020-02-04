# Hello Kubernetes

A simple web service to say hello Kubernetes using Python 3 and Flask.

## Run locally

```
python -m venv venv
source venv/bin/activate
pip install --requirement requirements.txt

FLASK_APP=app.py
FLASK_ENV=development
flask run --host=0.0.0.0

open http://localhost:5000/
```

## Run on Docker

```
docker build -t hello-kubernetes:1.0.0 .
docker run -it --rm -p 5000:5000 hello-kubernetes:1.0.0

open http://localhost:5000/
```
