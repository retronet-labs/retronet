# Migrazione RetroNet su un nuovo computer

Guida per ricreare l'intero ecosistema su una macchina nuova e riprendere lo
sviluppo senza ricostruire il contesto. Tutto ciò che git porta con sé sta nei
repo; questa pagina copre il resto (struttura sibling, `go.work`, asset esterni).

## TL;DR

```bash
mkdir -p ~/work/source && cd ~/work/source
git clone https://github.com/retronet-labs/retronet.git
bash retronet/scripts/migrate.sh          # Windows: powershell -File retronet\scripts\migrate.ps1
```

Lo script clona/aggiorna **tutti** i moduli come cartelle sibling e rigenera i
`go.work`. Poi procurati gli asset esterni (sotto) e verifica con
`bash retronet/scripts/test-integration.sh`.

## Prerequisiti

- **Go 1.26.2+** (le librerie `retronet-logic`/`retronet-hardware` restano
  compatibili con Go 1.25).
- `git`; per gli esempi interattivi una shell qualsiasi. Su Windows va bene Git
  Bash (per `migrate.sh`) o PowerShell (per `migrate.ps1`).

## Struttura a cartelle sibling

Tutti i repo stanno sotto un'unica radice (es. `C:\work\source` o `~/work/source`).
Il `go.work` di ogni modulo punta ai sibling con percorsi relativi `../<repo>`.

```
source/
├── retronet-logic/      porte logiche (combinatorio)            v0.4.0
├── retronet-hardware/   sequenziale + bridge i4004/i8008/i8086  v0.7.1
├── go-4004/             emulatore 4004 (repo retronet-4004)     v0.3.0
├── retronet-8008/       emulatore 8008
├── retronet-8080/       emulatore 8080                          v0.1.1
├── retronet-8086/       emulatore 8086/8088                     v0.1.1
├── retronet-pc/         IBM PC/XT sopra retronet-8086           (in sviluppo)
├── retronet-asm/        assembler multi-arch (+ i8086)          v0.3.0
├── retronet-cpm/        CP/M-like sopra retronet-8080           v0.5.0
├── retronet-terminal/   terminale condiviso                     v0.4.0
├── retronet-api/        backend HTTP/WebSocket                  v0.4.0
├── retronet-ui/         UI browser                              v0.2.0
└── retronet/            questo repo vetrina (manifesto + script)
```

> Nota: il 4004 si clona nella cartella **`go-4004`** (nome storico locale); il
> repo GitHub è `retronet-4004`. Gli script e `test-integration.sh` gestiscono
> entrambi i nomi.

## go.work (non versionato)

Ogni modulo che dipende da altri repo dell'org usa un `go.work` per il
co-sviluppo locale. **Non è in git** (è specifico della macchina): lo rigenera
`migrate.sh`, oppure a mano dalla cartella del repo, per esempio:

```sh
cd retronet-hardware && go work init . ../retronet-logic
cd retronet-8086     && go work init . ../retronet-hardware ../retronet-logic
cd retronet-pc       && go work init . ../retronet-8086 ../retronet-hardware ../retronet-logic
```

Un clone pulito compila comunque dalle **versioni pubblicate** (i `go.sum`
risolvono da GitHub): il `go.work` serve solo per modificare più repo insieme.
`retronet-asm` e gli emulatori di base non hanno bisogno di `go.work` per
build/test isolati.

## Asset esterni (NON in git)

Sono gitignored (`*.rom`/`*.bin`/`*.img`, dataset) perché grossi o di terze parti:

| Asset | Per | Dove | Uso |
|-------|-----|------|-----|
| **GLaBIOS** (XT, GPLv3) | retronet-pc | [640-KB/GLaBIOS](https://github.com/640-KB/GLaBIOS) — testato **0.4.2 8X** | `go run ./cmd/retronet-pc -bios <ROM> -floppy <img>` |
| **SingleStepTests** (TomHarte) | retronet-8086 | [SingleStepTests/8088](https://github.com/SingleStepTests/8088) — file `v2/*.json.gz` | `go run ./cmd/retronet-8086 -testsuite <dir>` |

I boot sector per retronet-pc si generano con retronet-asm (backend `i8086`):

```bash
cd retronet-asm
go run ./cmd/retronet-asm build examples/i8086-bootok.asm -o bootok.rom
cd ../retronet-pc
go run ./cmd/retronet-pc -bios <GLaBIOS.ROM> -floppy ../retronet-asm/bootok.rom
```

## Verifica

```bash
# per modulo
cd <repo> && go test ./...
# integrazione end-to-end (assembler + emulatori 4004/8008)
bash retronet/scripts/test-integration.sh   # -> 4004=3.75, 8008=42
```

## Handoff per repo

Ogni repo ha un `CLAUDE.md` committato con setup, comandi e stato; i due moduli
nuovi includono una sezione "Setup su una macchina nuova" dedicata:
[retronet-8086](https://github.com/retronet-labs/retronet-8086/blob/main/CLAUDE.md) ·
[retronet-pc](https://github.com/retronet-labs/retronet-pc/blob/main/CLAUDE.md).
