IMAGE_NAME=fibgo
CONTAINER_NAME=fibgo-server

build:
	@docker build -t $(IMAGE_NAME) .

run:
	@docker run --rm -it -p 8080:8080 $(IMAGE_NAME)

start:
	@docker run -d --name $(CONTAINER_NAME) -p 8080:8080 $(IMAGE_NAME)

stop:
	@docker stop $(CONTAINER_NAME)
	@docker rm -v $(CONTAINER_NAME)

init-config:
	@gcloud auth activate-service-account --key-file kurio-gcp.json
	@gcloud --quiet config set project kurio-dev
	@gcloud --quiet config set compute/zone asia-east1-a

init-cluster-stg:
	@gcloud container --project "kurio-dev" clusters create "fibgo-cluster-stg" --zone "asia-east1-a" --machine-type "n1-standard-1" --image-type "GCI" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --network "default" --enable-cloud-logging --enable-cloud-monitoring

init-cluster-prod:
	@gcloud container --project "kurio-dev" clusters create "fibgo-cluster" --zone "asia-east1-a" --machine-type "n1-standard-1" --image-type "GCI" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --network "default" --enable-cloud-logging --enable-cloud-monitoring

init-clusters: init-cluster-stg init-cluster-prod

init-image:
	@docker build -t fibgo .
	@docker tag fibgo asia.gcr.io/kurio-dev/fibgo
	@gcloud docker -- push asia.gcr.io/kurio-dev/fibgo

init-deployment-stg:
	@gcloud --quiet config set container/cluster fibgo-cluster-stg
	@kubectl create -f fibgo-app.yaml --record

init-deployment-prod:
	@gcloud --quiet config set container/cluster fibgo-cluster
	@kubectl create -f fibgo-app.yaml --record

init-deployments: init-deployment-stg init-deployment-prod

init-cloud: init-config init-clusters init-image init-deployments
