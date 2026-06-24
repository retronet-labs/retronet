#!/usr/bin/env bash
# Installa gli emulatori RetroNet (Intel 4004 e Intel 8008).
# Requisiti: Go 1.25+.
set -euo pipefail

echo "Installazione degli emulatori RetroNet..."
go install github.com/retronet-labs/retronet-4004/cmd/retronet-4004@latest
go install github.com/retronet-labs/retronet-8008/cmd/retronet-8008@latest

bin="$(go env GOPATH)/bin"
echo
echo "Fatto. Binari installati in: $bin"
echo "Assicurati che sia nel PATH, poi prova ad esempio:"
echo "  retronet-4004 --help"
echo "  retronet-8008 --help"
