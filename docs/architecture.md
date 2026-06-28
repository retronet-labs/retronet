# Architettura

RetroNet usa repository separati per mantenere ogni modulo indipendente, testabile e pubblicabile con una propria roadmap.

## Repository

| Repository | Responsabilita |
| --- | --- |
| `retronet` | Vetrina, manifesto, roadmap, architettura e link ai sotto-progetti. |
| `retronet-logic` | Logica combinatoria: porte, sommatori, multiplexer e ALU. |
| `retronet-hardware` | Logica sequenziale, mini-CPU e bridge ALU per gli emulatori. |
| `retronet-4004` | Emulatore Intel 4004 in Go. |
| `retronet-8008` | Emulatore Intel 8008, profili macchina, debugger e periferiche. |
| `retronet-8080` | Emulatore Intel 8080, profili macchina, debugger e validazione diagnostica CP/M. |
| `retronet-asm` | Assembler modulare multi-architettura. |
| `retronet-cpm` | Ambiente CP/M-like didattico sopra `retronet-8080`, con sessioni API-ready e terminale live locale. |
| `retronet-terminal` | Terminale testuale condiviso: input queue, output raw, snapshot, resize, schermo, ANSI base e runner live riusabile. |
| `retronet-ui` | Dashboard web React/TypeScript. |
| `retronet-api` | Backend Go per health check, session manager, REST command, run asincrono, input/output sessione e websocket terminale. |
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
    |
    v
retronet-terminal/live -> retronet-cpm/session -> shell -> BDOS subset -> retronet-terminal
```

`retronet-terminal` resta indipendente dai dettagli CPU/BDOS: i repo come
`retronet-cpm` lo usano tramite adattatori, mentre il futuro websocket vivra' in
`retronet-api`. Per le sessioni CP/M-like, `retronet-api` dovra' usare il package
`retronet-cpm/session`: ricevera' input dal websocket, eseguira' comandi o run loop
controllati e pubblichera' snapshot/output del terminale senza accedere direttamente
al core CPU.

`retronet-terminal/live` e' il modello locale gia funzionante: raw mode e output
a delta oggi alimentano `retronet-cpm-live`; domani lo stesso schema verra'
sostituito da websocket in `retronet-api`.

`retronet-api v0.2.0` implementa gia il primo ponte remoto interattivo: crea
sessioni CP/M-like temporanee, espone comandi REST sincroni, `run` asincrono,
input/output terminale e messaggi websocket JSON per output, stato e snapshot.

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
- Il terminale non include ROM, font, terminfo o asset storici proprietari.
- L'API orchestra sessioni e websocket, ma non sostituisce i moduli CLI.
- L'API deve creare drive temporanei o radici esplicite con limiti di dimensione e
  numero file, senza esporre path host arbitrari agli utenti remoti.
- Il laboratorio Docker compone moduli gia funzionanti.
- I contratti tra assembler ed emulatori sono verificati end-to-end dal repo
  `retronet`, senza introdurre dipendenze Go tra i core CPU.
