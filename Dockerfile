# Rebuild to publish a multi-arch (amd64/arm64) branch-main image so ECS tasks
# can run on Graviton (ARM64). See cloudnativedaysjp/dreamkast-infra ARM switch.
FROM golang:1.25-bookworm AS builder

WORKDIR /root

COPY otelcol/ otelcol/

WORKDIR /root/otelcol
RUN go build -o otelcol .

FROM debian:13-slim

WORKDIR /mnt

# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m -s /bin/bash -U nonroot \
  && chown nonroot:nonroot /etc \
  && chown nonroot:nonroot /mnt

USER nonroot

COPY --from=builder /root/otelcol/otelcol /usr/local/bin/otelcol

ENTRYPOINT ["/usr/local/bin/otelcol", "--config=/mnt/otelcol-config.yaml"]
