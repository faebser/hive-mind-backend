SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c  
.ONESHELL:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# stuff
APP_VSN:=$(shell grep 'version:' mix.exs | cut -d '"' -f2)
APP_NAME:=$(shell grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g')

out/.prod.sentinel: $(shell find lib -type f) $(shell find config -type f)
	mkdir -p $(@D)
	MIX_ENV=prod
	mix compile
	touch $@


_build/prod/rel/hive_backend/bin/hive_backend: out/.prod.sentinel
	MIX_ENV=prod
	mix release

rel/db.sentinel:
	ssh root@tofu.wtf su -c "psql -c \"CREATE ROLE my_user WITH LOGIN PASSWORD 'my_password' \"" postgres
	touch rel/db.sentinel


rel/artifacts/$(APP_NAME)-$(APP_VSN).tar.gz: $(shell find lib -type f) $(shell find config -type f) /var/run/docker.sock rel/config.exs
	@echo "bulding $(APP_VSN) for $(APP_NAME)"
	@echo "running docker build"
	sudo docker run -v $(shell pwd):/opt/build --rm -it elixir-alpine:latest /opt/build/bin/build
	sudo chown faebser:faebser rel/artifacts/$(APP_NAME)-$(APP_VSN).tar.gz

/var/run/docker.sock:
	sudo systemctl start docker


deploy: rel/artifacts/$(APP_NAME)-$(APP_VSN).tar.gz 
	scp rel/artifacts/$(APP_NAME)-$(APP_VSN).tar.gz elixir-prod@tofu.wtf:releases
	ssh elixir-prod@tofu.wtf mkdir -p /home/elixir-prod/deploy/$(APP_NAME)
	ssh elixir-prod@tofu.wtf tar -xzf /home/elixir-prod/releases/$(APP_NAME)-$(APP_VSN).tar.gz -C /home/elixir-prod/deploy/$(APP_NAME)
	ssh elixir-prod@tofu.wtf ln -fs /home/elixir-prod/deploy/$(APP_NAME)/lib/$(APP_NAME)-$(APP_VSN)/priv/static static


stop:
	ssh elixir-prod@tofu.wtf ./deploy/hive_backend/bin/hive_backend stop

start:
	ssh elixir-prod@tofu.wtf ./deploy/hive_backend/bin/hive_backend start