# RetroNet

**RetroNet** e un ecosistema open source didattico per ricostruire l'evoluzione dell'informatica, dai primi microprocessori alle reti storiche:

```text
4004 -> 8008 -> 8080 -> CP/M-like -> terminali -> BBS -> Gopher -> HTTP storico -> primo Web
```

L'obiettivo non e soltanto scrivere emulatori, ma costruire una piattaforma piccola, testabile e componibile: ogni modulo deve poter vivere da solo, essere documentato bene e integrarsi in un laboratorio locale avviabile con Docker Compose.

> Rebuild the past to understand the present.

## Stato attuale

RetroNet parte da due moduli gia disponibili:

| Modulo | Stato | Descrizione |
| --- | --- | --- |
| [retronet-4004](https://github.com/retronet-labs/retronet-4004) | Attivo | Emulatore Intel 4004 in Go con set istruzioni completo, CLI, tracing, RAM virtuale, esempi e test. |
| [retronet-asm](https://github.com/retronet-labs/retronet-asm) | Attivo | Assembler modulare multi-architettura con backend `i4004`, parser, lexer, symbol table, emitter a due passate ed esempi. |

> **Demo di punta — calcolatrice da tavolo in assembly i4004.** Una calcolatrice
> multi-cifra completa (`retronet-asm/examples/calcolatrice-completa.asm`) scritta in
> assembly, assemblata con `retronet-asm` ed eseguita sull'emulatore `retronet-4004`
> in modalità interattiva (`-io`): input a più cifre, aritmetica **BCD** e i quattro
> operatori `+ − × ÷`. È la validazione end-to-end della coppia assembler ↔ emulatore.
>
> ```bash
> retronet-asm build calcolatrice-completa.asm -o calc.rom
> echo 99*99= | retronet-4004 -io calc.rom    # -> 9801
> echo 144/12= | retronet-4004 -io calc.rom   # -> 12
> ```

I prossimi moduli previsti sono:

| Modulo | Scopo |
| --- | --- |
| `retronet-terminal` | Terminale retro locale e web, collegabile a emulatori, BBS e ambienti CP/M-like. |
| `retronet-ui` | Dashboard web React/TypeScript con terminale browser, stato servizi e topologia rete. |
| `retronet-api` | Backend Go per websocket, sessioni terminale, health check e orchestrazione servizi. |
| `retronet-lab` | Ambiente Docker Compose del sistema completo, avviabile localmente con un comando. |

## Esperienza finale

La demo completa dovra permettere a un utente di clonare un repository laboratorio, avviare i servizi e usare RetroNet dal browser:

```bash
git clone https://github.com/retronet-labs/retronet-lab.git
cd retronet-lab
docker compose up
```

Poi:

```text
http://localhost:3000
```

Da li l'utente potra esplorare emulatori CPU, terminali retro, BBS, HTTP storico, browser testuale, DNS educativo e una rete simulata.

## Architettura dell'ecosistema

RetroNet e organizzato come una costellazione di repository piccoli:

```text
retronet
  manifesto, roadmap, architettura e link ai moduli

retronet-4004
  emulatore Intel 4004

retronet-asm
  assembler multi-architettura

retronet-terminal
  terminale retro locale/web

retronet-ui
  dashboard browser

retronet-api
  backend websocket e sessioni

retronet-lab
  Docker Compose e demo integrate
```

Il principio guida e semplice: meglio un modulo piccolo ma completo che dieci moduli iniziati e lasciati a meta.

## Documentazione

- [Visione](docs/vision.md)
- [Architettura](docs/architecture.md)
- [Milestone](docs/milestones.md)
- [Riferimenti](docs/references.md)
- [Roadmap](ROADMAP.md)
- [Contribuire](CONTRIBUTING.md)

## Competenze dimostrate

- Emulazione CPU e architettura dei computer
- Go, CLI, test e progettazione modulare
- React, TypeScript, dashboard web e terminale via browser
- Docker, Docker Compose e ambienti riproducibili
- Networking, websocket, Telnet, DNS e protocolli testuali storici
- Documentazione tecnica, roadmap e collaborazione open source

## Licenza

RetroNet e distribuito con licenza MIT. Vedi [LICENSE](LICENSE).
