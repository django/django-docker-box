DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.mysql',
        'USER': 'root',
        'PASSWORD': '',
        'NAME': 'django',
        'HOST': 'mysql-gis-db',
        'TEST': {
            'CHARSET': 'utf8',
        },
    },
    'other': {
        'ENGINE': 'django.contrib.gis.db.backends.mysql',
        'USER': 'root',
        'PASSWORD': '',
        'NAME': 'django2',
        'HOST': 'mysql-gis-db',
        'TEST': {
            'CHARSET': 'utf8',
        },
    },
}

SECRET_KEY = "django_tests_secret_key"

# Use a fast hasher to speed up tests.
PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.MD5PasswordHasher',
]

GEOIP_PATH = '/geolite2/'

TEST_RUNNER = 'xmlrunner.extra.djangotestrunner.XMLTestRunner'
TEST_OUTPUT_DIR = '/tests/results/'
DEFAULT_AUTO_FIELD = 'django.db.models.AutoField'
USE_TZ = False
