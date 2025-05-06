.POSIX:

ENGINE := docker
EMACS := 30.1
EXTRA_BUILD_FLAGS :=
IMAGE := devcontainer-test

build-test-img: Containerfile.test
	$(ENGINE) build \
		--build-arg=emacs_release=$(EMACS) \
		$(EXTRA_BUILD_ARGS) \
		-t devcontainer-test:$(EMACS) \
		-f Containerfile.test \
		$(PWD)

test-compile:
	env EMACS=$(EMACS) ENGINE=$(ENGINE) ./test-emacs.sh cask build

test:
	env EMACS=$(EMACS) ENGINE=$(ENGINE) ./test-emacs.sh cask exec ert-runner

package-lint: devcontainer.el
	env EMACS=$(EMACS) ENGINE=$(ENGINE) ./test-emacs.sh cask emacs -Q --batch -f package-lint-batch-and-exit $^

checkdoc: devcontainer.el
	env EMACS=$(EMACS) ENGINE=$(ENGINE) ./test-emacs.sh cask emacs --batch \
		--eval '(setq checkdoc-verb-check-experimental-flag nil)' \
		--eval "(checkdoc-file \""$^"\")"

.PHONY: build-test-img test test-compile test-cases test-package-lint test-checkdoc
