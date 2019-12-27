SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c  
.ONESHELL:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

out/.prod.sentinel: $(shell find lib -type f) $(shell find config -type f)
	mkdir -p $(@D)
	MIX_ENV=prod
	mix compile
	touch $@


_build/prod/rel/hive_backend/bin/hive_backend: out/.prod.sentinel
	MIX_ENV=prod
	mix release

out/.secrects.sentinel: config/prod.secret.exs
	scp config/prod.secret.exs elixir-prod@tofu.wtf:secrets/hive_backend
	ssh elixir-prod@tofu.wtf "ln -fs /home/elixir-prod/secrets/hive_backend/prod.secret.exs /home/elixir-prod/builds/hive_backend/config/prod.secret.exs"
	touch $@


deploy: out/.prod.sentinel out/.secrects.sentinel
	# ssh elixir-prod@tofu.wtf rm -rf /home/elixir-prod/builds/hive_backend
	ssh elixir-prod@tofu.wtf "cd /home/elixir-prod/builds/hive_backend && git pull && MIX_ENV=prod mix release"