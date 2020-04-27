#
# Synse Emulator Plugin
#

PLUGIN_NAME    := sandbox
PLUGIN_VERSION := 1.0.1
IMAGE_NAME     := vaporio/sandbox-plugin

GIT_COMMIT ?= $(shell git rev-parse --short HEAD 2> /dev/null || true)
GIT_TAG    ?= $(shell git describe --tags 2> /dev/null || true)
BUILD_DATE := $(shell date -u +%Y-%m-%dT%T 2> /dev/null)
GO_VERSION := $(shell go version | awk '{ print $$3 }')

PKG_CTX := github.com/vapor-ware/sandbox-plugin/vendor/github.com/vapor-ware/synse-sdk/sdk
LDFLAGS := -w \
	-X ${PKG_CTX}.BuildDate=${BUILD_DATE} \
	-X ${PKG_CTX}.GitCommit=${GIT_COMMIT} \
	-X ${PKG_CTX}.GitTag=${GIT_TAG} \
	-X ${PKG_CTX}.GoVersion=${GO_VERSION} \
	-X ${PKG_CTX}.PluginVersion=${PLUGIN_VERSION}


HAS_LINT := $(shell which gometalinter)
HAS_DEP  := $(shell which dep)
HAS_GOX  := $(shell which gox)


#
# Local Targets
#

.PHONY: build
build:  ## Build the plugin Go binary
	go build -ldflags "${LDFLAGS}" -o build/plugin || exit

.PHONY: clean
clean:  ## Remove temporary files
	go clean -v || exit

.PHONY: dep
dep:  ## Verify and tidy gomod dependencies
	go mod verify
	go mod tidy

.PHONY: docker
docker:  ## Build the docker image locally
	GO111MODULE="" docker build -f Dockerfile \
		-t $(IMAGE_NAME):latest \
		-t $(IMAGE_NAME):local . || exit

.PHONY: fmt
fmt:  ## Run goimports on all go files
	find . -name '*.go' -not -wholename './vendor/*' | while read -r file; do goimports -w "$$file" || exit; done

.PHONY: github-tag
github-tag:  ## Create and push a tag with the current plugin version
	git tag -a ${PLUGIN_VERSION} -m "${PLUGIN_NAME} plugin version ${PLUGIN_VERSION}" || exit
	git push -u origin ${PLUGIN_VERSION}

.PHONY: lint
lint:  ## Lint project source files
	golint -set_exit_status ./pkg/... || exit

.PHONY: setup
setup:  ## Install the build and development dependencies and set up vendoring
	go get -u golang.org/x/lint/golint
	go mod init

.PHONY: version
version:  ## Print the version of the plugin
	@echo "$(PLUGIN_VERSION)"

.PHONY: help
help:  ## Print usage information
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.DEFAULT_GOAL := help


#
# CI Targets
#

.PHONY: ci-build
ci-build:
ifndef HAS_GOX
	go get -v github.com/mitchellh/gox
endif
	@ # We currently only use a couple of images; the built set of images can be
	@ # updated if we ever need to support more os/arch combinations
	gox --output="build/${PLUGIN_NAME}_{{.OS}}_{{.Arch}}" \
		--ldflags "${LDFLAGS}" \
		--osarch='linux/amd64 darwin/amd64' \
		github.com/vapor-ware/sandbox-plugin
