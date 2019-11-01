SHELL := /bin/bash

APP_NAME ?= python-multiversion
APP_VERSION ?= $(shell git describe --tags --always --dirty)

ARTIFACTS_HOST ?= localhost
DOCKER_REPO ?= docker-master.$(ARTIFACTS_HOST)

PYTHON_VERSIONS ?= 3.8.0 3.7.5 3.6.9 3.5.7 3.4.10 2.7.17

.PHONY: all
all: build

.PHONY: build
build:
	@echo Building with Python versions $(PYTHON_VERSIONS)
	docker build --build-arg PYTHON_VERSIONS="$(PYTHON_VERSIONS)" \
	             --tag $(APP_NAME):$(APP_VERSION) .

.PHONY: test
test: build
	./test.sh $(APP_NAME):$(APP_VERSION) $(PYTHON_VERSIONS)

.PHONY: publish
publish: build
	docker tag $(APP_NAME):$(APP_VERSION) $(DOCKER_REPO)/$(APP_NAME):$(APP_VERSION)
	docker tag $(APP_NAME):$(APP_VERSION) $(DOCKER_REPO)/$(APP_NAME):latest
	@docker login -u ${ARTIFACTS_USER} \
	              -p ${ARTIFACTS_TOKEN} \
	              $(DOCKER_REPO) 2>/dev/null
	docker push $(DOCKER_REPO)/$(APP_NAME):$(APP_VERSION)
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

.PHONY: clean
clean:
	docker rmi -f $(APP_NAME):$(APP_VERSION)
	docker rmi -f $(DOCKER_REPO)/$(APP_NAME):$(APP_VERSION)
	docker rmi -f $(DOCKER_REPO)/$(APP_NAME):latest
