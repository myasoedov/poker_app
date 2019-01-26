
IMAGE_NAME=poker-image

DOCKER_RUN=docker run -it --rm \
	   --mount src=`pwd`,target=/app,type=bind \
	   --mount src=poker-deps,target=/app/deps \
	   --mount src=poker-build,target=/app/_build

HIDE_LOGS=-l fatal

force-build:
	docker build --no-cache -t ${IMAGE_NAME} ./

build:
	docker build -t ${IMAGE_NAME} ./

bash: build
	${DOCKER_RUN} ${IMAGE_NAME} bash

iex: build
	${DOCKER_RUN} ${IMAGE_NAME} iex -S mix

interactive: build
	${DOCKER_RUN} ${IMAGE_NAME} mix rank --interactive

test: build
	${DOCKER_RUN} ${IMAGE_NAME}  mix test
