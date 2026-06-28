# Milestone

## Fondamenta completate

Obiettivo: consolidare le fondamenta gia create.

- `retronet-4004` completo, testato e documentato.
- `retronet-asm` usabile per esempi 4004.
- Repo vetrina `retronet` pubblicato.
- Release iniziali per `retronet-4004` e `retronet-asm`.
- Output demo aggiunti agli asset.
- Core 8008, timing, debugger e conformance esaustiva completati.
- Stack gate-level completato fino alla mini-CPU e ai bridge ALU.
- Core 8080 validato con diagnostiche CP/M e ambiente `retronet-cpm` pubblicato.
- `retronet-terminal` v0.4.0 pubblicato come core testuale indipendente con
  snapshot/resize, package `live` riusabile e client websocket
  `retronet-terminal-api`.
- `retronet-cpm` v0.5.0 pubblicato con sessioni API-ready, limiti configurabili
  sui drive host e terminale live locale `A>`.
- `retronet-api` v0.2.0 pubblicato con health, session manager, sessioni
  CP/M-like temporanee, REST command, run asincrono, input/output terminale e
  websocket terminale.

## Prossima milestone: consolidamento e terminale

Obiettivo: arrivare al primo laboratorio web minimale.

- CI su tutti i moduli Go e test end-to-end dell'ecosistema.
- Release iniziale di `retronet-8008`.
- `retronet-terminal` base e comando live locale, indipendenti dalle CPU.
  (completato)
- Bridge programmatico `retronet-cpm/session` pronto per essere orchestrato da API.
- Shell CP/M-like live locale sopra `retronet-terminal/live`. (completato)
- `retronet-api` con websocket, sessioni e flusso interattivo v0.2.0. (completato)
- `retronet-terminal-api` collegato a `retronet-api` per sessioni CP/M-like
  remote da console locale. (completato)
- `retronet-ui` minimale con terminale browser.
- `retronet-lab` con Docker Compose per dashboard, API e demo 4004.

## Milestone completata: Intel 8080 e CP/M-like

Obiettivo: espandere dal 4004 verso sistemi piu ricchi.

- Backend `i8080` in `retronet-asm`.
- Emulatore 8080 instruction-accurate con profilo macchina generico.
- Primo ambiente CP/M-like educativo.

## Milestone successiva: terminale e laboratorio web

Obiettivo: rendere interattivo l'ecosistema dal browser.

- Terminale web maturo.
- `retronet-terminal` base, indipendente dalle CPU.
- `retronet-api` con websocket, sessioni e flusso interattivo v0.2.0.
- `retronet-terminal-api` come client websocket locale per API.
- `retronet-ui` minimale con terminale browser.
- Docker Lab presentabile come demo portfolio.

## Orizzonte lungo

Obiettivo: trasformare RetroNet in un ecosistema storico completo.

- BBS educativo.
- HTTP 0.9/1.0 e browser testuale.
- DNS educativo.
- Gopher.
- Prime simulazioni NetLab.
- Contributor occasionali e issue ben curate.
