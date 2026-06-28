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
| `retronet-terminal` | Terminale testuale condiviso: input queue, output raw, snapshot, resize, schermo, ANSI base, runner live riusabile e client websocket API. |
| `retronet-ui` | UI web minimale senza dipendenze esterne, servita da Go, per sessioni RetroNet via API: terminale browser, dashboard sessioni/file e upload `.COM`. |
| `retronet-api` | Backend Go per health check, session manager, REST command, run asincrono, input/output sessione, websocket terminale, CORS locale e upload `.COM` limitato. |
| `retronet-lab` | Docker Compose del laboratorio completo. |

## Flusso previsto del Web Lab

```text
Browser con terminale RetroNet
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
`retronet-cpm` lo usano tramite adattatori, mentre il websocket vive in
`retronet-api`. Per le sessioni CP/M-like, `retronet-api` usa il package
`retronet-cpm/session`: riceve input dal websocket, esegue comandi o run loop
controllati e pubblica snapshot/output del terminale senza accedere direttamente
al core CPU.

`retronet-terminal/live` e' il modello locale gia funzionante: raw mode e output
a delta alimentano `retronet-cpm-live`. Da `retronet-terminal v0.4.0`, il comando
`retronet-terminal-api` collega invece una console host al websocket di
`retronet-api`.

`retronet-api v0.2.0` implementa gia il primo ponte remoto interattivo: crea
sessioni CP/M-like temporanee, espone comandi REST sincroni, `run` asincrono,
input/output terminale e messaggi websocket JSON per output, stato e snapshot.
Insieme a `retronet-terminal-api`, questo rende utilizzabile da console locale
una sessione CP/M-like remota senza introdurre ROM o software storico.

`retronet-api v0.3.0` aggiunge CORS locale configurabile per permettere alla UI
browser di creare sessioni da una porta diversa. `retronet-ui v0.1.0` usa questo
contratto per offrire un primo terminale browser CP/M-like, senza framework o
asset esterni.

`retronet-api v0.4.0` aggiunge tre primitive necessarie al laboratorio web:
lista sessioni, lista file del drive temporaneo e upload multipart di soli
file `.COM`. L'upload passa dalla normalizzazione 8.3 del drive CP/M-like,
rispetta limiti di dimensione/numero file e resta dentro la sessione temporanea:
non vengono inclusi ROM, BIOS, BDOS, dischi o programmi storici.

`retronet-ui v0.2.0` consuma queste primitive con una dashboard minima: stato
API, sessioni attive, file nel drive `A:`, upload `.COM`, cursore visibile nel
terminale browser e scrollback separato dall'immagine 80x24. La UI resta
volutamente senza dipendenze esterne finche' non viene scelto e verificato un
terminale web piu' maturo.

## Strategia Docker

Ogni repo eseguibile dovrebbe avere il proprio `Dockerfile`. Il repo `retronet-lab` li collega con Docker Compose:

```text
retronet-ui    -> porta 18081
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
