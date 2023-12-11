# django-docker-box

[![Build Status](https://travis-ci.org/django/django-docker-box.svg?branch=main)](https://travis-ci.org/django/django-docker-box)

Run the django test suite across multiple databases.

Inspired by [django-box](https://github.com/django/django-box) this project contains 
some compose definitions to quickly run the Django test suite across multiple Python and
database versions, including Oracle.

## Quickstart

Clone this repository and ensure you have docker and docker-compose installed. If
you are using Windows, see the [notes below](#usage-on-windows) before continuing.

### Environment

You must set the `DJANGO_PATH` environment variable to the path of your local Django checkout.
This can either be added to the `.env` file, or interactively set in your shell, like so:

`export DJANGO_PATH=~/projects/django/`

### Running tests

You can now either download the latest image used on the CI servers with the dependencies pre-installed:

`docker-compose pull sqlite`

Or build it yourself:

`docker-compose build sqlite`

Then run the following command to test against SQLite:

`docker-compose run --rm sqlite`

All arguments are passed to `runtests.py`. Before they are run all specific dependencies are 
installed (and cached across runs).

### Different databases

Simply substitute `sqlite` for any supported database:

`docker-compose run --rm postgres [args]`

`docker-compose run --rm mysql [args]`

`docker-compose run --rm mariadb [args]`

And if you're mad you can run all the tests for all databases in parallel:

`docker-compose up`

### Setting versions

A common source of issues is testing using a version of Python, or a database version,
which is unsupported by your local Django checkout. The default versions set in the
repository `.env` file should always reflect the minimum requirements of the latest
development version of Django, however it is worth checking that these are correct
if you are having trouble.

For convenience, you may quickly change between different Python and database versions
by setting the appropriate environment variables inline, for example:

`PYTHON_VERSION=3.12 POSTGRES_VERSION=15 docker-compose pull postgres`

Or use the following command to run the tests immediately:

`PYTHON_VERSION=3.12 POSTGRES_VERSION=15 docker-compose run --rm postgres`

## Usage on Windows

Some additional configuration is necessary to enable the use of this utility on Windows.
The following environment variables will need to be added to the `.env` file in the
repository root:

* `PWD` set to the path of the root of this repository [^1]
* `DOCKER_DEFAULT_PLATFORM=linux/amd64` [^2]

For example:

```env
PWD=C:\Users\username\Projects\django-docker-box
DOCKER_DEFAULT_PLATFORM=linux/amd64
```

[^1]: On Linux and macOS, but not of Windows, `PWD` refers to the local directory. 
[^2]: `apt-get` does not work on Windows. Setting `DOCKER_DEFAULT_PLATFORM=linux/amd64` enables the dependencies defined in the `Dockerfile` to be installed.

## Testing against Oracle

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
| `POSTGRES_VERSION` | `12` | The version of Postgres to use |
| `MYSQL_VERSION` | `8` | The mysql version to use |
| `MARIADB_VERSION` | `10.4` | The mariadb version to use |

## Why?

I prefer using docker over Vagrant and virtualbox, which is what django-box uses. I think this 
approach is also simpler to quickly change the various database/python versions the test suite 
runs across. However both approaches work, so use whatever floats your boat.
