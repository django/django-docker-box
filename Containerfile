ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim-bullseye

COPY --chown=test:test packages.txt /django/
RUN apt-get update \
    && xargs --arg-file=/django/packages.txt apt-get install --no-install-recommends -y \
    && apt-get clean

RUN groupadd -r test && useradd --no-log-init -r -g test test

ENV PIP_NO_CACHE_DIR=off
ENV PYTHONDONTWRITEBYTECODE=1
RUN pip install --upgrade pip

COPY --chown=test:test requirements.txt /django/requirements/extra.txt
COPY --chown=test:test --from=src tests/requirements/ /django/requirements/
COPY --chown=test:test --from=src docs/requirements.txt /django/requirements/docs.txt
RUN for f in /django/requirements/*.txt; do pip install -r $f; done

RUN mkdir --parents /django/{output,source} && chown --recursive test:test /django
USER test:test
ENV DJANGO_SETTINGS_MODULE=settings
ENV PYTHONPATH="${PYTHONPATH}:/django/source/"
VOLUME /django/output
VOLUME /django/source
WORKDIR /django/source/tests
