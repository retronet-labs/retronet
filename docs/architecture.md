# Architettura

RetroNet usa repository separati per mantenere ogni modulo indipendente, testabile e pubblicabile con una propria roadmap.

## Repository

| Repository | Responsabilita |
| --- | --- |
| `retronet` | Vetrina, manifesto, roadmap, architettura e link ai sotto-progetti. |
| `retronet-4004` | Emulatore Intel 4004 in Go. |
| `retronet-asm` | Assembler modulare multi-architettura. |
| `retronet-terminal` | Terminale retro locale e web. |
| `retronet-ui` | Dashboard web React/TypeScript. |
| `retronet-api` | Backend Go per websocket, sessioni e health check. |
| `retronet-lab` | Docker Compose del laboratorio completo. |

## Flusso previsto del Web Lab

```text
Browser con xterm.js
    |
    | WebSocket
    v
retronet-api
    |
    v
terminal session / emulator / BBS / CP/M-like
```

## Strategia Docker

Ogni repo eseguibile dovrebbe avere il proprio `Dockerfile`. Il repo `retronet-lab` li collega con Docker Compose:

```text
retronet-ui    -> porta 3000
retronet-api   -> porta 8080
retronet-4004  -> servizio demo CPU
```

Profili futuri:

- `bbs`
- `web1991`
- `full`

## Confini dei moduli

- Gli emulatori devono restare utilizzabili da CLI anche senza UI.
- L'assembler deve produrre ROM eseguibili dagli emulatori.
- Il terminale non deve conoscere dettagli interni delle CPU.
- L'API orchestra sessioni e websocket, ma non sostituisce i moduli CLI.
- Il laboratorio Docker compone moduli gia funzionanti.
