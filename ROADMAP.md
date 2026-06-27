# Roadmap RetroNet

Questa roadmap aggiorna il piano originale allo stato reale dei repository gia creati.

## Fase 0 - Vetrina e fondazione

- [x] Creare organization `retronet-labs`.
- [x] Pubblicare `retronet-4004`.
- [x] Pubblicare `retronet-asm`.
- [x] Creare repo vetrina `retronet`.
- [x] Aggiungere una demo (transcript reale della calcolatrice in `assets/demos/`).
- [ ] Aggiungere screenshot e diagrammi reali (immagini).
- [ ] Creare issue template e label GitHub.
- [ ] Creare project board.

## Fase 1 - Stabilizzare `retronet-4004`

- [x] Implementare il set completo di 46 istruzioni Intel 4004.
- [x] Modellare ROM e RAM virtuali.
- [x] Aggiungere CLI per eseguire ROM.
- [x] Aggiungere trace/debugger integrato.
- [x] Aggiungere esempi e testdata.
- [x] Aggiungere Dockerfile.
- [x] Taggare release `v0.1.0` e `v0.2.0`.
- [x] Pubblicare la demo (output) nella vetrina ([assets/demos/calcolatrice-4004.md](assets/demos/calcolatrice-4004.md)).

## Fase 2 - Stabilizzare `retronet-asm`

- [x] Implementare lexer.
- [x] Implementare parser.
- [x] Implementare symbol table.
- [x] Implementare emitter a due passate.
- [x] Implementare backend `i4004`.
- [x] Aggiungere esempi `.asm`.
- [x] Validare output contro ROM golden di `retronet-4004`.
- [x] Firmware calcolatrice completa in assembly (`+ − × ÷`, BCD) eseguibile su `retronet-4004 -io`.
- [x] Taggare release `v0.1.0` e `v0.2.0`.
- [x] Direttiva `.org` per il page alignment (programmi `.asm` > 256 byte).
- [x] Calcolatrice: virgola fissa (decimali) e segno negativo.
- [ ] Algoritmi `×`/`÷` efficienti (oggi O(valore)).
- [x] Backend `i8008` (ALU + immediati, salti/CALL/condizionati, RST, INP/OUT, `.equ`).
- [x] Backend `i8080`, direttive `.com`/`.orgbase` e `.include` per esempi CP/M-like.

## Fase G - Fondamenta gate-level (logic + hardware)

- [x] `retronet-logic`: gate NOT/AND/OR/NAND/NOR/XOR, half adder, full adder.
- [x] `retronet-logic`: tipo Bus, sommatore a N bit (ripple-carry), multiplexer.
- [x] `retronet-logic`: ALU combinatoria con flag Carry/Zero/Sign/Parity. Tag `v0.3.0`.
- [x] `retronet-hardware`: latch SR, D latch, D flip-flop (master-slave).
- [x] `retronet-hardware`: registro, register file, Program Counter, memoria.
- [x] `retronet-hardware`: mini-CPU a 8 bit (datapath + control + ISA). Tag `v0.2.0`.
- [x] Delega ALU: 4004 e 8008 eseguono l'aritmetica sulla ALU a porte (bridge + test di conformità).
- [x] Shifter in `retronet-logic` + delega delle rotazioni (RAL/RAR/RLC/RRC) di 4004 e 8008; SHL/SHR nella mini-CPU.
- [ ] Estendere l'ISA della mini-CPU (CALL/RET, stack) e un mini-assembler dedicato.

## Fase C - Consolidamento ecosistema

- [x] Aggiungere CI a `retronet-4004`, `retronet-asm` e `retronet-8008`.
- [x] Aggiungere un test end-to-end assembler -> 4004/8008 nel repo vetrina.
- [x] Allineare il requisito Go e lo stato di `.equ` nella documentazione.
- [x] Preparare la checklist di release `retronet-8008` v0.1.0.
- [ ] Validare un campione 8008 contro un secondo emulatore indipendente.
- [ ] Taggare `retronet-8008` v0.1.0 dopo CI verde sul commit candidato.
- [x] Pubblicare `retronet-8080` v0.1.1 con ALU gate/native e validazione 8080EXM.
- [x] Pubblicare `retronet-cpm` v0.1.0, completare il subset BDOS file read-only
  v0.2, v0.3 con write opt-in, v0.4 con terminale condiviso, v0.4.1 con
  conformance estesa e v0.4.2 con sessioni API-ready e limiti sul drive host.

## Fase 3 - Terminale retro

- [x] Creare `retronet-terminal`.
- [x] Implementare terminal core con snapshot/resize.
- [x] Implementare output buffer e input handling.
- [x] Aggiungere supporto ANSI base.
- [x] Aggiungere demo locale.
- [x] Preparare `retronet-cpm/session` come bridge programmatico verso API.
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

- [x] `retronet-8008`: secondo emulatore storico (delega l'ALU alla libreria a porte).
- [x] `retronet-8080`: base per CP/M-like.
- [x] `retronet-cpm`: shell educativa con comandi `DIR`, `TYPE`, `RUN`, BDOS file
  read/write opt-in, console condivisa via `retronet-terminal`, sessioni API-ready
  e limiti configurabili sui drive host.
- [ ] `retronet-bbs`: Bulletin Board System locale/Telnet.
- [ ] `retronet-http`: HTTP 0.9/1.0 educativo.
- [ ] `retronet-browser`: browser testuale storico.
- [ ] `retronet-gopher`: server/client Gopher.
- [ ] `retronet-dns`: DNS educativo.
- [ ] `retronet-netlab`: simulatori di nodi, router, link e pacchetti.
