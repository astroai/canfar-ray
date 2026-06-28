# syntax=docker/dockerfile:1
# CANFAR Ray common layer — extends astroai/base (CADC, canfar-lab, session profile).
# astroai/python is build-only (slim + uv/pixi); not published to Harbor.

ARG REGISTRY=images.canfar.net
ARG OWNER=astroai
ARG BASE_TAG=26.06

FROM ${REGISTRY}/${OWNER}/base:${BASE_TAG}

ARG RAY_VERSION=2.43.0

LABEL org.opencontainers.image.title="CANFAR Ray Base" \
      org.opencontainers.image.description="Ray + astronomy deps on AstroAI base" \
      io.astroai.ray.version="${RAY_VERSION}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY config/ray-deps.txt /opt/astroai/ray-deps.txt
RUN uv python install 3.12 \
    && uv venv /opt/astroai/venv/ray --python 3.12 \
    && uv pip install --python /opt/astroai/venv/ray -r /opt/astroai/ray-deps.txt \
    && rm /opt/astroai/ray-deps.txt \
    && /opt/astroai/venv/ray/bin/python -c "import ray; print('ray', ray.__version__)"

ENV PATH="/opt/astroai/venv/ray/bin:/opt/astroai/venv/cadc/bin:${PATH}"

COPY worker/start-worker.sh /opt/astroai/bin/start-ray-worker.sh
COPY scripts/ray-head-start.sh /opt/astroai/bin/ray-head-start.sh
COPY examples/ /opt/astroai/examples/
RUN chmod a+rx /opt/astroai/bin/start-ray-worker.sh /opt/astroai/bin/ray-head-start.sh
