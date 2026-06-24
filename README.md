# RetroNet

**RetroNet** è un ecosistema open source didattico per ricostruire l'evoluzione
dell'informatica, dai transistor ai primi microprocessori fino alle reti storiche:

```text
porte logiche -> CPU -> 4004 -> 8008 -> 8080 -> CP/M-like -> terminali -> BBS -> Web storico
```

L'obiettivo non è soltanto scrivere emulatori, ma costruire una piattaforma
piccola, testabile e componibile: ogni modulo deve poter vivere da solo, essere
documentato bene e integrarsi con gli altri.

> Rebuild the past to understand the present.

## Stato attuale

| Modulo | Stato | Descrizione |
| --- | --- | --- |
| [retronet-logic](https://github.com/retronet-labs/retronet-logic) | v0.3.0 | Libreria combinatoria a **porte logiche**: gate (NOT/AND/OR/NAND/NOR/XOR), half/full adder, sommatore a N bit, multiplexer e **ALU** con flag. Zero dipendenze. |
| [retronet-hardware](https://github.com/retronet-labs/retronet-hardware) | v0.2.0 | Strato **sequenziale**: latch, flip-flop, registri, register file, Program Counter e una **mini-CPU a 8 bit** costruita dai gate. Include i *bridge* che collegano gli emulatori alla ALU a porte. |
| [retronet-4004](https://github.com/retronet-labs/retronet-4004) | v0.3.0 | Emulatore Intel 4004 in Go: 46 istruzioni, CLI, tracing, RAM virtuale, I/O interattivo (`-io`). **Delega l'aritmetica alla ALU a porte.** |
| [retronet-8008](https://github.com/retronet-labs/retronet-8008) | — | Emulatore Intel 8008 in Go: decoder, timing, memoria, front panel, suite di conformità. **Delega l'aritmetica alla ALU a porte.** |
| [retronet-asm](https://github.com/retronet-labs/retronet-asm) | v0.2.0 | Assembler modulare multi-architettura (backend `i4004` e `i8008`): lexer, parser, symbol table, emitter a due passate, direttive `.org`/`.equ`. |

## Dai transistor alla CPU

Il cuore di RetroNet è uno **stack costruito dal basso**: ogni livello usa solo
quello sotto, fino a una CPU funzionante fatta di sole porte logiche.

```text
[retronet-logic — combinatorio]
   porte -> half/full adder -> adder N bit -> MUX -> ALU (+ flag)
                                                       │
[retronet-hardware — sequenziale]                      │
   latch -> flip-flop -> registro -> register file -> PC
                                                       │
                                                       v
                                              mini-CPU 8 bit (strutturale)

[emulatori dei chip reali]
   retronet-4004 / retronet-8008  ──(bridge)──►  ALU a porte di retronet-logic
```

Due punti che rendono il progetto particolare:

- **Una CPU vera dai gate.** La mini-CPU di `retronet-hardware` esegue un piccolo
  ISA (load, somma/sottrazione, logica, salti condizionati, halt) con datapath e
  register file costruiti da flip-flop e con l'ALU di `retronet-logic`.
- **Gli emulatori girano sulla stessa ALU a porte.** 4004 e 8008 non calcolano
  l'aritmetica con gli operatori di Go: la **delegano** alla ALU costruita dai
  gate, attraverso adattatori (`bridge/i4004`, `bridge/i8008`) verificati da test
  di conformità esaustivi.

## Demo di punta

**Mini-CPU — somma 1+2+3+4+5.** Un programma in codice macchina eseguito dalla
CPU strutturale (register file + ALU a porte + PC):

```bash
git clone https://github.com/retronet-labs/retronet-hardware
cd retronet-hardware && go run ./examples/cpu
# -> mem[0x20] = 15
```

**Calcolatrice da tavolo in assembly i4004.** Una calcolatrice completa scritta in
assembly, assemblata con `retronet-asm` ed eseguita sull'emulatore `retronet-4004`
in modalità interattiva (`-io`): input decimale, aritmetica BCD a virgola fissa,
i quattro operatori `+ − × ÷` e il segno negativo. È la validazione end-to-end
assembler ↔ emulatore. Transcript: [assets/demos/calcolatrice-4004.md](assets/demos/calcolatrice-4004.md).

```bash
retronet-asm build calcolatrice-completa.asm -o calc.rom
echo 1.5+2.25= | retronet-4004 -io calc.rom   # -> 3.75
echo 7/2=      | retronet-4004 -io calc.rom   # -> 3.50
echo 3-5=      | retronet-4004 -io calc.rom   # -> -2.00
```

## Quickstart

Requisiti: **Go 1.25+**. Assicurati che `$(go env GOPATH)/bin` sia nel `PATH`.

**Installa gli emulatori** (anche con [`scripts/install.sh`](scripts/install.sh)):

```bash
go install github.com/retronet-labs/retronet-4004/cmd/retronet-4004@latest
go install github.com/retronet-labs/retronet-8008/cmd/retronet-8008@latest
```

**Usa le librerie** in un tuo progetto:

```bash
go get github.com/retronet-labs/retronet-logic@latest
go get github.com/retronet-labs/retronet-hardware@latest
```

**Prova le demo** (porte logiche, ALU, mini-CPU) con un comando solo:

```bash
curl -fsSL https://raw.githubusercontent.com/retronet-labs/retronet/main/scripts/demo.sh | bash
# oppure, da un clone di questo repo:  ./scripts/demo.sh
```

## Architettura dell'ecosistema

RetroNet è una costellazione di repository piccoli e completi:

```text
retronet            manifesto, roadmap, architettura e link ai moduli (questo repo)
retronet-logic      libreria a porte logiche (combinatorio): gate -> ALU
retronet-hardware   strato sequenziale: flip-flop -> registri -> mini-CPU + bridge
retronet-4004       emulatore Intel 4004
retronet-8008       emulatore Intel 8008
retronet-asm        assembler multi-architettura
```

Moduli previsti (rete e web storici): `retronet-terminal`, `retronet-ui`,
`retronet-api`, `retronet-lab`. Vedi la [ROADMAP](ROADMAP.md).

## Esperienza finale

La demo completa permetterà di clonare un repository laboratorio, avviare i
servizi e usare RetroNet dal browser:

```bash
git clone https://github.com/retronet-labs/retronet-lab.git
cd retronet-lab
docker compose up   # poi: http://localhost:3000
```

## Documentazione

- [Visione](docs/vision.md)
- [Architettura](docs/architecture.md)
- [Milestone](docs/milestones.md)
- [Riferimenti](docs/references.md)
- [Roadmap](ROADMAP.md)
- [Contribuire](CONTRIBUTING.md)

## Competenze dimostrate

- Architettura dei computer: dalle porte logiche alla CPU, emulazione di chip reali
- Go: librerie, CLI, test esaustivi/di conformità, progettazione modulare multi-repo
- Networking, websocket, Telnet, DNS e protocolli testuali storici (in arrivo)
- Documentazione tecnica, roadmap e collaborazione open source

## Licenza

RetroNet è distribuito con licenza MIT. Vedi [LICENSE](LICENSE).
