# Roadmap RetroNet

Questa roadmap aggiorna il piano originale allo stato reale dei repository gia creati.

## Fase 0 - Vetrina e fondazione

- [x] Creare organization `retronet-labs`.
- [x] Pubblicare `retronet-4004`.
- [x] Pubblicare `retronet-asm`.
- [x] Creare repo vetrina `retronet`.
- [ ] Aggiungere screenshot e diagrammi reali.
- [ ] Creare issue template e label GitHub.
- [ ] Creare project board.

## Fase 1 - Stabilizzare `retronet-4004`

- [x] Implementare il set completo di 46 istruzioni Intel 4004.
- [x] Modellare ROM e RAM virtuali.
- [x] Aggiungere CLI per eseguire ROM.
- [x] Aggiungere trace/debugger integrato.
- [x] Aggiungere esempi e testdata.
- [x] Aggiungere Dockerfile.
- [ ] Taggare release `v0.1.0`.
- [ ] Pubblicare screenshot/output demo nella vetrina.

## Fase 2 - Stabilizzare `retronet-asm`

- [x] Implementare lexer.
- [x] Implementare parser.
- [x] Implementare symbol table.
- [x] Implementare emitter a due passate.
- [x] Implementare backend `i4004`.
- [x] Aggiungere esempi `.asm`.
- [x] Validare output contro ROM golden di `retronet-4004`.
- [x] Firmware calcolatrice completa in assembly (`+ − × ÷` multi-cifra, BCD) eseguibile su `retronet-4004 -io`.
- [ ] Taggare release `v0.1.0`.
- [ ] Direttiva `.org` per il page alignment (programmi `.asm` > 256 byte).
- [ ] C3 calcolatrice: virgola/decimali, segno, algoritmi long-mult/long-div.
- [ ] Progettare backend `i8008`.

## Fase 3 - Terminale retro

- [ ] Creare `retronet-terminal`.
- [ ] Implementare terminal core.
- [ ] Implementare output buffer e input handling.
- [ ] Aggiungere supporto ANSI base.
- [ ] Aggiungere demo locale.
- [ ] Preparare websocket bridge.

## Fase 4 - Web Lab minimo

- [ ] Creare `retronet-api`.
- [ ] Implementare `GET /health`.
- [ ] Implementare session manager.
- [ ] Implementare websocket terminale.
- [ ] Creare `retronet-ui`.
- [ ] Integrare xterm.js.
- [ ] Mostrare dashboard con stato servizi.
- [ ] Collegare una demo 4004 dal browser.

## Fase 5 - Docker Lab

- [ ] Creare `retronet-lab`.
- [ ] Collegare `retronet-ui`, `retronet-api` e `retronet-4004`.
- [ ] Aggiungere `.env.example`.
- [ ] Documentare `docker compose up`.
- [ ] Preparare profili futuri per BBS, web storico e laboratorio completo.

## Fasi successive

- [ ] `retronet-8008`: secondo emulatore storico.
- [ ] `retronet-8080`: base per CP/M-like.
- [ ] `retronet-cpm`: shell educativa con comandi `DIR`, `TYPE`, `RUN`.
- [ ] `retronet-bbs`: Bulletin Board System locale/Telnet.
- [ ] `retronet-http`: HTTP 0.9/1.0 educativo.
- [ ] `retronet-browser`: browser testuale storico.
- [ ] `retronet-gopher`: server/client Gopher.
- [ ] `retronet-dns`: DNS educativo.
- [ ] `retronet-netlab`: simulatori di nodi, router, link e pacchetti.
