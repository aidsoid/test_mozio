"""Production settings and globals."""

from __future__ import absolute_import
from .settings import *

DEBUG = False

# HOST CONFIGURATION
ALLOWED_HOSTS = ['localhost', '127.0.0.1', 'localhost.test_mozio', ]
# END HOST CONFIGURATION


# DATABASE CONFIGURATION
DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'HOST': 'db',
        'PORT': '5432',
        'NAME': 'test_mozio',
        'USER': 'postgres',
        'PASSWORD': 'postgres'
    },
}
# END DATABASE CONFIGURATION
