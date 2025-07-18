FROM golang:1.24-bookworm AS builder

WORKDIR /root

COPY otelcol/ otelcol/

WORKDIR /root/otelcol
RUN go build -o otelcol .

FROM debian:12-slim

RUN adduser --disabled-password --gecos "" nonroot \
 && chown nonroot:nonroot /etc

USER nonroot

COPY --from=builder /root/otelcol/otelcol /usr/local/bin/otelcol

ENTRYPOINT ["/usr/local/bin/otelcol", "--config=/etc/otelcol-config.yaml"]
