#!/usr/bin/env bash
# Migrazione globale dell'ecosistema RetroNet su una macchina nuova.
#
# Clona (o aggiorna) tutti i repository come cartelle sibling sotto la stessa
# radice e ricrea i file go.work di sviluppo locale (che NON sono versionati,
# perche' puntano a percorsi specifici della macchina).
#
# Idempotente: si puo' rilanciare quando serve. Non scarica gli asset esterni
# (BIOS, dataset di test): quelli vanno presi a mano, vedi la fine.
set -euo pipefail

org="https://github.com/retronet-labs"
# Radice di lavoro = cartella che contiene questo repo vetrina.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Repo GitHub : cartella locale. Il 4004 sta storicamente in "go-4004".
repos=(
  "retronet-logic:retronet-logic"
  "retronet-hardware:retronet-hardware"
  "retronet-4004:go-4004"
  "retronet-8008:retronet-8008"
  "retronet-8080:retronet-8080"
  "retronet-8086:retronet-8086"
  "retronet-pc:retronet-pc"
  "retronet-asm:retronet-asm"
  "retronet-cpm:retronet-cpm"
  "retronet-terminal:retronet-terminal"
  "retronet-api:retronet-api"
  "retronet-ui:retronet-ui"
  "retronet:retronet"
)

echo "Radice di lavoro: $root"
echo
echo "== Clono / aggiorno i repository =="
for entry in "${repos[@]}"; do
  name="${entry%%:*}"; dir="${entry##*:}"
  target="$root/$dir"
  if [[ -d "$target/.git" ]]; then
    echo "  [pull]  $dir"
    git -C "$target" fetch --quiet --tags origin || true
    git -C "$target" pull --quiet --ff-only || echo "         (salto: pull non fast-forward, controlla a mano)"
  else
    echo "  [clone] $name -> $dir"
    git clone --quiet "$org/$name.git" "$target"
  fi
done

# Mappa: percorso del modulo Go -> cartella locale (per ricreare i go.work).
echo
echo "== Rigenero i go.work di sviluppo locale =="
declare -A mod2dir
for entry in "${repos[@]}"; do
  dir="${entry##*:}"
  gomod="$root/$dir/go.mod"
  [[ -f "$gomod" ]] || continue
  mod="$(awk 'NR==1 && $1=="module"{print $2}' "$gomod")"
  [[ -n "$mod" ]] && mod2dir["$mod"]="$root/$dir"
done

for entry in "${repos[@]}"; do
  dir="${entry##*:}"
  repo="$root/$dir"
  gomod="$repo/go.mod"
  [[ -f "$gomod" ]] || continue
  # Dipendenze sibling retronet-labs effettivamente presenti come checkout,
  # escludendo il modulo stesso.
  uses=()
  while read -r mod; do
    d="${mod2dir[$mod]:-}"
    [[ -n "$d" && "$d" != "$repo" ]] && uses+=("$d")
  done < <(grep -oE 'github\.com/retronet-labs/[a-z0-9-]+' "$gomod" | sort -u)
  if [[ ${#uses[@]} -gt 0 ]]; then
    names=""; for u in "${uses[@]}"; do names+=" ${u##*/}"; done
    echo "  [go.work] $dir ->$names"
    rm -f "$repo/go.work" "$repo/go.work.sum"
    (cd "$repo" && go work init . "${uses[@]}") || echo "         (go work init fallito; Go installato?)"
  fi
done

echo
echo "== Asset esterni (NON in git) da procurarsi a mano =="
echo "  - BIOS GLaBIOS (XT, GPLv3) per retronet-pc:"
echo "      https://github.com/640-KB/GLaBIOS   (testato: release 0.4.2 8X)"
echo "      uso:  go run ./cmd/retronet-pc -bios <ROM> -floppy <img>"
echo "  - SingleStepTests (TomHarte) per retronet-8086:"
echo "      https://github.com/SingleStepTests/8088   (file v2/*.json.gz)"
echo "      uso:  go run ./cmd/retronet-8086 -testsuite <dir>"
echo
echo "Fatto. Verifica l'integrazione con:"
echo "  bash \"$root/retronet/scripts/test-integration.sh\""
