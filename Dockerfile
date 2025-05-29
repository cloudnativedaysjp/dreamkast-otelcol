FROM golang:1.24-bookworm AS builder

WORKDIR /root

COPY otelcol/ otelcol/

WORKDIR /root/otelcol
RUN go build -o otelcol .

FROM gcr.io/distroless/base-debian12:nonroot

COPY --from=builder /root/otelcol/otelcol /urs/local/bin/otelcol

ENTRYPOINT ["/usr/local/bin/otelcol", "--config=/etc/otelcol-config.yaml"]
