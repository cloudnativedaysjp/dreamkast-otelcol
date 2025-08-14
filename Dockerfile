FROM golang:1.25-bookworm AS builder

WORKDIR /root

COPY otelcol/ otelcol/

WORKDIR /root/otelcol
RUN go build -o otelcol .

FROM debian:12-slim

WORKDIR /mnt

RUN adduser --disabled-password --gecos "" nonroot \
 && chown nonroot:nonroot /etc \
 && chown nonroot:nonroot /mnt

USER nonroot

COPY --from=builder /root/otelcol/otelcol /usr/local/bin/otelcol

ENTRYPOINT ["/usr/local/bin/otelcol", "--config=/mnt/otelcol-config.yaml"]
