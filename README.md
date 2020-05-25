# Hello Kubernetes

A simple web service to say hello to Docker, Kubernetes, or OpenShift using Python and Flask. It's a good first container to run on a new cluster.

This image is based on the excellent [nicolaka/netshoot](https://hub.docker.com/r/nicolaka/netshoot) image, "a Docker + Kubernetes network troubleshooting swiss-army container". So if you need to do some network debugging you can run this container, open a shell in it, and have a whole toolbox full of networking tools at your fingertips.

These examples assume you're bringing your own Docker, Kubernetes, or OpenShift environment.

<!-- TOC anchormode:github.com insertanchor:false -->

* [Local](#local)
    * [Run locally](#run-locally)
* [Docker](#docker)
    * [Build and run on Docker locally](#build-and-run-on-docker-locally)
    * [Run on Docker locally with image from DockerHub](#run-on-docker-locally-with-image-from-dockerhub)
    * [Troubleshoot the container on Docker](#troubleshoot-the-container-on-docker)
* [Kubernetes](#kubernetes)
    * [Run on Kubernetes locally with image from DockerHub](#run-on-kubernetes-locally-with-image-from-dockerhub)
    * [Run on Kubernetes remotely with image from DockerHub](#run-on-kubernetes-remotely-with-image-from-dockerhub)
    * [Troubleshoot the container and cluster networking on Kubernetes](#troubleshoot-the-container-and-cluster-networking-on-kubernetes)
* [OpenShift](#openshift)
    * [Run on OpenShift 4 remotely with image from DockerHub](#run-on-openshift-4-remotely-with-image-from-dockerhub)
    * [Build and run on OpenShift 4 remotely](#build-and-run-on-openshift-4-remotely)
    * [Troubleshoot the container and cluster networking on OpenShift 4](#troubleshoot-the-container-and-cluster-networking-on-openshift-4)
* [Run a specific version](#run-a-specific-version)

<!-- /TOC -->

## Local

### Run locally

```bash
python -m venv venv
source venv/bin/activate
pip install --requirement requirements.txt

export FLASK_APP="app.py"
export FLASK_ENV="development"
export FLASK_RUN_HOST="0.0.0.0"
flask run

curl -s http://localhost:5000/
```

## Docker

### Build and run on Docker locally

```bash
docker build -t hello-kubernetes .
docker run -it --rm \
  --name hello \
  --publish 5000:5000 \
  hello-kubernetes

curl -s http://localhost:5000/
```

### Run on Docker locally with image from DockerHub

```bash
docker run -it --rm \
  --name hello \
  --publish 5000:5000 \
  docker.io/etoews/hello-kubernetes:latest

curl -s http://localhost:5000/
```

### Troubleshoot the container on Docker

```bash
docker exec -it hello bash
```

## Kubernetes

### Run on Kubernetes locally with image from DockerHub

```bash
kubectl create namespace world
kubectl apply -f manifests/kubernetes/deployment.yaml -n world
kubectl apply -f manifests/kubernetes/service.yaml -n world

watch kubectl get all -n world

curl -s http://localhost:5000/

kubectl delete namespace world
```

Notes:

* Using this with Docker Desktop Kubernetes and `type: LoadBalancer` just works.

### Run on Kubernetes remotely with image from DockerHub

```bash
kubectl create namespace world
kubectl apply -f manifests/kubernetes/deployment.yaml -n world
kubectl apply -f manifests/kubernetes/service.yaml -n world

watch kubectl get all -n world

hello_host=$(kubectl get service hello -o jsonpath="{.status.loadBalancer.ingress[*].hostname}" -n world)
curl -s http://${hello_host}:5000/

kubectl delete namespace world
```

Notes:

* The `kubectl delete namespace world` will take a minute or two as it will also delete the load balancer instance behind it (e.g. delete the ELB if you're using EKS)

### Troubleshoot the container and cluster networking on Kubernetes

See  [nicolaka/netshoot](https://hub.docker.com/r/nicolaka/netshoot) for the many networking tools included in the image.

```bash
hello_pod_0=$(kubectl get pods -o jsonpath="{.items[0].metadata.name}" -n world)
kubectl exec -it ${hello_pod_0} -n world bash
curl -s https://icanhazip.com
```

## OpenShift

### Run on OpenShift 4 remotely with image from DockerHub

```bash
oc new-project world

oc process -o yaml -f manifests/openshift4/deployment.yaml \
  --param IMAGE='docker.io/etoews/hello-kubernetes:latest' \
  | oc apply -f -
oc apply -f manifests/openshift4/service.yaml
oc apply -f manifests/openshift4/route.yaml

watch oc get all

hello_host=$(oc get route hello --no-headers -o=custom-columns=HOST:.spec.host)
curl http://${hello_host}/

oc delete project world
```

### Build and run on OpenShift 4 remotely

```bash
oc new-project world

oc apply -f manifests/openshift4/imagestream.yaml
oc apply -f manifests/openshift4/buildconfig.yaml

oc start-build hello
watch oc get all

oc process -o yaml -f manifests/openshift4/deployment.yaml \
  --param IMAGE='image-registry.openshift-image-registry.svc:5000/world/hello:latest' \
  | oc apply -f -
oc apply -f manifests/openshift4/service.yaml
oc apply -f manifests/openshift4/route.yaml

watch oc get all

hello_host=$(oc get route hello --no-headers -o=custom-columns=HOST:.spec.host)
curl http://${hello_host}/

oc delete project world
```

### Troubleshoot the container and cluster networking on OpenShift 4

See  [nicolaka/netshoot](https://hub.docker.com/r/nicolaka/netshoot) for the many networking tools included in the image.

```bash
hello_pod_0=$(oc get pods --selector app=hello -o jsonpath="{.items[0].metadata.name}")
oc rsh ${hello_pod_0}
curl -s https://icanhazip.com
```

## Run a specific version

To run a specific version, use the hash from one of the [commits](https://github.com/etoews/hello-kubernetes/commits/master) as the [tag](https://hub.docker.com/repository/docker/etoews/hello-kubernetes/tags).

For example.

```bash
docker run -it --rm \
  --name hello \
  --publish 5000:5000 \
  docker.io/etoews/hello-kubernetes:b262b385143f10242d5dbe201b999ded7782087a

curl -s http://localhost:5000/
```
