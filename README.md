# [WIP] Coffee Site

Personal blog for [mre.coffee](http://mre.coffee/). Static Hugo + AsciiDoc (`v0.165.0`).

## Local development

Requires [Podman](https://podman.io/). This starts a live-reload server; it is not the production image.

```bash
./scripts/dev.sh
```

Open http://localhost:1313/

Equivalent commands:

```bash
podman build -f Containerfile.dev -t localhost/coffee-site:dev .
podman run --rm -it --replace --name coffee-site-dev \
  -p 1313:1313 -v "$PWD":/src:Z localhost/coffee-site:dev
```

## Production image

Multi-stage `Containerfile`: Hugo 0.165 + Asciidoctor build, then nginx serving the static site (`baseURL` `https://mre.coffee/`).

CI builds `linux/amd64` and `linux/arm64` and pushes to `quay.io/etsauer/coffee-site`.

```bash
./scripts/prod.sh
```

Open http://localhost:8080/ (page assets use absolute `https://mre.coffee/` URLs, so CSS/images may not load until that host points here).

```bash
podman build -f Containerfile -t localhost/coffee-site:prod .
podman run --rm --replace --name coffee-site-prod -p 8080:80 localhost/coffee-site:prod
```
