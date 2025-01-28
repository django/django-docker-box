# Django Toolbox

Tooling and test execution support for [Django][0] :unicorn:

:heart: Support Django development by [donating][1] to the Django Software Foundation.


## Highlights

- :test\_tube: Test supported core database backends — MariaDB, MySQL, Oracle, PostgreSQL, SQLite
- :earth\_africa: Test supported core geospatial backends — MariaDB, MySQL, Oracle, PostGIS, SpatiaLite
- :globe\_with\_meridians: Test user interfaces in different browsers using Selenium — Chrome, Edge, Firefox
- :snake: Test using different Python interpreters — CPython, PyPy
- :broom: Execute linting and formatting tools on the Django repository
- :books: Build the project documentation using Sphinx and run spelling and link checkers


## Quickstart

1. Make sure that you have Docker installed.

2. Clone this repository as well as the Django repository, e.g.

   ```console
   $ mkdir ~/Sources
   $ cd ~/Sources
   $ git clone https://github.com/django/django.git
   $ git clone https://github.com/django-docker-box/django-docker-box.git
   $ cd django-docker-box
   ```

> [!IMPORTANT]
> As long as the two repositories are adjacent the Django source repository will be discovered.
> A different path can be specified by setting the `DJANGO_PATH` environment variable.

3. Build the image:

   ```console
   $ docker compose build sqlite
   ```

4. Run the tests:

   ```console
   $ docker compose run --rm sqlite
   ```


## Running Tests

All of the test commands detailed below can be passed additional arguments that
are provided to the `runtests.py` entrypoint. You can see a list of these
arguments by running the following command:

```console
$ docker compose run --rm sqlite --help
```

### Standard Tests

To run the standard set of tests you can use the following commands:

```console
$ docker compose run --rm mariadb
$ docker compose run --rm mysql
$ docker compose run --rm oracle
$ docker compose run --rm postgres
$ docker compose run --rm sqlite
$ docker compose run --rm sqlite-lib
```

Each of the above commands will run the test suite for a different supported
database.

More information about [running the unit tests][7] for Django can be found in
the documentation.


### Geospatial Tests

To run tests on geospatial features you can use the following commands:

```console
$ docker compose run --rm mariadb-gis
$ docker compose run --rm mysql-gis
$ docker compose run --rm oracle-gis
$ docker compose run --rm postgres-gis
$ docker compose run --rm sqlite-gis
```

Each of the above commands will run the test suite for a different supported
geospatial database.

> [!TIP]
> To only run the subset of tests for geospatial features, pass `gis_tests` as
> an argument to specify that only that folder of tests should be collected,
> e.g.
>
> ```console
> $ docker compose run --rm sqlite-gis gis_tests
> ```

More information about [running the GeoDjango tests][9] for Django can be found
in the documentation.


### User Interface Tests

To run tests on user interfaces you can use the following commands:

```console
$ docker compose run --rm chrome
$ docker compose run --rm edge
$ docker compose run --rm firefox
```

Each of the above commands will run the subset of user interface tests for a
different supported web browser. The tests are executed using Selenium.

To capture screenshots of certain test cases used for comparison to avoid
regressions, the `--screenshots` flag can be passed.

More information about [running the Selenium tests][8] for Django can be found
in the documentation.


## Running Tools


### Linting & Formatting

Django uses the following linting and formatting tools: `black`, `flake8`,
`isort`, and `eslint`. To ensure that the correct versions are used, Django
also supports using `pre-commit` which is the mechanism provided here:

```console
$ docker compose run --rm pre-commit
```

You can run individual tools by passing them as an argument:

```console
$ docker compose run --rm pre-commit black
$ docker compose run --rm pre-commit blacken-docs
$ docker compose run --rm pre-commit isort
$ docker compose run --rm pre-commit flake8
$ docker compose run --rm pre-commit eslint  # XXX: Currently not working.
```

