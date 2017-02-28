#!/bin/bash

set -e

docker build -t asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_STG}:$TRAVIS_COMMIT

echo $GCLOUD_SERVICE_KEY | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --keyfile ${HOME}/gcloud-service-key.json

gcloud --quite config set project $PROJECT_NAME
gcloud --quite config set container/cluster $CLUSTER_NAME_STG
gcloud --quite config set compute/zone $CLOUDSDK_COMPUTE_ZONE
gcloud --quite container clusters get-credentials $CLUSTER_NAME_STG

gcloud docker push -- asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_STG}

yes | gcloud beta container images add-tag asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_STG}:$TRAVIS_COMMIT asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_STG}:latest

kubectl config view
kubectl config current-context

kubectl set image deployment/${KUBE_DEPLOYMENT_NAME} ${KUBE_DEPLOYMENT_CONTAINER_NAME}=asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_STG}:$TRAVIS_COMMIT

sleep 30
yarn run e2e_test
