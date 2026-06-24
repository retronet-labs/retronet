#!/usr/bin/env bash
# Esegue alcune demo dell'ecosistema RetroNet: porte logiche, ALU e mini-CPU.
# Clona i repo necessari in una cartella temporanea (poi la rimuove).
# Requisiti: Go 1.25+ e git.
set -euo pipefail

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "== Clono retronet-logic e retronet-hardware =="
git clone --depth 1 https://github.com/retronet-labs/retronet-logic "$tmp/logic"
git clone --depth 1 https://github.com/retronet-labs/retronet-hardware "$tmp/hardware"

echo
echo "== Porte logiche (tabelle di verita') =="
( cd "$tmp/logic" && go run ./examples/gates )

echo
echo "== ALU a 8 bit (operazioni + flag) =="
( cd "$tmp/logic" && go run ./examples/alu )

echo
echo "== Mini-CPU: somma 1+2+3+4+5 (risultato in mem[0x20]) =="
( cd "$tmp/hardware" && go run ./examples/cpu )

echo
echo "Demo completate."
