#!/bin/bash


set -e

docker build -t asia.gcr.io/${PROJECT_NAME_PRD}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT

echo $GCLOUD_SERVICE_KEY_PRD | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --keyfile ${HOME}/gcloud-service-key.json

gcloud --quite config set project $PROJECT_NAME_PRD
gcloud --quite config set container/cluster $CLUSTER_NAME_PRD
gcloud --quite config set compute/zone $CLOUDSDK_COMPUTE_ZONE
gcloud --quite container clusters get-credentials $CLUSTER_NAME_PRD

gcloud docker push -- asia.gcr.io/${PROJECT_NAME_PRD}/${DOCKER_IMAGE_NAME}

yes | gcloud beta container images add-tag asia.gcr.io/${PROJECT_NAME_PRD}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT asia.gcr.io/${PROJECT_NAME_PRD}/${DOCKER_IMAGE_NAME}:latest

kubectl config view
kubectl config current-context

kubectl set image deployment/${KUBE_DEPLOYMENT_NAME} ${KUBE_DEPLOYMENT_CONTAINER_NAME}=asia.gcr.io/${PROJECT_NAME_PRD}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT

# sleep 30
# yarn run e2e_test
