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

## Run on Docker locally with image from DockerHub

To run the latest version.

```
docker run -it --rm -p 5000:5000 docker.io/etoews/hello-kubernetes
```

To run a specific version, use the short hash from one of the [commits](https://github.com/etoews/hello-kubernetes/commits/master).

For example.

```
docker run -it --rm -p 5000:5000 docker.io/etoews/hello-kubernetes:0b7ef88
```
