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

## Build and run on Docker locally

```
docker build -t hello-kubernetes .
docker run -it --rm -p 5000:5000 hello-kubernetes

open http://localhost:5000/
```

## Debug the container on Docker locally

```
docker run -it --rm -p 5000:5000 hello-kubernetes sh
```
