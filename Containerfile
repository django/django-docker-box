# syntax=docker/dockerfile:1.12

ARG PYTHON_IMPLEMENTATION=python
ARG PYTHON_VERSION=3.13
FROM ${PYTHON_IMPLEMENTATION}:${PYTHON_VERSION}-slim-trixie

LABEL org.opencontainers.image.authors="Django Software Foundation"
LABEL org.opencontainers.image.url="https://github.com/django/django-docker-box"
LABEL org.opencontainers.image.documentation="https://github.com/django/django-docker-box"
LABEL org.opencontainers.image.source="https://github.com/django/django-docker-box"
LABEL org.opencontainers.image.vendor="Django Software Foundation"
LABEL org.opencontainers.image.licenses="BSD-3-Clause"
LABEL org.opencontainers.image.title="Django Docker Box"
LABEL org.opencontainers.image.description="Container image for developing and testing Django."

SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-o", "xtrace", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Force colored output for various tooling in CI.
ENV COLUMNS=120
ENV FORCE_COLOR=1
ENV TERM="xterm-256color"

# Create user and prepare directories.
RUN <<EOF
    useradd --home-dir=/django --no-create-home --no-log-init django
    mkdir --parents /django/{.cache,output,source}
    chown --recursive django:django /django
EOF

# Install system dependencies from package manager.
COPY --chown=django:django packages.txt /django/
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked <<EOF
    rm --force /etc/apt/apt.conf.d/docker-clean
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
    apt-get update --quiet --yes
    xargs --arg-file=/django/packages.txt apt-get install --no-install-recommends --yes
EOF

# Install all Python requirements in a single command.
COPY --chown=django:django requirements.txt /django/requirements/extra.txt
COPY --chown=django:django --from=src tests/requirements/ /django/requirements/
COPY --chown=django:django --from=src docs/requirements.txt /django/requirements/docs.txt
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/
RUN --mount=type=cache,target=/root/.cache/uv <<EOF
    cat /django/requirements/*.txt \
        | grep --invert-match '^#' \
        | sort --unique --version-sort \
        | tee /django/requirements.txt
    uv pip install --requirement=/django/requirements.txt --system
EOF

COPY --chown=django:django entrypoint.bash /django/

SHELL ["/bin/bash", "-c"]

ENV DJANGO_SETTINGS_MODULE=settings
ENV PYTHONPATH="${PYTHONPATH}:/django/source/"
USER django:django
VOLUME /django/output
VOLUME /django/source
WORKDIR /django/source/tests
ENTRYPOINT ["/django/entrypoint.bash"]
