ifdef WORKFLOW
ifeq (${WORKFLOW},testflight)
RESULTING_WORKFLOW := ${WORKFLOW}
endif
ifeq (${WORKFLOW},enterprise)
RESULTING_WORKFLOW := ${WORKFLOW}
endif
ifeq (${WORKFLOW},integrations)
RESULTING_WORKFLOW := ${WORKFLOW}
endif
endif

install-bundle:
	bundle install

install-dependencies:
	bundle exec pod install

setup-hooks:
	./scripts/setup_hooks.sh

rename:
ifndef PROJECT_NAME
	$(error Variable PROJECT_NAME not set")
endif
	./scripts/rename.sh "${PROJECT_NAME}"

setup-ci:
ifneq (${WORKFLOW},${RESULTING_WORKFLOW})
	$(error Unknown workflow ${WORKFLOW}")
endif
ifdef WORKFLOW
	./scripts/setup_ci.sh "${WORKFLOW}"
endif

.PHONY: setup

setup: setup-ci rename setup-hooks install-bundle install-dependencies

.PHONY: install

install: setup-hooks install-bundle install-dependencies
