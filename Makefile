
IMAGE_NAME=poker-image

DOCKER_RUN=docker run -it --rm \
	   --mount src=`pwd`,target=/app,type=bind \
	   --mount src=poker-deps,target=/app/deps \
	   --mount src=poker-build,target=/app/_build
DOCKER_PASS_PORTS=-p 4000:4000

force-build:
	docker build --no-cache -t ${IMAGE_NAME} ./
build:
	docker build -t ${IMAGE_NAME} ./

bash: build
	${DOCKER_RUN} ${IMAGE_NAME} bash

iex: build
	${DOCKER_RUN} ${IMAGE_NAME} iex -S mix

web-ui: build
	${DOCKER_RUN} ${DOCKER_PASS_PORTS} ${IMAGE_NAME} mix phx.server

console-ui: build
	${DOCKER_RUN} ${IMAGE_NAME} mix ui.console

test: build
	${DOCKER_RUN} ${IMAGE_NAME}  mix test