More information about Django's [coding style][5] can be found in the
documentation.

### Building Documentation

Documentation for Django is built using Sphinx. Run the following to see the
available commands:

```console
$ docker compose run --rm sphinx
```

You may find the following builders particularly useful when working on
documentation improvements:

```console
$ docker compose run --rm sphinx dirhtml
$ docker compose run --rm sphinx spelling
$ docker compose run --rm sphinx linkcheck
```

The `BUILDDIR` environment variable has been set to generate output into the
`./output/docs` path under this repository instead of the usual location in the
Django source repository. You can alter this environment variable to generate
to a different path if required.

More information about [writing documentation][6] for Django can be found in
the documentation.


### Other

To enter a shell within the container, run:

```console
$ docker compose run --rm --entrypoint=bash sqlite
```

## Configuration

The build of the container image can be customized by setting the following
environment variables:

| Environment Variable    | Default Value | Description                                          |
| ----------------------- | ------------- | ---------------------------------------------------- |
| `DJANGO_PATH`           | `../django`   | Path to the Django repostory on your local machine   |
| `PYTHON_IMPLEMENTATION` | `python`      | Implementation of Python to use — `python` or `pypy` |
| `PYTHON_VERSION`        | `3.12`        | Version of Python container image to use             |

The versions of various backend services can be switched by setting these environment variables:

| Environment Variable    | Default Value | Description                                          |
| ----------------------- | ------------- | ---------------------------------------------------- |
| `MARIADB_VERSION`       | `10.5`        | Version of MariaDB container image to use            |
| `MYSQL_VERSION`         | `8.0`         | Version of MySQL container image to use              |
| `ORACLE_VERSION`        | `23.5.0.0`    | Version of Oracle container image to use             |
| `POSTGRESQL_VERSION`    | `14`          | Version of PostgreSQL container image to use         |
| `POSTGIS_VERSION`       | `3.1`         | Version of PostGIS extension to use                  |
| `SQLITE_VERSION`        | `3.31.0`      | Version of SQLite to compile and use                 |

