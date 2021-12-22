VERSION := $(shell yq e ".version" manifest.yaml)

.DELETE_ON_ERROR:

all: lndg.s9pk

install: lndg.s9pk
        embassy-cli package install lndg.s9pk

lndg.s9pk: manifest.yaml assets/compat/config_spec.yaml assets/compat/config_rules.yaml image.tar instructions.md
        embassy-sdk pack lndg.s9pk

instructions.md: README.md
        cp README.md instructions.md

Dockerfile: Dockerfile
        patch -u Dockerfile -i lndg.patch

image.tar: Dockerfile docker_entrypoint.sh
        docker build --tag start9/lndg/main:$(VERSION) .
        docker save -o image.tar start9/lndg/main:$(VERSION)