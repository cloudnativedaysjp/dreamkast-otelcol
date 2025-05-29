# ver. の上げ方

- 以下を確認してリリースされている ver. を把握する
  - https://github.com/open-telemetry/opentelemetry-collector/releases
  - https://github.com/open-telemetry/opentelemetry-collector-contrib/releases
- `go get -u ./...` を実行して builder の ver. を上げる
- `builder-config.yaml` の各モジュールの ver. を上げる
- `make generate-code` を実行して collector のコードを生成する
- `make lint` や `make build` を実行して collector を build できる事を確かめる
- git commit し、pull request を作る
