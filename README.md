# Hello Kubernetes

A simple web service to say hello Kubernetes using Python 3 and Flask.

<!-- TOC -->

* [Run locally](#run-locally)
* [Build and run on Docker locally](#build-and-run-on-docker-locally)
* [Debug the container on Docker locally](#debug-the-container-on-docker-locally)
* [Run on Docker locally with image from DockerHub](#run-on-docker-locally-with-image-from-dockerhub)
* [Run on OpenShift 4 remotely with image from DockerHub](#run-on-openshift-4-remotely-with-image-from-dockerhub)
* [Use the "API"](#use-the-api)

<!-- /TOC -->

## Run locally

```bash
python -m venv venv
source venv/bin/activate
pip install --requirement requirements.txt

export FLASK_APP="app.py"
export FLASK_ENV="development"
export FLASK_RUN_HOST="0.0.0.0"
flask run --host=0.0.0.0

open http://localhost:5000/
```

## Build and run on Docker locally

```bash
docker build -t hello-kubernetes .
docker run -it --rm \
  --name hello \
  --publish 5000:5000 \
  hello-kubernetes

open http://localhost:5000/
```

## Debug the container on Docker locally

```bash
docker run -it --rm --name hello --publish 5000:5000 hello-kubernetes sh
```

## Run on Docker locally with image from DockerHub

To run the latest version.

```bash
docker run -it --rm \
  --name hello \
  --publish 5000:5000 \
  docker.io/etoews/hello-kubernetes:latest
```

To run a specific version, use the hash from one of the [commits](https://github.com/etoews/hello-kubernetes/commits/master) as the [tag](https://hub.docker.com/repository/docker/etoews/hello-kubernetes/tags).

For example.

```bash
docker run -it --rm \
  --name hello \
  --publish 5000:5000 \
  docker.io/etoews/hello-kubernetes:b262b385143f10242d5dbe201b999ded7782087a
```

## Run on OpenShift 4 remotely with image from DockerHub

```bash
oc login
oc new-project world

oc process -o yaml -f manifests/openshift4/deployment.yaml \
  --param IMAGE='docker.io/etoews/hello-kubernetes:latest' \
  | oc apply -f -
oc apply -f manifests/openshift4/service.yaml
oc apply -f manifests/openshift4/route.yaml

watch oc get all

hello_world_host=$(oc get route hello --no-headers -o=custom-columns=HOST:.spec.host)
curl http://${hello_world_host}/

oc delete project world
```

## Build and run on OpenShift 4 remotely

```bash
oc login
oc new-project world

oc apply -f manifests/openshift4/imagestream.yaml
oc apply -f manifests/openshift4/buildconfig.yaml

oc start-build hello
oc watch get all

oc process -o yaml -f manifests/openshift4/deployment.yaml \
  --param IMAGE='image-registry.openshift-image-registry.svc:5000/world/hello:latest' \
  | oc apply -f -
oc apply -f manifests/openshift4/service.yaml
oc apply -f manifests/openshift4/route.yaml

watch oc get all

hello_world_host=$(oc get route hello --no-headers -o=custom-columns=HOST:.spec.host)
curl http://${hello_world_host}/

oc delete project world
```

## Use the "API"

```bash
curl -s http://localhost:5000/sleep?seconds=3
curl -s -X POST http://localhost:5000/sleep?seconds=30
```
