#!/bin/sh
# Podman-native local Hugo server. Not Docker, not compose.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$root"

image=localhost/coffee-site:dev
podman build -f Containerfile.dev -t "$image" .
exec podman run --rm -it --replace --name coffee-site-dev \
  -p 1313:1313 \
  -v "$root":/src:Z \
  "$image"
