PROJECT_NAME ?= tor
VERSION ?= $(strip $(shell cat VERSION))
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))
DOCKER_IMAGE ?= osminogin/tor-simple
DOCKER_TAG = latest

# Build Docker image
build: docker_build output

# Build and push Docker image
release: docker_build docker_push output

default: docker_build output

docker_build:
	@docker build \
		--compress \
		--force-rm \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VCS_REF=$(GIT_COMMIT) \
		--build-arg VERSION=$(VERSION) \
		--tag $(DOCKER_IMAGE):$(GIT_COMMIT) .
	@echo "Tag $(DOCKER_IMAGE):$(GIT_COMMIT) $(DOCKER_IMAGE):$(DOCKER_TAG)"
	@docker tag $(DOCKER_IMAGE):$(GIT_COMMIT) $(DOCKER_IMAGE):$(DOCKER_TAG)

docker_push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

run:
	@echo 'Starting container $(DOCKER_IMAGE):$(GIT_COMMIT)'
	@docker run --publish 9050:9050 -i $(DOCKER_IMAGE):$(GIT_COMMIT)

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)

.PHONY: release output run docker_build docker_push default build
