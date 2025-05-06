#!/bin/sh
: "${ENGINE=docker}"
: "${EMACS=30.1}"
: "${IMAGE=devcontainer-test}"
INIT_VOLUME="devcontainer-test-elpa$EMACS"
volume_tip() {
  local images
  images="$($ENGINE volume ls -q)"
  if ! grep "$INIT_VOLUME" >/dev/null <<< "$images"; then
    printf "to cache cask packages: %s volume create %s\n" "$ENGINE" "$INIT_VOLUME"
  fi
}
volume_tip
exec ${ENGINE} run \
     --rm \
     --mount=type=volume,source="$INIT_VOLUME",target=/root/.emacs.d \
     --mount=type=bind,source="$(dirname "$0")",target=/devcontainer.el \
     --workdir /devcontainer.el \
     "$([ "$ENGINE" = podman ] && printf "%s" "--security-opt=label=disable")" \
     "${IMAGE}:${EMACS}" "$@"
