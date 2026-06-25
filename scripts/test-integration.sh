#!/usr/bin/env bash
# Verifica i contratti pubblici tra assembler ed emulatori usando checkout
# sibling. Non scarica dipendenze applicative e non modifica i repository.
set -euo pipefail

workspace="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
asm_dir="${RETRONET_ASM_DIR:-$workspace/retronet-asm}"
cpu4004_dir="${RETRONET_4004_DIR:-$workspace/go-4004}"
cpu8008_dir="${RETRONET_8008_DIR:-$workspace/retronet-8008}"

# In CI il checkout usa il nome pubblico; localmente il repository storico si
# chiama ancora go-4004.
if [[ ! -d "$cpu4004_dir" && -d "$workspace/retronet-4004" ]]; then
  cpu4004_dir="$workspace/retronet-4004"
fi

for dir in "$asm_dir" "$cpu4004_dir" "$cpu8008_dir"; do
  if [[ ! -f "$dir/go.mod" ]]; then
    echo "repository richiesto non trovato: $dir" >&2
    exit 1
  fi
done

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

(cd "$asm_dir" && go build -o "$tmp/retronet-asm" ./cmd/retronet-asm)
(cd "$cpu4004_dir" && go build -o "$tmp/retronet-4004" ./cmd/retronet-4004)
(cd "$cpu8008_dir" && go build -o "$tmp/retronet-8008" ./cmd/retronet-8008)

"$tmp/retronet-asm" build "$asm_dir/examples/calcolatrice-completa.asm" -o "$tmp/calcolatrice-4004.rom"
out4004="$(printf '1.5+2.25=' | "$tmp/retronet-4004" -io "$tmp/calcolatrice-4004.rom")"
if [[ "$out4004" != *"3.75"* ]]; then
  echo "integrazione 4004 fallita: output inatteso" >&2
  echo "$out4004" >&2
  exit 1
fi

"$tmp/retronet-asm" build "$asm_dir/examples/i8008-calc.asm" -o "$tmp/calcolatrice-8008.rom"
out8008="$("$tmp/retronet-8008" -bin "$tmp/calcolatrice-8008.rom" -terminal-input '6*7=' -steps 100000)"
if [[ "$out8008" != *"42profile=generic"* ]]; then
  echo "integrazione 8008 fallita: output inatteso" >&2
  echo "$out8008" >&2
  exit 1
fi

echo "integrazione RetroNet completata: 4004=3.75, 8008=42"
