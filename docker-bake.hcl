# CANFAR Ray images — build with: docker buildx bake

variable "REGISTRY" {
  default = "images.canfar.net"
}

variable "OWNER" {
  default = "astroai"
}

variable "TAG" {
  default = "local"
}

variable "BASE_TAG" {
  default = "26.06"
}

group "default" {
  targets = ["ray-manager", "ray-worker-cpu"]
}

target "ray-base" {
  context    = "."
  dockerfile = "dockerfiles/ray-base/Dockerfile"
  tags       = ["${REGISTRY}/${OWNER}/ray-base:${TAG}"]
  args = {
    REGISTRY = "${REGISTRY}"
    OWNER    = "${OWNER}"
    BASE_TAG = "${BASE_TAG}"
  }
}

target "_ray" {
  context = "."
  contexts = {
    "${REGISTRY}/${OWNER}/ray-base:${TAG}" = "target:ray-base"
  }
  args = {
    REGISTRY = "${REGISTRY}"
    OWNER    = "${OWNER}"
    TAG      = "${TAG}"
  }
}

target "ray-manager" {
  inherits   = ["_ray"]
  dockerfile = "dockerfiles/ray-manager/Dockerfile"
  tags       = ["${REGISTRY}/${OWNER}/ray-manager:${TAG}"]
}

target "ray-worker-cpu" {
  inherits   = ["_ray"]
  dockerfile = "dockerfiles/ray-worker-cpu/Dockerfile"
  tags       = ["${REGISTRY}/${OWNER}/ray-worker-cpu:${TAG}"]
}
