DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'oracle-db:1521/xe',
        'USER': 'system',
        'PASSWORD': 'oracle',
        'TEST': {
            'USER': 'default_test',
            'TBLSPACE': 'default_test_tbls',
            'TBLSPACE_TMP': 'default_test_tbls_tmp',
        },
    },
    'other': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'oracle-db:1521/xe',
        'USER': 'system',
        'PASSWORD': 'oracle',
        'TEST': {
            'USER': 'other_test',
            'TBLSPACE': 'other_test_tbls',
            'TBLSPACE_TMP': 'other_test_tbls_tmp',
        },
    },
}

SECRET_KEY = "django_tests_secret_key"

# Use a fast hasher to speed up tests.
PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.MD5PasswordHasher',
]

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    },
    'memcached': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': 'memcached:11211',
        'KEY_PREFIX': '1:'
    },
    'memcached_2': {
        'BACKEND': 'django.core.cache.backends.memcached.PyLibMCCache',
        'LOCATION': 'memcached2:11211',
        'KEY_PREFIX': '2:'
    }
}

TEST_RUNNER = 'xmlrunner.extra.djangotestrunner.XMLTestRunner'
TEST_OUTPUT_DIR = '/tests/results/'
DEFAULT_AUTO_FIELD = 'django.db.models.AutoField'
USE_TZ = False
