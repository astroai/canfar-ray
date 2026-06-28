.PHONY: help build-all build/% push-all push/% test-local test-containers test-all

SHELL := bash
OWNER ?= astroai
REGISTRY ?= images.canfar.net
TAG ?= $(shell date -u +%y.%m)
BUILD_TAG ?= local
BASE_TAG ?= 26.06

export OWNER REGISTRY BASE_TAG

ALL_IMAGES := ray-manager ray-worker-cpu
IMAGE_PREFIX := $(REGISTRY)/$(OWNER)

help:
	@echo "CANFAR Ray containers (extends astroai/base)"
	@echo "  make build-all          build ray-base + manager + worker"
	@echo "  make push-all           tag and push manager + worker to Harbor"
	@echo "  make test-local         local Ray head + worker join smoke test"
	@echo "  make test-containers    validate image layout"
	@echo ""
	@echo "  BASE_TAG=$(BASE_TAG)  BUILD_TAG=$(BUILD_TAG)  TAG=$(TAG)"

build-all:
	TAG=$(BUILD_TAG) docker buildx bake

build/%:
	TAG=$(BUILD_TAG) docker buildx bake $(notdir $@)

push-all: $(addprefix push/,$(ALL_IMAGES))

push/ray-base:
	@echo "ERROR: ray-base is build-only; push ray-manager and ray-worker-cpu." >&2
	@exit 1

push/%:
	docker tag $(IMAGE_PREFIX)/$(notdir $@):$(BUILD_TAG) $(IMAGE_PREFIX)/$(notdir $@):$(TAG)
	docker push $(IMAGE_PREFIX)/$(notdir $@):$(TAG)
	docker tag $(IMAGE_PREFIX)/$(notdir $@):$(BUILD_TAG) $(IMAGE_PREFIX)/$(notdir $@):latest
	docker push $(IMAGE_PREFIX)/$(notdir $@):latest

test-containers: build-all
	./scripts/test-containers.sh

test-local: build-all
	./scripts/test-local.sh

test-all: test-containers test-local
