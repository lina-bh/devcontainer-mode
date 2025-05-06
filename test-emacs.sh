#!/bin/sh
: "${ENGINE=docker}"
: "${EMACS=30.1}"
exec ${ENGINE} run \
     --rm \
     --mount=type=volume,source=devcontainer-test-elpa"${EMACS}",target=/root/.emacs.d/elpa \
     --mount=type=bind,source="$(dirname "$0")",target=/devcontainer.el \
     --workdir /devcontainer.el \
     devcontainer-test:"${EMACS}" cask emacs --batch "$@"
