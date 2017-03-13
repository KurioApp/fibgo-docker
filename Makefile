IMAGE_NAME=fibgo:legacy
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
