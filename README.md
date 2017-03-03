[![Build Status](https://travis-ci.org/KurioApp/fibgo-docker.svg?branch=master)](https://travis-ci.org/KurioApp/fibgo-docker)

# fibgo-docker

This is docker image for [fibgo](https://github.com/uudashr/fibgo) project.

It contains travis script to deploy the docker on Google Container Engine (GKE). Every commit to *master* or *develop* will deploy to *production* or *staging* (respectively) cluster.

## How to run
```shell
$ docker run -d -name fibgo-server -p 8080:8080 uudashr/fibgo
```

## Google Container Engine (GKE) Setup
Make sure the clusters already created.
Then create the deployment

```shell
$ kubectl create -f fibgo-app.yaml --record
```

## Reference
- [Continuous Delivery in a microservice infrastructure with Google Container Engine, Docker and Travis](https://medium.com/google-cloud/continuous-delivery-in-a-microservice-infrastructure-with-google-container-engine-docker-and-fb9772e81da7#.oshvetvvq)
