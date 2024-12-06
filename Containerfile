ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim-bullseye

COPY --chown=django:django packages.txt /django/
RUN apt-get update \
    && xargs --arg-file=/django/packages.txt apt-get install --no-install-recommends -y \
    && apt-get clean

RUN groupadd -r django && useradd --no-log-init -r -g django django

ENV PIP_NO_CACHE_DIR=off
ENV PYTHONDONTWRITEBYTECODE=1
RUN pip install --upgrade pip

COPY --chown=django:django requirements.txt /django/requirements/extra.txt
COPY --chown=django:django --from=src tests/requirements/ /django/requirements/
COPY --chown=django:django --from=src docs/requirements.txt /django/requirements/docs.txt
RUN for f in /django/requirements/*.txt; do pip install -r $f; done

RUN mkdir --parents /django/{output,source} && chown --recursive django:django /django
USER django:django
ENV DJANGO_SETTINGS_MODULE=settings
ENV PYTHONPATH="${PYTHONPATH}:/django/source/"
VOLUME /django/output
VOLUME /django/source
WORKDIR /django/source/tests
