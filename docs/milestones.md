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
- `retronet-terminal` v0.2.0 pubblicato come core testuale indipendente con
  snapshot/resize e terminale live locale.
- `retronet-cpm` v0.4.2 pubblicato con sessioni API-ready e limiti configurabili
  sui drive host.

## Prossima milestone: consolidamento e terminale

Obiettivo: arrivare al primo laboratorio web minimale.

- CI su tutti i moduli Go e test end-to-end dell'ecosistema.
- Release iniziale di `retronet-8008`.
- `retronet-terminal` base e comando live locale, indipendenti dalle CPU.
  (completato)
- Bridge programmatico `retronet-cpm/session` pronto per essere orchestrato da API.
- `retronet-api` minimale con websocket e sessioni.
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
- `retronet-api` minimale con websocket e sessioni.
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
