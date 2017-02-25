IMAGE_NAME=fibgo
CONTAINER_NAME=fibgo-server

build:
	@docker build -t $(IMAGE_NAME) .

run:
	@docker run --rm -it $(IMAGE_NAME)

start:
	@docker run -d -name $(CONTAINER_NAME) $(IMAGE_NAME)

stop:
	@docker stop $(CONTAINER_NAME)
	@docker rm -v $(CONTAINER_NAME)
