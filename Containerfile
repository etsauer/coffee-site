# Production image: Hugo build → static nginx. Not the live-reload dev server.
# Build/run with Podman (see README). Do not use Docker locally.
#
# Hugo runs on the builder's architecture ($BUILDPLATFORM) so multi-arch
# images do not need an arm64 Hugo binary; nginx is the only TARGETARCH stage.
ARG HUGO_VERSION=0.165.0

FROM --platform=$BUILDPLATFORM docker.io/library/ruby:3.2-bookworm AS build
ARG HUGO_VERSION
ARG BUILDARCH=amd64

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && gem install asciidoctor --no-document \
    && wget -qO /tmp/hugo.tgz \
        "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-${BUILDARCH}.tar.gz" \
    && tar -xzf /tmp/hugo.tgz -C /usr/local/bin hugo \
    && rm /tmp/hugo.tgz \
    && hugo version

WORKDIR /src
COPY . .
RUN hugo --gc --minify --baseURL "https://mre.coffee/"

FROM docker.io/library/nginx:1.27-alpine
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/public /usr/share/nginx/html
EXPOSE 80
