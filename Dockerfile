FROM python:3.6-slim
# environment variables
ENV PYTHONUNBUFFERED=1 DJANGO_SETTINGS_MODULE=project.settings_prod
ENV GUNICORN_CMD_ARGS="--bind=:8000 --workers=4"
ENV PIPENV_VENV_IN_PROJECT=1

# system requirements (libpq-dev - for psycopg2)
RUN set -x \
 # install requirements for build project
 && export REQUIRED_PACKAGES="libpq-dev gdal-bin" \
 && apt-get update \
 && apt-get install --no-install-recommends -y $REQUIRED_PACKAGES \
 # install pipenv
 && pip install --upgrade pip \
 && pip install pipenv

WORKDIR /code
# copy source
ADD . /code/

RUN set -x \
 # install backend requirements via pipenv
 && pipenv --three install \
 # install gunicorn
 && pipenv install gunicorn

EXPOSE 8000
# run gunicorn
CMD ["pipenv", "run", "gunicorn", "project.wsgi"]
