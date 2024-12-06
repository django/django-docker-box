ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim-bullseye

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
          libmemcached-dev \
          build-essential \
          libsqlite3-mod-spatialite binutils libproj-dev gdal-bin libgdal28 libgeoip1 \
          default-libmysqlclient-dev default-mysql-client \
          libpq-dev \
          unzip libaio1 \
          libenchant-2-2 \
          gettext \
          git \
          pkg-config \
    && apt-get clean

RUN groupadd -r test && useradd --no-log-init -r -g test test

ENV PIP_NO_CACHE_DIR=off
ENV PYTHONDONTWRITEBYTECODE=1
RUN pip install --upgrade pip

COPY --chown=test:test --from=src tests/requirements/ /requirements/
RUN for f in /requirements/*.txt; do pip install -r $f; done && \
    pip install flake8 flake8-isort sphinx pyenchant sphinxcontrib-spelling selenium unittest-xml-reporting

RUN mkdir --parents /django/{output,source} && chown --recursive test:test /django
USER test:test
ENV DJANGO_SETTINGS_MODULE=settings
ENV PYTHONPATH="${PYTHONPATH}:/django/source/"
VOLUME /django/output
VOLUME /django/source
WORKDIR /django/source/tests