> [!NOTE]
>
> Using a specific SQLite version requires compiling it from source. To
> customize the `CFLAGS` used for the compilation, you can set the
> `SQLITE_CFLAGS` environment variable. See the [`.env`][10] file for its
> default value. For more details, see [SQLite Versions](#SQLite-Versions).

### Python Versions

The `PYTHON_VERSION` environment variable controls which version of Python you
are running the tests against, e.g.

```console
$ PYTHON_VERSION=3.12 docker compose run --rm sqlite
```

In addition, it's possible to select a different implementation of Python, i.e.
PyPy instead of CPython, by setting the `PYTHON_IMPLEMENTATION` environment
variable, e.g.

```console
$ PYTHON_IMPLEMENTATION=pypy docker compose run --rm sqlite
```

Be warned, however, that support for PyPy is not as complete and there are more
restrictions with respect to the range of versions available.

### Database Versions

Most database container images are pulled from [Docker Hub][2]. Oracle database
is pulled from the [Oracle Container Registry][3]. Specific versions of SQLite
are compiled directly from the tags in the [official Git mirror][11].

You can switch the version of the database you test against by changing the
appropriate environment variable. Available options and their defaults can be
found in the [configuration section](#Configuration).

> [!WARNING]
> Be aware that only a single version of a particular database may be running
> at one time, so you will need to ensure that you tear down the previously
> running instance before starting up the new one, e.g.
>
> ```console
> $ docker compose ps --format='{{.Image}}' postgresql-db
> postgres:13-alpine
> $ docker compose down postgresql-db
> [+] Running 1/1
>  ✔ Container django-docker-box-postgresql-db-1  Removed                    0.2s
> $ POSTGRESQL_VERSION=17 docker compose up --detach postgresql-db
> [+] Running 1/1
>  ✔ Container django-docker-box-postgresql-db-1  Started                    0.3s
> $ docker compose ps --format='{{.Image}}' postgresql-db
> postgres:17-alpine
> ```
>
> Alternatively, run the following to tear down the whole stack before bringing
> up new containers running different versions:
>
> ```console
> $ docker compose down
> ```

> [!NOTE]
>
> Unlike other GIS database backends, for PostgreSQL with PostGIS you will need
> to specify both versions:
>
> ```console
> $ POSTGRESQL_VERSION=17 POSTGIS_VERSION=3.5 docker compose up --detach postgresql-gis-db
> ```

To determine what database versions can be used you can check the release notes
for the branch of Django that you have checked out, or alternatively there is
the [supported database versions][4] page on Django's Trac Wiki.

#### SQLite Versions

SQLite is normally bundled in the Python installation using the version
available on the system where Python is compiled. We use the Python Docker image
based on Debian `bookworm`, which has SQLite 3.40.1.

To use a different version, we compile SQLite from source and load the library
dynamically using `LD_PRELOAD`. There are a few caveats as a result:

- Some SQLite features are only available if certain flags are set during
  compilation. SQLite is known to change these flags in newer releases, such as
  to enable features by default that were previously opt-in. When Python is
  compiled, it inspects the system's SQLite to determine features that are
  included in the `sqlite` module. A mismatch in the module and the dynamically
  loaded library may result in Python failing to load, which may happen if we
  use an SQLite version that is older than the system version.
- Debian and Ubuntu use a custom `CFLAGS` variable to compile their distributed
  SQLite. Historically, Django's CI has only been configured with SQLite
  versions that come with the operating system. If SQLite is compiled with
  different flags, some tests may fail.

We currently work around the above caveats by setting the simplest `CFLAGS`
value that allows all the tests to pass. In the future, the Django codebase may
be more robust when tested against the different SQLite configurations and these
workarounds may no longer be necessary.

Running the tests against a specific SQLite version must be done using the
`sqlite-lib` container instead of `sqlite`.

```console
$ docker compose run --rm sqlite-lib
```

This is done to avoid compiling SQLite when you are not testing against a
specific version.

### Other Versions

For the Memcached, Redis, and Selenium container images, the latest container
image tag is always used.

Where possible, for backend services, we also use Alpine images where available
for smaller image size and sometimes improved performance.


## Roadmap

The following list is a collection of ideas for improvements that could be made
with no promises that they'll be delivered:

- Add a monthly scheduled full test matrix execution using GitHub Actions
- Add support for some third-party databases, e.g. CockroachDB, SQL Server
- Add support for test coverage execution and report generation
- Add support for running accessibility tooling and report generation
- Support report generation during monthly runs and publish to GitHub Pages
- Publish pre-built container images to the GitHub Container Registry
- Support testing against different versions of SQLite and SpatiaLite
- Support running with Podman in addition to Docker
- Support generating screenshots into `./output/screenshots/`


[0]: https://www.djangoproject.com/
[1]: https://www.djangoproject.com/fundraising/
[2]: https://hub.docker.com/search?badges=official&badges=open_source
[3]: https://container-registry.oracle.com/ords/ocr/ba/database/free
[4]: https://code.djangoproject.com/wiki/SupportedDatabaseVersions
[5]: https://docs.djangoproject.com/en/stable/internals/contributing/writing-code/coding-style/
[6]: https://docs.djangoproject.com/en/stable/internals/contributing/writing-documentation/
[7]: https://docs.djangoproject.com/en/stable/internals/contributing/writing-code/unit-tests/#running-the-unit-tests
[8]: https://docs.djangoproject.com/en/stable/internals/contributing/writing-code/unit-tests/#running-the-selenium-tests
[9]: https://docs.djangoproject.com/en/stable/ref/contrib/gis/testing/#geodjango-tests
[10]: .env
[11]: https://github.com/sqlite/sqlite
