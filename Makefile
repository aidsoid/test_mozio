include .makerc

export PGPASSWORD=postgres

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
