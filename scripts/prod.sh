#!/bin/sh
# Build and run the production static image (nginx). Not Docker.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$root"

image=localhost/coffee-site:prod
podman build -f Containerfile -t "$image" .
exec podman run --rm -it --replace --name coffee-site-prod \
  -p 8080:80 \
  "$image"
