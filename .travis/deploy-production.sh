#!/bin/bash

set -e

docker build -t asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_PRD}:$TRAVIS_COMMIT .

echo $GCLOUD_SERVICE_KEY | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json

gcloud --quiet config set project $PROJECT_NAME
gcloud --quiet config set container/cluster $CLUSTER_NAME_PRD
gcloud --quiet config set compute/zone $COMPUTE_ZONE
gcloud --quiet container clusters get-credentials $CLUSTER_NAME_PRD

gcloud docker -- push asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_PRD}

yes | gcloud beta container images add-tag asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_PRD}:$TRAVIS_COMMIT asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_PRD}:latest

kubectl config view
kubectl config current-context

kubectl set image deployment/${KUBE_DEPLOYMENT_NAME} ${KUBE_DEPLOYMENT_CONTAINER_NAME}=asia.gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME_PRD}:$TRAVIS_COMMIT

# Run the test
sleep 30
ip=$(kubectl get service fibgo -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
port=$(kubectl get service fibgo -o jsonpath='{.spec.ports[0].port}')
ADDR=${ip}:${port} yarn run e2e_test
