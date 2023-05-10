ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.18

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG PARSEDMARC_VERSION

ENV PARSEDMARC_VERSION=${PARSEDMARC_VERSION:-"master"} \
    PARSEDMARC_REPO_URL=https://github.com/domainaware/parsedmarc \
    IMAGE_NAME="tiredofit/parsedmarc" \
    IMAGE_REPO_URL="https://github.com/tiredofit/parsedmarc/"

RUN source assets/functions/00-container && \
    set -x && \
    addgroup -S -g 36272 parsedmarc && \
    adduser -D -S -s /sbin/nologin \
            -h /dev/null \
            -G parsedmarc \
            -g "parsedmarc" \
            -u 36272 parsedmarc \
            && \
    \
    package update && \
    package upgrade && \
    package install .parsedmarc-build-deps \
                    build-base \
                    git \
                    py3-pip \
                    py3-hatchling \
                    python3-dev \
                    && \
    \
    package install .parsedmarc-run-deps \
                    libffi \
                    py3-six \
                    py3-parsing \
                    python3 \
                    && \
    \
    clone_git_repo "${PARSEDMARC_REPO_URL}" "${PARSEDMARC_VERSION}" && \
    hatchling build && \
    pip install \
                --upgrade \
                dist/*.whl && \
    \
    package remove .parsedmarc-build-deps \
                    && \
    package cleanup && \
    rm -rf /root/.cache \
           /usr/src/*

COPY install /
