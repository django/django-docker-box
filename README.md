# django-docker-box

[![Build Status](https://travis-ci.org/django/django-docker-box.svg?branch=master)](https://travis-ci.org/django/django-docker-box)

Run the django test suite across multiple databases.

Inspired by [django-box](https://github.com/django/django-box) this project contains 
some compose definitions to quickly run the Django test suite across multiple Python and
database versions, including Oracle.

## Quickstart

Clone this repository somewhere. Also make sure you have docker and docker-compose installed.

Ensure that the `DJANGO_PATH` variable points to the root of the Django repo:

`export DJANGO_PATH=~/projects/django/`

If you see a docker-compose warning about it not being defined followed by an error ensure that is defined in the shell you are using.

You can now either download the latest image used on the CI servers with the dependencies pre-installed:

`docker-compose pull sqlite`

Or build it yourself:

`docker-compose build sqlite`

Then simply run:

`docker-compose run --rm sqlite`

All arguments are passed to `runtests.py`. Before they are run all specific dependencies are 
installed (and cached across runs).

## Different databases

Simply substitute `sqlite` for any supported database:

`docker-compose run --rm postgres [args]`

`docker-compose run --rm mysql [args]`

`docker-compose run --rm mariadb [args]`

And if you're mad you can run all the tests for all databases in parallel:

`docker-compose up`

#### Database versions

You can customize the version of the database you test against by changing the appropriate `[db]_VERSION` environment variable. See the Configuration section below for the available options and their defaults.

## Different Python versions

The `PYTHON_VERSION` environment variable customizes which version of Python you are running the tests against. e.g:

`PYTHON_VERSION=3.7 docker-compose run --rm sqlite`

You can also pull the pre-built image in the same way:

`PYTHON_VERSION=3.7 docker-compose pull sqlite`

## Oracle

As usual Oracle is a bit more complex to set up. You need to download the latest `instantclient` **zip file**
[from this page](https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html) and place it inside the 
`./oracle` directory. Ensure only one `.zip` file is present.

The database image is quite large (several gigabytes) and takes a fairly long time to initialise (5-10 minutes). 
Once it has initialised subsequent starts should be very quick. To begin this process run:
 
 `docker-compose run oracle-db`

And wait for it to initialize. Once it has, use ctrl+c to terminate it and execute:

`docker-compose run --rm oracle`

To run the test suite against it. All other databases support different versions, however Oracle does not.

## Utilities

To run the docs spellchecker:

`docker-compose run --rm docs`

Or flake8:

`docker-compose run --rm flake8`

To enter a bash shell within the container, run:

`docker-compose run --rm --entrypoint bash [database]`

## Configuration

| Environment Variable | Default | Description |
| --- | --- | --- |
| `DJANGO_PATH` | None | The path to the Django codebase on your local machine |
| `PYTHON_VERSION` | `3.8` | The python version to run tests against |
| `POSTGRES_VERSION` | `9.6` | The version of Postgres to use |
| `MYSQL_VERSION` | `8` | The mysql version to use |
| `MARIADB_VERSION` | `10.4` | The mariadb version to use |


## Why?

I prefer using docker over Vagrant and virtualbox, which is what django-box uses. I think this 
approach is also simpler to quickly change the various database/python versions the test suite 
runs across. However both approaches work, so use whatever floats your boat.
