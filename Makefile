include .makerc

export PGPASSWORD=postgres
IMAGE_NAME=$(DOCKER_HUB_USERNAME)/$(APP_NAME):latest

local-create-db:
	# create local empty db
	createdb --host=$(LOCAL_POSTGRESS_HOST) --port=$(LOCAL_POSTGRESS_PORT) --username="$(LOCAL_POSTGRESS_USER)" -T template0 $(LOCAL_POSTGRES_DB)

local-drop-db:
	# drop local db
	dropdb --if-exists --host=$(LOCAL_POSTGRESS_HOST) --port=$(LOCAL_POSTGRESS_PORT) --username="$(LOCAL_POSTGRESS_USER)" $(LOCAL_POSTGRES_DB)

local-recreate-db:
	make local-drop-db
	make local-create-db

local-run:
	pipenv shell python manage.py runserver 0.0.0.0:8000

local-migrate:
	pipenv shell python manage.py migrate

local-createsuperuser:
	pipenv shell python manage.py createsuperuser

local-flake8:
	pipenv shell flake8

copy-id:
	ssh-copy-id -p $(REMOTE_PORT) $(REMOTE_USER)@$(REMOTE_HOST)

# build an image and push to docker hub
docker-build:
	docker build -t $(IMAGE_NAME) .
	docker login --username $(DOCKER_HUB_USERNAME) --password $(DOCKER_HUB_PASSWORD)
	docker push $(IMAGE_NAME)

remote-deploy:
	scp docker-compose.yml $(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_COMPOSE)
	scp nginx.conf $(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_NGINX_CONF)
	ssh $(REMOTE_USER)@$(REMOTE_HOST) "docker login --username $(DOCKER_HUB_USERNAME) --password $(DOCKER_HUB_PASSWORD) && docker-compose -f $(REMOTE_COMPOSE) pull && docker-compose -f $(REMOTE_COMPOSE) up -d"

# For testing Dockerfile
# App should be accessible: http://localhost:8000.
# Static files may be unaccessible because gunicorn serves only dynamic content.
# For serving static content use nginx.
local-docker-test:
	docker stop app && \
	docker rm app || true && \
	docker build --no-cache -t $(IMAGE_NAME) . && \
	docker run -d -p 8000:8000 -e DJANGO_SETTINGS_MODULE=project.settings_prod --name=app $(IMAGE_NAME) && \
	chromium http://localhost:8000/

# For testing docker-compose.yml
# App should be accessible with static content: http://localhost.$(APP_NAME)/.
FILE=/etc/hosts
LINE=127.0.0.1       localhost.$(APP_NAME)
local-dockercompose-test:
	grep -qF "$(LINE)" "$(FILE)" || echo "$(LINE)" | sudo tee --append "$(FILE)"
	docker-compose stop && \
	docker-compose rm && \
	docker-compose build --no-cache && \
	docker-compose up -d --force-recreate && docker-compose ps && \
	chromium http://localhost.$(APP_NAME)/
