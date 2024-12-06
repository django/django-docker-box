import os


def _build_databases_setting():
    engine = os.environ["DATABASE_ENGINE"]
    host = os.environ.get("DATABASE_HOST", "")
    name = os.environ.get("DATABASE_NAME", "")
    settings = {}

    for n, alias in enumerate(("default", "other"), start=1):
        settings[alias] = entry = {"ENGINE": engine}

        if not engine.endswith((".sqlite", ".spatialite")):
            entry |= {
                "HOST": host,
                "NAME": "django" if n < 2 else f"django{n}",
                "USER": "django",
                "PASSWORD": "django",
            }

        if engine.endswith(".mysql"):
            entry["TEST"] = {"CHARSET": "utf8"}

        if engine.endswith(".oracle"):
            entry |= {
                "NAME": name,
                "TEST": {
                    "USER": f"{alias}_test",
                    "TBLSPACE": f"{alias}_test_tbls",
                    "TBLSPACE_TMP": f"{alias}_test_tbls_tmp",
                },
            }

    return settings


CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.locmem.LocMemCache",
    },
    "pymemcache": {
        "BACKEND": "django.core.cache.backends.memcached.PyMemcacheCache",
        "LOCATION": "memcached-1:11211",
        "KEY_PREFIX": "pymemcache:",
    },
    "pylibmc": {
        "BACKEND": "django.core.cache.backends.memcached.PyLibMCCache",
        "LOCATION": "memcached-2:11211",
        "KEY_PREFIX": "pylibmc:",
    },
}

DATABASES = _build_databases_setting()

DEFAULT_AUTO_FIELD = "django.db.models.AutoField"

PASSWORD_HASHERS = ["django.contrib.auth.hashers.MD5PasswordHasher"]

SECRET_KEY = "django_tests_secret_key"

USE_TZ = False

if os.environ.get("XUNIT", "0").lower() in {"1", "on", "true", "yes"}:
    TEST_RUNNER = "xmlrunner.extra.djangotestrunner.XMLTestRunner"
    TEST_OUTPUT_DIR = "/tests/results"
