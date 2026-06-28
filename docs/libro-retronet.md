# Libro enciclopedico RetroNet

Versione generata dal workspace locale `C:\work\source`.

Questo libro spiega RetroNet come un percorso didattico completo: dai bit e dalle
porte logiche, ai registri, alle CPU storiche, all'assembly, a CP/M-like, al
terminale, all'API, alla UI browser e al PC/XT. L'obiettivo e' rendere leggibile
il progetto anche a chi parte da zero, senza perdere la precisione tecnica.

## Come leggere questo libro

RetroNet non e' un solo programma. E' una piccola costellazione di repository
indipendenti, ognuno con un confine chiaro. Il modo piu' semplice per capirlo e'
seguirlo dal basso verso l'alto:

```text
bit -> porte -> sommatori -> ALU -> registri -> CPU didattica
    -> 4004 -> 8008 -> 8080 -> 8086/8088 -> PC/XT
    -> assembler -> CP/M-like -> terminale -> API -> UI browser
```

La parola importante e' "componibile". Ogni modulo e' piccolo abbastanza da
essere capito da solo, ma utile anche come mattone di un laboratorio piu'
grande. `retronet-logic` non sa nulla del 4004; costruisce solo logica. Il 4004
non sa nulla della UI; esegue ROM. `retronet-api` non emula CPU; orchestra
sessioni. Questa separazione e' una delle scelte architetturali piu' sane
dell'ecosistema.

Un altro punto da tenere sempre in mente: RetroNet non cerca di "simulare il
passato" copiando ROM proprietarie o dump storici dentro i repo. Quando serve
un BIOS, una diagnostica o una ROM storica, il progetto la lascia fuori dal git
e richiede all'utente di fornirla localmente. Cosi' il codice resta originale,
testabile e pubblicabile.

## Indice

- Capitolo 1: `retronet`, il manifesto dell'ecosistema
- Capitolo 2: `retronet-logic`, dai bit alla ALU
- Capitolo 3: `retronet-hardware`, dallo stato alla mini-CPU
- Capitolo 4: `retronet-4004`, il primo microprocessore della storia RetroNet
- Capitolo 5: `retronet-8008`, una CPU a 8 bit ancora ruvida
- Capitolo 6: `retronet-8080`, il core che apre la porta a CP/M
- Capitolo 7: `retronet-8086`, real mode, segmenti e ALU intercambiabile
- Capitolo 8: `retronet-pc`, un IBM PC/XT sopra l'8088
- Capitolo 9: `retronet-asm`, il traduttore da testo a byte
- Capitolo 10: `retronet-cpm`, un ambiente CP/M-like didattico
- Capitolo 11: `retronet-terminal`, byte, schermo e snapshot
- Capitolo 12: `retronet-api`, sessioni RetroNet via HTTP/WebSocket
- Capitolo 13: `retronet-ui`, il laboratorio nel browser
- Appendici: glossario, flussi end-to-end, comandi, mappa repo, fonti

---

# Capitolo 1 - `retronet`: il manifesto

## Cosa risolve

Il repo `retronet` e' la porta d'ingresso dell'ecosistema. Non contiene un core
CPU, una UI o un emulatore: contiene la visione, la roadmap, l'architettura di
alto livello, i riferimenti e le demo integrate. Serve a rispondere alla domanda
"perche' esistono tutti questi repo separati?".

La risposta breve e': RetroNet vuole ricostruire l'evoluzione dell'informatica
in modo pratico. Non racconta solo che una CPU usa registri, memoria e flag:
costruisce pezzi eseguibili, piccoli e testati, che mostrano quei concetti in
azione.

La traiettoria documentata dal repo e':

```text
porte logiche -> CPU -> 4004 -> 8008 -> 8080 -> CP/M-like
              -> terminali -> BBS -> protocolli testuali -> Web storico
```

Oggi il workspace locale arriva gia' molto avanti: ci sono le fondamenta
gate-level, gli emulatori 4004/8008/8080/8086, un PC/XT in sviluppo, un assembler
multi-architettura, un runtime CP/M-like, un terminale condiviso, API e UI.

## Modello mentale semplice

Immagina RetroNet come una scuola di informatica fatta di laboratori. Ogni aula
ha un oggetto preciso:

- `retronet-logic`: "come fanno i bit a calcolare?"
- `retronet-hardware`: "come fa un circuito a ricordare?"
- `retronet-4004`: "come si programma una CPU a 4 bit?"
- `retronet-8008`: "cosa cambia quando il mondo diventa a 8 bit?"
- `retronet-8080`: "come si arriva a programmi stile CP/M?"
- `retronet-8086` e `retronet-pc`: "come nasce un PC compatibile IBM?"
- `retronet-asm`: "come trasformo assembly leggibile in byte?"
- `retronet-cpm`: "come faccio girare programmi `.COM`?"
- `retronet-terminal`, `retronet-api`, `retronet-ui`: "come lo uso da terminale,
  socket o browser?"

Il repo `retronet` tiene insieme la mappa. Senza mappa, i moduli sembrerebbero
progetti separati. Con la mappa, diventano tappe di un unico percorso.

## Architettura dell'ecosistema

La scelta piu' importante e' il multi-repo. Ogni componente vive in una cartella
separata, con il proprio `go.mod` quando e' codice Go. Questo porta qualche
costo: bisogna gestire versioni, `go.work` locali e compatibilita' tra moduli.
Ma porta un vantaggio enorme: ogni repo resta pubblicabile, testabile e
comprensibile in isolamento.

Il repo vetrina documenta anche i confini:

- gli emulatori devono funzionare da CLI senza UI;
- l'assembler deve produrre byte eseguibili dagli emulatori;
- il terminale non deve conoscere CPU o BDOS;
- l'API orchestra sessioni, ma non sostituisce le CLI;
- la UI parla con l'API, non con i core CPU;
- i contratti end-to-end si verificano nel repo vetrina o nei test di
  integrazione, non fondendo tutti i moduli in un monolite.

Questo e' un principio molto utile per il lettore principiante: quando un pezzo
sembra complicato, chiediti sempre "qual e' il suo confine?". Una volta trovato
il confine, il pezzo si restringe.

## Demo di punta

Il repo documenta due demo che spiegano bene l'anima del progetto.

La prima e' la mini-CPU che somma `1+2+3+4+5` e scrive `15` in memoria. Questa
demo parte dalle porte logiche e arriva a una CPU didattica completa. Non e'
storica, e' strutturale: serve a vedere come nasce una CPU.

La seconda e' la calcolatrice da tavolo in assembly Intel 4004. Qui il percorso
e' diverso: un sorgente assembly viene assemblato da `retronet-asm`, eseguito da
`retronet-4004` e produce risultati decimali BCD. Questa e' una demo
end-to-end: toolchain piu' emulatore piu' programma reale.

## Scelte didattiche

RetroNet sceglie spesso la chiarezza prima della velocita'. L'esempio piu' forte
e' l'ALU a porte logiche. In Go sarebbe banale sommare due byte con `+`; RetroNet
invece costruisce un sommatore a ripple-carry e poi lo usa attraverso bridge per
4004, 8008, 8080 e 8086. Questo non e' il modo piu' veloce di calcolare, ma e' il
modo piu' didattico per mostrare che una CPU reale non "sa" fare `+`: propaga
segnali.

La seconda scelta e' la prudenza sulle licenze. I repo evitano ROM, BIOS,
manuali copiati, font storici e immagini disco proprietarie. Dove servono
asset esterni, sono documentati come prerequisiti locali non versionati.

## Collegamenti con gli altri moduli

`retronet` non importa codice Go dagli altri repo. Li collega a livello di
documentazione, script, roadmap e test di integrazione. E' il punto da cui si
capisce perche' `retronet-terminal` non sta dentro `retronet-cpm`, perche'
`retronet-api` non contiene un terminale proprio, e perche' il PC/XT usa
`retronet-8086` invece di duplicare una CPU.

---

# Capitolo 2 - `retronet-logic`: dai bit alla ALU

## Cosa risolve

`retronet-logic` e' la base matematica e circuitale dell'ecosistema. Implementa
blocchi combinatori: bit, bus, porte logiche, half adder, full adder, sommatore
a N bit, multiplexer, ALU e shifter.

"Combinatorio" significa: niente memoria interna. A parita' di input, l'output
e' sempre lo stesso. Una porta AND non ricorda che cosa le hai dato prima; guarda
solo i due bit che riceve adesso.

## Modello mentale semplice

Un bit e' un filo che puo' essere basso (`0`) o alto (`1`). Una porta logica e'
una piccola regola applicata a uno o piu' fili. Con le porte fai circuiti piu'
grandi. Con circuiti piu' grandi fai sommatori. Con sommatori e porte fai una
ALU. Con una ALU e registri puoi fare una CPU.

La catena e':

```text
Bit -> Bus -> NOT/AND/OR -> NAND/NOR/XOR
    -> Half Adder -> Full Adder -> Adder N bit
    -> ALU -> Shifter
```

## Il tipo `Bit`

Il package `bit` definisce un tipo dedicato, non usa direttamente `bool`.
Questo sembra un dettaglio, ma e' una scelta didattica importante: `bit.One` e
`bit.Zero` parlano il linguaggio dell'hardware, non quello della logica
applicativa.

Un valore `Bit` ha tre operazioni fondamentali:

- creazione da booleano;
- controllo se e' alto;
- stampa come `0` o `1`.

Ogni altro componente usa `Bit`. Cosi' il progetto resta coerente: una porta non
riceve `true`/`false`, riceve segnali.

## Bus: molti bit insieme

Un `bus.Bus` e' una slice di bit. Se un bit e' un filo, un bus e' un fascio di
fili. Un bus a 4 bit puo' rappresentare un nibble, perfetto per il 4004. Un bus
a 8 bit puo' rappresentare un byte, utile per 8008 e 8080. Un bus a 16 bit serve
per pezzi dell'8086.

La conversione tra interi Go e bus e' necessaria per testare e collegare il
mondo didattico al resto del codice. Ma il calcolo interno della logica resta a
bit.

## Porte logiche

Le porte primitive sono:

- `NOT`: inverte un bit;
- `AND`: produce `1` solo se entrambi gli ingressi sono `1`;
- `OR`: produce `1` se almeno un ingresso e' `1`.

Le porte composte sono:

- `NAND`: `NOT(AND(a,b))`;
- `NOR`: `NOT(OR(a,b))`;
- `XOR`: `1` se gli ingressi sono diversi.

`XOR` e' speciale per l'aritmetica: il bit di somma di `1+0` e di `0+1` e' `1`,
mentre `0+0` e `1+1` danno `0` nel bit corrente. Questa e' proprio la tabella
di verita' dello XOR.

## Half adder e full adder

Un half adder somma due bit:

```text
a b | sum carry
0 0 |  0    0
0 1 |  1    0
1 0 |  1    0
1 1 |  0    1
```

La somma e' `XOR(a,b)`. Il carry e' `AND(a,b)`.

Un full adder aggiunge un terzo ingresso: il carry entrante. Serve per sommare
numeri a piu' bit. Il carry che esce dal bit meno significativo entra nel bit
successivo.

## Sommatore ripple-carry

Il sommatore a N bit concatena N full adder. Si chiama ripple-carry perche' il
riporto "increspa" la catena: parte dal bit 0, poi arriva al bit 1, poi al bit 2
e cosi' via. Non e' il circuito piu' veloce possibile, ma e' il piu' facile da
capire.

Esempio mentale a 4 bit:

```text
  0111
+ 0001
------
  1000
```

Il bit basso fa `1+1 = 0` con carry. Il carry entra nel bit successivo e
continua finche' serve. Questo e' esattamente il comportamento che il codice
modella componendo full adder.

## ALU

La ALU e' il cuore del calcolo. In `retronet-logic/alu`, `Compute` riceve:

- operazione (`Add`, `Sub`, `And`, `Or`, `Xor`, `Not`);
- due bus della stessa larghezza;
- carry entrante.

Restituisce:

- bus risultato;
- flag `Carry`, `Zero`, `Sign`, `Parity`.

La sottrazione non usa l'operatore `-` di Go. Usa complemento a due:

```text
a - b = a + NOT(b) + 1
```

Questa formula e' fondamentale per capire quasi tutte le CPU storiche. Il
circuito sa fare una cosa molto bene: sommare. La sottrazione viene trasformata
in una somma.

## Flag

I flag sono piccoli indicatori che descrivono il risultato:

- `Carry`: riporto uscente nell'addizione; nella sottrazione della ALU significa
  "nessun prestito";
- `Zero`: il risultato e' tutto zero;
- `Sign`: il bit piu' alto del risultato;
- `Parity`: numero pari di bit a `1`.

Le CPU storiche non usano tutte la stessa convenzione. Per esempio l'8008
espone il carry come prestito nella sottrazione, mentre l'ALU interna dice
"nessun prestito". Per questo esistono i bridge in `retronet-hardware`.

## Shifter

Lo shifter sposta bit a sinistra o a destra. Per uno spostamento di una sola
posizione non serve una vera porta: basta collegare i fili in modo diverso.

Le funzioni principali sono:

- shift logico a sinistra;
- shift logico a destra;
- rotazione circolare;
- rotazione attraverso carry.

Queste operazioni diventano istruzioni reali nelle CPU: `RAL`, `RAR`, `RLC`,
`RRC`, e negli 8086 anche famiglie piu' ricche di shift e rotate.

## Tour del codice

I pacchetti sono volutamente piccoli:

- `bit`: tipo base;
- `bus`: conversione e rappresentazione multi-bit;
- `gates`: porte;
- `halfadder`, `fulladder`, `adder`: aritmetica binaria;
- `mux`: selezione tra ingressi;
- `alu`: calcolo e flag;
- `shifter`: spostamenti.

Nel codice della ALU la cosa importante e' il `switch` sull'operazione. Le
operazioni aritmetiche passano da `adder.Add`; quelle logiche applicano porte
bit per bit. I flag derivano dal risultato con riduzioni logiche: zero e' una
NOR di tutti i bit, parity e' la negazione di uno XOR ridotto.

## Limiti

`retronet-logic` non simula tempi di propagazione, tensioni, fan-out,
metastabilita' o ritardi reali. E' una libreria didattica digitale ideale. Questo
e' giusto: se introducesse subito il rumore del mondo fisico, il principiante
perderebbe il filo.

## Collegamenti

`retronet-hardware` usa `retronet-logic` per costruire registri, PC e mini-CPU.
I bridge hardware usano la ALU per far calcolare 4004, 8008, 8080 e 8086 "dai
gate". Questa e' una delle idee piu' forti dell'intero ecosistema: anche un PC/XT
puo', con l'opzione giusta, eseguire aritmetica passando dalla ALU costruita a
porte.

---

# Capitolo 3 - `retronet-hardware`: dallo stato alla mini-CPU

## Cosa risolve

`retronet-hardware` prende i blocchi combinatori di `retronet-logic` e aggiunge
la cosa che mancava: lo stato. Una porta calcola e basta; un registro ricorda.
Senza memoria non esiste CPU utile, perche' una CPU deve sapere qual e' la
prossima istruzione, quali valori sono nei registri e dove tornare dopo una
subroutine.

## Modello mentale semplice

La differenza tra `logic` e `hardware` e':

```text
logic:    dati in ingresso -> risultato immediato
hardware: stato interno + clock + ingressi -> nuovo stato
```

Il clock e' il battito. Al fronte giusto, un componente sequenziale cattura un
valore. Questo permette a un circuito di evolvere nel tempo.

## Latch SR

Il latch SR e' la prima cella di memoria. Ha due ingressi: set e reset. Se set e'
attivo, ricorda `1`; se reset e' attivo, ricorda `0`; se nessuno e' attivo,
mantiene il valore precedente.

Il concetto chiave e' la retroazione: l'uscita rientra nel circuito. Questo
sembra quasi un trucco, ma e' il modo con cui un circuito puo' "ricordare".

## D latch e D flip-flop

Il D latch migliora il latch SR: invece di due ingressi separati, ha un dato `D`
e un'abilitazione. Quando il clock e' alto, il latch e' trasparente. Quando il
clock e' basso, conserva.

Il D flip-flop cattura il dato solo sul fronte di salita. Questo e' molto piu'
adatto a costruire registri, perche' tutti i componenti possono aggiornarsi in
un momento ben definito.

## Registri, register file e PC

Un registro a N bit e' un gruppo di flip-flop. Un register file e' un banco di
registri selezionabili. Il Program Counter e' un registro speciale: contiene
l'indirizzo della prossima istruzione e puo' incrementare o caricare un nuovo
indirizzo.

Il PC e' una delle idee piu' semplici e potenti dell'informatica:

```text
leggi istruzione in mem[PC]
PC = PC + lunghezza istruzione
esegui istruzione
```

Un salto e' solo un caricamento diverso del PC.

## Mini-CPU

La mini-CPU di `retronet-hardware` e' una CPU didattica a 8 bit. Non emula un
chip storico: mostra come si monta una CPU usando i pezzi costruiti prima.

Ha:

- dati e indirizzi a 8 bit;
- memoria da 256 byte;
- 4 registri general purpose;
- flag `Zero` e `Carry`;
- ALU di `retronet-logic`;
- PC e stack pointer;
- istruzioni per load, store, ALU, salti, call, ret, shift e halt.

Il ciclo di `CPU.Step()` e':

```text
fetch -> decode -> execute
```

Il fetch legge `mem[PC]` e incrementa il PC. Il decode interpreta nibble alto e
campi registro. Execute compie l'operazione: scrive registri, chiama la ALU,
legge memoria o cambia PC.

## ISA della mini-CPU

L'opcode usa il nibble alto per l'operazione e due campi da 2 bit per registri:

```text
bit 7..4 = opcode
bit 3..2 = registro destinazione
bit 1..0 = registro sorgente
```

Le istruzioni a due byte usano il secondo byte come immediato o indirizzo.

Esempio:

```asm
LDI R0, 0
LDI R1, 5
LDI R2, 1
loop:
ADD R0, R1
SUB R1, R2
JZ end
JMP loop
end:
ST R0, 0x20
HLT
```

Alla fine `mem[0x20] = 15`.

## Stack e subroutine

La mini-CPU ha uno stack in memoria che cresce verso il basso da `0xFF`. `CALL`
salva il PC corrente; `RET` lo recupera. Anche qui il punto didattico e' forte:
una subroutine non e' magia, e' solo un salto con memoria dell'indirizzo di
ritorno.

## Bridge verso CPU storiche

Il repo contiene bridge per adattare l'ALU a porte alle convenzioni delle CPU
storiche:

- `bridge/i4004`;
- `bridge/i8008`;
- `bridge/i8080`;
- `bridge/i8086`.

Un bridge fa tre cose:

1. converte valori Go (`byte`, `uint16`) in `bus.Bus`;
2. chiama la ALU o lo shifter;
3. rimappa i flag secondo la CPU.

Questo e' indispensabile perche' i flag non sono universali. Nel 4004 il carry
della sottrazione ha una convenzione; nell'8008 il flag rappresenta il borrow;
nell'8086 esistono anche Auxiliary Carry e Overflow.

## Bridge 8086

Il bridge i8086 e' il piu' ricco. Supporta operazioni a 8 e 16 bit, gruppi ALU
`ADD/OR/ADC/SBB/AND/SUB/XOR/CMP`, incrementi, decrementi, shift, rotate,
moltiplicazione e divisione.

Moltiplicazione e divisione non sono scorciatoie concettuali: il codice usa
algoritmi classici composti su sommatore a gate:

- moltiplicazione shift-and-add;
- divisione a ripristino.

Questo e' il punto in cui RetroNet diventa quasi provocatorio: non solo somma e
sottrazione, ma anche operazioni piu' grandi vengono riportate ai mattoni di
base.

## Tour del codice

Il file `retronet-hardware\cpu\cpu.go` della mini-CPU e' il migliore per capire il progetto:

- `CPU` contiene register file, PC, SP, memoria e flag;
- `Step` esegue lo switch sugli opcode;
- `fetch` legge memoria e incrementa il PC;
- `aluOp` chiama `alu.Compute`;
- `push` e `pop` aggiornano SP usando l'adder a gate;
- `writeReg`, `writeSP`, `tickPC` simulano cicli di clock completi.

La presenza di `Step` basso/alto nei registri non e' decorazione: e' il modo con
cui il modello esprime il fronte di clock.

## Limiti

La mini-CPU e' volutamente piccola. Non e' pipelined, non e' microcodificata, non
ha interrupt, DMA, cache o bus realistico. Serve a capire l'architettura
fondamentale senza perdersi.

## Collegamenti

`retronet-hardware` sta tra il mondo astratto delle porte e quello degli
emulatori storici. Senza questo repo, gli emulatori potrebbero usare
direttamente `+` e `-`; con questo repo, possono delegare il calcolo a un
datapath didattico.

---

# Capitolo 4 - `retronet-4004` (`go-4004`)

## Cosa risolve

`go-4004` implementa un emulatore Intel 4004. Il 4004 e' una CPU a 4 bit: lavora
su nibble, ha accumulatore a 4 bit, registri a 4 bit, program counter a 12 bit,
stack hardware interno a 3 livelli e istruzioni molto legate al mondo delle
calcolatrici.

Nel workspace il repo si chiama `go-4004`, ma il modulo Go e' pubblicato come
`github.com/retronet-labs/retronet-4004`.

## Modello mentale semplice

Pensare al 4004 come a una CPU moderna in miniatura porta fuori strada. Il 4004
non ha byte come un 8080, non ha uno stack in memoria, non ha RAM lineare
semplice. Vive in un ecosistema MCS-4 con ROM, RAM 4002, porte e registri a
nibble.

Il suo mondo e':

- un accumulatore `A` da 4 bit;
- 16 registri `R0..R15` da 4 bit;
- PC da 12 bit;
- carry;
- stack hardware interno a 3 livelli;
- RAM organizzata per banco, registro, carattere e status;
- molte istruzioni pensate per BCD.

## Nibble

Un nibble e' mezzo byte: 4 bit, valori `0..15`. Il codice usa `uint8`, ma
maschera sempre con `0x0F`. Questa maschera e' fondamentale. Se `A=15` e aggiungi
`1`, il risultato visibile deve tornare a `0` e il carry deve accendersi.

## Fetch e istruzioni a 1 o 2 byte

`CPU4004.Step` legge l'opcode dalla ROM all'indirizzo `PC`, incrementa `PC` e
decide come eseguire. Alcune istruzioni hanno un secondo byte:

- `JCN`;
- `FIM`;
- `JUN`;
- `JMS`;
- `ISZ`.

Altre sono a un byte. `FIN` e `JIN` hanno regole speciali perche' usano coppie
di registri e pagine ROM.

Il 4004 non ha una vera istruzione `HALT`. Nei programmi didattici si usa una
convenzione: salto infinito su se stessi.

```asm
halt:
    JUN halt
```

## Stack a 3 livelli

Lo stack del 4004 non e' memoria. E' interno alla CPU e ha tre slot. `JMS` salva
il ritorno, `BBL` ritorna e carica un valore nell'accumulatore.

Se fai troppe chiamate annidate, lo stack ricicla. Non c'e' un errore moderno,
non c'e' protezione: e' hardware piccolo, storico e limitato.

## RAM 4002 e SRC/DCL

La RAM virtuale non e' un array lineare generico. L'indirizzo passa da `SRC`,
che seleziona registro RAM e carattere, mentre `DCL` seleziona il banco. Le
istruzioni del gruppo `0xE` leggono e scrivono:

- memoria principale (`WRM`, `RDM`);
- status character (`WR0..WR3`, `RD0..RD3`);
- porte RAM e ROM (`WMP`, `WRR`, `RDR`);
- aritmetica con RAM (`ADM`, `SBM`).

Questa parte e' uno dei motivi per cui il 4004 e' ottimo didatticamente: costringe
a vedere una CPU come parte di un sistema di chip, non come un blocco isolato.

## BCD

BCD significa Binary Coded Decimal: ogni cifra decimale viene salvata in un
nibble. Il numero `47` non e' un valore binario unico, ma due cifre:

```text
4 -> 0100
7 -> 0111
```

Per una calcolatrice e' comodo, perche' display e input sono decimali. Ma
l'addizione ha una trappola: `7 + 5 = 12`, e `12` non entra in una cifra BCD.
Dopo una somma, se il risultato supera `9`, si aggiunge `6` per correggere la
cifra. L'istruzione `DAA` incarna questo aggiustamento.

## Istruzioni importanti

Gruppo registri:

- `LDM`: carica immediato in `A`;
- `LD`: carica registro in `A`;
- `XCH`: scambia `A` con registro;
- `INC`: incrementa registro;
- `ADD`, `SUB`: aritmetica su `A`;
- `BBL`: ritorno da subroutine e carica immediato.

Gruppo salti:

- `JUN`: salto incondizionato;
- `JMS`: chiamata subroutine;
- `JCN`: salto condizionato;
- `ISZ`: incrementa registro e salta se non zero;
- `FIM`, `SRC`, `FIN`, `JIN`: coppie di registri e indirizzamento.

Gruppo accumulatore:

- `CLB`, `CLC`, `STC`, `CMC`;
- `IAC`, `DAC`, `CMA`;
- `RAL`, `RAR`;
- `TCC`, `TCS`;
- `DAA`, `KBP`, `DCL`.

Gruppo I/O e RAM:

- `WRM`, `RDM`;
- `ADM`, `SBM`;
- `WMP`, `WRR`, `RDR`;
- `WR0..WR3`, `RD0..RD3`.

## Delega alla ALU a porte

Le istruzioni aritmetiche principali usano `retronet-hardware/bridge/i4004`.
Quindi `ADD`, `SUB`, `IAC`, `DAC`, `CMA` e rotazioni non sono solo operatori Go
sparsi nel codice: passano dagli adattatori gate-level quando applicabile.

Questo e' un collegamento storico-didattico molto bello: il primo microprocessore
commerciale dell'ecosistema RetroNet calcola con la ALU costruita dalle porte di
`retronet-logic`.

## Esempi

Il repo contiene esempi didattici:

- moltiplicazione tramite addizioni ripetute;
- uso della RAM;
- somma BCD a cifra singola;
- somma BCD multi-cifra;
- subroutine con `JMS`/`BBL`.

La calcolatrice 4004 completa vive nell'ecosistema attraverso `retronet-asm` e
la demo in `retronet/assets/demos/calcolatrice-4004.md`.

## Tour del codice

`go-4004\cpu\cpu.go` contiene lo stato: `A`, `C`, `R`, `PC`, `CL`, `Stack`, `SP`,
`SRCAddr` e callback I/O. `Step` si occupa di fetch, lunghezza istruzione e
dispatch. `go-4004\cpu\instructions.go` contiene la semantica: ogni caso dello switch
modifica stato CPU o RAM.

Il codice e' esplicito, quasi narrativo. Questo e' un bene per un emulatore
didattico: invece di comprimere tutto in tabelle opache, fa vedere cosa succede.

## Limiti

Il 4004 reale aveva dettagli elettrici e temporali che qui non sono l'obiettivo
principale. L'emulatore e' instruction-level, non pin-level. Non include ROM
storiche. Il terminale I/O e' virtuale e didattico.

## Collegamenti

`retronet-asm` produce ROM i4004. `retronet-hardware` fornisce il bridge ALU.
`retronet` usa 4004 come demo end-to-end. Questo e' il primo gradino storico
della catena CPU.

---

# Capitolo 5 - `retronet-8008`

## Cosa risolve

`retronet-8008` implementa l'Intel 8008, una CPU a 8 bit con program counter a
14 bit, sette registri visibili, quattro flag, stack interno e I/O separato. E'
la tappa tra il mondo molto particolare del 4004 e il mondo piu' familiare
dell'8080.

## Modello mentale semplice

L'8008 non e' un 4004 piu' largo. E' un'altra architettura. Ha registri
`A,B,C,D,E,H,L`, usa `A` come accumulatore e usa `H:L` per puntare memoria
attraverso il pseudo-registro `M`.

La memoria indirizzabile direttamente e' 16 KB:

```text
PC a 14 bit -> indirizzi 0x0000..0x3FFF
```

Lo stack non e' memoria normale. E' interno alla CPU: 8 voci da 14 bit, con 7
livelli utili per call/restart, perche' una voce rappresenta il PC corrente.

## Reset, STOPPED e Jam

Una differenza importante dall'8080 e' lo stato di avvio. Il core 8008 parte
fermo: `Halted` e `Stopped` sono veri. Per iniziare l'esecuzione si usa `Jam`,
che simula un'istruzione forzata dall'esterno. Nei test e negli esempi si puo'
fare una jam di `NOP` o di una istruzione di salto.

Questo rende il modello storico piu' fedele: l'8008 reale non ha un reset/boot
comodo come i processori successivi.

## Decoder e Step

Il decoder e' tabellare su 256 opcode. Ogni voce sa:

- codice;
- mnemonico;
- lunghezza;
- timing aggregato;
- funzione esecutiva.

`Step` legge opcode, legge eventuali operandi, calcola il timing e chiama la
funzione esecutiva. Se la CPU e' ferma, non legge memoria e restituisce
`ErrCPUStopped`.

Questa separazione e' molto pulita: il decoder descrive, le funzioni eseguono,
il core orchestra.

## Registri e pseudo-registro `M`

`M` non e' un vero registro. Significa "memoria all'indirizzo HL". Nell'8008
solo i 6 bit bassi di `H` partecipano all'indirizzo alto, perche' l'indirizzo e'
a 14 bit:

```text
addr = ((H & 0x3F) << 8) | L
```

Questa e' una delle differenze pratiche piu' importanti rispetto a un modello
piu' moderno: non tutta la memoria e' comoda da indirizzare, e l'accesso passa
spesso da `HL`.

## Famiglie istruzionali

Il repo implementa:

- load e move tra registri, immediati e `M`;
- ALU su accumulatore con registro, `M` o immediato;
- rotate dell'accumulatore;
- jump, call, return, restart;
- halt e stopped;
- I/O separato.

Le ALU includono:

- add;
- add con carry;
- subtract;
- subtract con borrow;
- AND;
- XOR;
- OR;
- compare.

`CMP` aggiorna i flag ma non modifica l'accumulatore. `INR` e `DCR` aggiornano
Zero/Sign/Parity ma non il Carry. Le rotate modificano il Carry e lasciano
invariati gli altri flag.

## I/O

L'8008 ha I/O separato dalla memoria. Il modello esposto dal repo distingue:

- 8 porte input;
- 24 porte output.

Questo sembra strano se vieni da sistemi moderni, ma e' parte della natura
storica del chip. Il repo fornisce anche callback I/O, terminale buffered e bus
periferiche configurabile.

## Profili macchina

Sopra il core `cpu` c'e' il package `machine`, che introduce profili:

- `generic`;
- `intellec-8`;
- `scelbi-8b`;
- `scelbi-8h`.

Il repo non include ROM storiche. I profili descrivono slot e convenzioni, ma
accettano ROM locali fornite dall'utente. Le regioni caricate come ROM sono
protette da scrittura.

## Front panel e debugger

L'8008 e' molto vicino all'idea di macchina da laboratorio. Il repo include un
front panel testabile che coordina jam, step, run, stop e selettori esterni.
Include anche debugger strutturato con eventi CPU, memoria, I/O, timing e WAIT.

Questo e' utile per imparare: non si vede solo il risultato finale, si vede il
percorso.

## Timing

Il core registra stati e cicli macchina aggregati. Non modella ogni transizione
di pin o T-state, ma conserva abbastanza informazione per spiegare quanto costa
un'istruzione e per distinguere istruzioni condizionali prese/non prese.

## Conformance

Il repo usa suite sintetiche, oracle esaustivi per famiglie funzionali e fuzz
test su decoder, disassembler e limiti architetturali. Questo e' coerente con
l'obiettivo didattico: non basta "sembra funzionare"; bisogna poter dire perche'
ci fidiamo.

## Tour del codice

I file chiave sono:

- `retronet-8008\cpu\cpu.go`: stato CPU;
- `retronet-8008\cpu\step.go`: fetch/decode/execute;
- `retronet-8008\cpu\decoder.go` e `retronet-8008\cpu\opcodes.go`: tabella;
- `retronet-8008\cpu\alu.go`: operazioni ALU via bridge i8008;
- `retronet-8008\machine\profile.go`: profili;
- `retronet-8008\machine\terminal.go`: terminale I/O;
- `retronet-8008\machine\frontpanel.go`: controllo macchina.

Lo stato della CPU e' volutamente leggibile: registri e flag sono campi diretti,
mentre helper piccoli mascherano indirizzi a 14 bit e stack pointer a 3 bit.

## Limiti

Non ci sono ROM storiche versionate. Le mappe memoria storiche sono conservative.
La fedelta' e' instruction-level con timing aggregato, non bus-cycle completa.
Il bus multiplexato reale dell'8008 e' documentato come prospettiva, ma non e'
il centro della milestone corrente.

## Collegamenti

`retronet-asm` supporta backend i8008. `retronet-hardware/bridge/i8008` collega
l'aritmetica alla ALU a porte. Il passaggio 8008 -> 8080 e' il passaggio verso
uno stack in memoria, piu' spazio indirizzabile e software CP/M-like.

---

# Capitolo 6 - `retronet-8080`

## Cosa risolve

`retronet-8080` implementa l'Intel 8080 a livello di istruzione. Questo e' il
core che rende possibile `retronet-cpm`: programmi `.COM`, BDOS trap e shell
didattica.

## Modello mentale semplice

Rispetto all'8008, l'8080 e' molto piu' comodo per il software:

- indirizzi a 16 bit, quindi 64 KB;
- stack pointer programmabile in memoria;
- registri `A,B,C,D,E,H,L`;
- coppie di registri `BC`, `DE`, `HL`, `SP`;
- I/O separato a 256 porte;
- piu' istruzioni di movimento dati e controllo.

Il salto concettuale piu' importante e' lo stack in memoria. `CALL`, `RET`,
`PUSH`, `POP` non usano piu' una pila interna minuscola come 4004/8008: usano
la RAM. Questo apre la porta a programmi molto piu' grandi e a convenzioni
software piu' sane.

## Stato CPU

La struct `CPU8080` contiene:

- registri 8 bit;
- flag `Carry`, `Zero`, `Sign`, `Parity`, `AuxiliaryCarry`;
- `PC` e `SP` a 16 bit;
- stato `Halted`, `Stopped`, interrupt abilitati;
- contatori didattici;
- backend ALU selezionabile.

Il reset e' deterministico: registri e flag a zero, CPU eseguibile, interrupt
disabilitati. A differenza dell'8008, non serve una jam per partire.

## ALU gate/native

Il core usa di default `cpu.Gate`, cioe' l'ALU a porte attraverso il bridge
i8080. Puo' usare anche `cpu.Native`, piu' veloce, ma con la stessa semantica.
Il test differenziale garantisce che risultati e flag coincidano.

Questa scelta e' pragmatica: per didattica vuoi `gate`; per diagnostiche lunghe
puoi scegliere `native`.

## Istruzioni

La v0.1 implementa le famiglie principali:

- data movement: `MOV`, `MVI`, `LXI`, `LDA`, `STA`, `LHLD`, `SHLD`, `LDAX`,
  `STAX`, `XCHG`, `XTHL`, `SPHL`;
- ALU e flag: `ADD`, `ADC`, `SUB`, `SBB`, `ANA`, `XRA`, `ORA`, `CMP`,
  immediati, `INR`, `DCR`, `INX`, `DCX`, `DAD`, `DAA`, `CMA`, `CMC`, `STC`;
- rotate e controllo: `RLC`, `RRC`, `RAL`, `RAR`, `JMP`, `Jcc`, `CALL`, `Ccc`,
  `RET`, `Rcc`, `RST`, `PCHL`, `PUSH`, `POP`, `NOP`, `HLT`, `IN`, `OUT`,
  `EI`, `DI`.

Gli opcode non assegnati restituiscono errore esplicito invece di diventare
alias silenziosi. Questa e' una scelta buona per un emulatore didattico:
fallire chiaramente insegna piu' di fingere.

## Fetch/decode/execute

`Step` e' simile all'8008:

1. verifica CPU e memoria;
2. legge opcode da `PC`;
3. legge operandi secondo la lunghezza;
4. recupera metadata timing;
5. esegue la funzione associata;
6. aggiorna contatori.

La memoria e l'I/O sono interfacce. Il core non sa se dietro c'e' memoria piatta,
ROM protetta o una macchina piu' complessa.

## Conformance

Il repo ha due livelli di verifica:

- suite sintetica locale;
- diagnostiche CP/M storiche opzionali fornite localmente.

La diagnostica piu' importante documentata e' 8080EXM, un exerciser molto
severo. Le ROM non sono versionate per ragioni di copyright, ma il test puo'
usarle se l'utente le mette nel percorso previsto o imposta variabili ambiente.

Il punto didattico: passare 8080EXM con ALU gate significa che il comportamento
complessivo dell'8080 e' corretto anche quando aritmetica e flag vengono da
porte logiche.

## Machine package

Il package `machine` sta sopra `cpu`. Qui arrivano bus memoria con regioni
RAM/ROM, callback I/O, terminale, front panel, READY/WAIT, interrupt esterno e
debugger. Il core resta pulito: non importa `machine`.

Questa separazione anticipa il disegno di `retronet-pc`: core CPU al centro,
macchina intorno.

## Tour del codice

I file piu' utili:

- `retronet-8080\cpu\cpu.go`: stato, registri, coppie, flag PSW;
- `retronet-8080\cpu\step.go`: ciclo istruzione;
- `retronet-8080\cpu\execute.go`: semantica istruzioni;
- `retronet-8080\cpu\alu.go`: applicazione dei flag dall'ALU backend;
- `conformance`: suite sintetica e diagnostiche opzionali;
- `machine`: profili, memoria, I/O e debugger.

La gestione di `FlagsByte` e `SetFlagsByte` e' utile per capire `PUSH PSW` e
`POP PSW`: i flag diventano un byte con bit riservati e poi tornano campi
booleani.

## Limiti

`retronet-8080` resta un emulatore 8080, non un sistema CP/M completo. Non
include BDOS, BIOS, dischi o ROM storiche. Queste responsabilita' vivono in
`retronet-cpm`.

## Collegamenti

`retronet-cpm` usa questo core. `retronet-asm` produce codice i8080 e `.COM`.
`retronet-hardware` fornisce bridge ALU. `retronet-api` arriva indirettamente
fino all'8080 attraverso sessioni CP/M-like.

---

# Capitolo 7 - `retronet-8086`

## Cosa risolve

`retronet-8086` implementa un core Intel 8086/8088 in real mode. E' il motore di
`retronet-pc`. A differenza di 8080, qui entrano segmentazione, registri a 16
bit, ModR/M, prefissi, string instructions, interrupt real mode e spazio fisico
da 1 MB.

## Modello mentale semplice

L'8086 vede indirizzi logici `segmento:offset`. L'indirizzo fisico si calcola:

```text
fisico = (segmento << 4) + offset
```

Il risultato e' mascherato a 20 bit, quindi lo spazio e' 1 MB. Questo e' il
cuore del real mode.

Esempio:

```text
FFFF:0000 -> FFFF0
0000:7C00 -> 07C00
```

Il PC si chiama `IP` e lavora insieme a `CS`. Lo stack usa `SS:SP`. I dati usano
di solito `DS`, e le destinazioni stringa usano `ES`.

## Registri

I registri generali sono `AX`, `CX`, `DX`, `BX`, `SP`, `BP`, `SI`, `DI`. I primi
quattro sono anche divisibili in meta' alte e basse:

```text
AX = AH:AL
BX = BH:BL
CX = CH:CL
DX = DH:DL
```

Nel codice, i registri a 16 bit stanno in un array. `Get8` e `Set8` leggono o
scrivono la meta' giusta, condividendo lo stesso storage.

## Flag

L'8086 ha flag aritmetici:

- Carry;
- Parity;
- Auxiliary Carry;
- Zero;
- Sign;
- Overflow.

E flag di controllo:

- Trap;
- Interrupt;
- Direction.

Il codice li tiene come booleani separati e li impacchetta in `FLAGS` solo
quando serve, per esempio `PUSHF`, `POPF`, `IRET` o confronto con test esterni.

## ALU gate/native

Come gli altri core, l'8086 ha backend ALU intercambiabili:

- `Gate`: bridge i8086, costruito su ALU a porte;
- `Native`: operatori Go come oracolo veloce.

Il bridge i8086 e' piu' complesso degli altri perche' deve supportare 8/16 bit,
overflow signed, auxiliary carry, parity sugli 8 bit bassi, moltiplicazione,
divisione, shift e rotate.

Il test differenziale confronta gate e native. Questo e' fondamentale: l'8086 ha
molti flag sottili, e un errore in `OF` o `AF` rompe software reale.

## Prefissi e Step

`Step` raccoglie prefissi finche' non trova un opcode vero. I prefissi includono:

- override segmento;
- `LOCK`;
- `REP`/`REPNE`.

Poi chiama `execute`. Questa separazione e' identica al modo in cui si pensa la
decodifica 8086: alcuni byte non sono istruzioni autonome, modificano il
significato dell'istruzione successiva.

## ModR/M

Molte istruzioni 8086 hanno un byte ModR/M. Questo byte descrive:

- se l'operando e' registro o memoria;
- quale registro e' coinvolto;
- quale forma di indirizzamento usare;
- eventuale displacement.

L'8086 non ha SIB come x86 moderni. Ha combinazioni base/indice a 16 bit:

```text
[BX+SI], [BX+DI], [BP+SI], [BP+DI],
[SI], [DI], [BP], [BX]
```

Se c'e' `BP`, il segmento di default e' `SS`; altrimenti di solito `DS`, salvo
override.

## Istruzioni implementate

Il core copre molte famiglie:

- MOV, XCHG, LEA;
- ALU registro/memoria/immediato;
- TEST, NOT, NEG, MUL, IMUL, DIV, IDIV;
- INC/DEC;
- PUSH/POP e segmenti;
- salti, call, ret near/far;
- interrupt `INT`, `IRET`;
- I/O `IN`/`OUT`;
- string instructions con REP;
- flag control;
- BCD/ASCII adjust;
- HLT e varie istruzioni/alias.

Il file `retronet-8086\cpu\execute.go` e' lungo perche' l'8086 e' lungo. Pero' il codice usa
raggruppamenti sensati: blocco ALU tabellare, gruppi estesi, helper per
ModR/M, helper per condizioni, helper per stringhe.

## String instructions

Le istruzioni stringa (`MOVS`, `STOS`, `LODS`, `SCAS`, `CMPS`) usano registri
impliciti:

- sorgente `DS:SI` (o segmento override);
- destinazione `ES:DI`;
- accumulatore per alcune forme;
- `CX` come contatore con `REP`;
- Direction Flag per decidere se incrementare o decrementare.

Queste istruzioni mostrano quanto l'8086 sia gia' una macchina pensata per
routine di memoria e BIOS.

## Interrupt

Un interrupt real mode usa una tabella di vettori in memoria bassa. La CPU
impila `FLAGS`, `CS`, `IP`, disabilita alcuni flag e salta al gestore. `IRET`
ripristina.

`retronet-pc` usa questa capacita' per collegare PIC/PIT/tastiera/floppy al BIOS.

## Validazione

Il repo usa:

- test differenziali ALU gate/native;
- conformance sintetica;
- SingleStepTests TomHarte opzionali fuori repo.

I dataset esterni non sono versionati. La documentazione distingue bene
comportamento definito e aree storicamente ambigue/non documentate.

## Tour del codice

I file chiave:

- `retronet-8086\cpu\registers.go`: registri, segmenti, `PhysAddr`;
- `retronet-8086\cpu\cpu.go`: reset, memoria, fetch, stack, flag;
- `retronet-8086\cpu\step.go`: prefissi e run loop;
- `retronet-8086\cpu\execute.go`: dispatch istruzioni;
- `retronet-8086\cpu\modrm.go`: indirizzamento;
- `retronet-8086\cpu\alu_backend.go` e `retronet-8086\cpu\alu_native.go`: backend ALU;
- `retronet-8086\cpu\bcd.go`: aggiustamenti BCD/ASCII;
- `conformance` e `testsuite`: verifica.

## Limiti

Il core non e' una macchina PC completa. Non conosce BIOS, video, PIT o floppy.
Questi stanno in `retronet-pc`. Inoltre l'accuratezza timing di 8086/8088 non e'
il centro del core attuale; profili 8086/8088 distinguono aspetti esterni, ma
la semantica istruzione resta comune.

## Collegamenti

`retronet-pc` usa questo core come CPU. `retronet-asm` produce boot sector i8086
che il PC puo' caricare. `retronet-hardware/bridge/i8086` permette anche al PC,
con opzione `-alu gate`, di calcolare attraverso porte logiche.

---

# Capitolo 8 - `retronet-pc`: IBM PC/XT compatibile

## Cosa risolve

`retronet-pc` costruisce una macchina IBM PC/XT attorno al core 8086/8088. La
CPU da sola non basta per avere un PC: servono memoria mappata, I/O, interrupt,
timer, tastiera, video, DMA, floppy e BIOS.

## Modello mentale semplice

La CPU vede due cose:

```text
Memoria fisica
Spazio di I/O
```

Non sa che a `0xB0000` c'e' video MDA o che la porta `0x20` e' il PIC. La
macchina glielo rende vero collegando bus e periferiche.

La `Machine` contiene:

- `CPU`;
- `Mem`;
- `IO`;
- `PIC`;
- `PIT`;
- `PPI`;
- `DMA`;
- `FDC`;
- video MDA/CGA;
- latch POST.

## Mappa memoria

Il bus ha 1 MB:

```text
00000-9FFFF  RAM convenzionale
A0000-BFFFF  video RAM
C0000-EFFFF  option ROM
F0000-FFFFF  BIOS ROM
```

Le regioni caricate con `LoadROM` diventano protette da scrittura. Il reset
vector dell'8088 e' a `0xFFFF0`, quindi il BIOS deve essere caricato in alto.

## Spazio I/O

Le porte principali:

- `0x00-0x0F`: DMA 8237;
- `0x20-0x21`: PIC 8259;
- `0x40-0x43`: PIT 8253;
- `0x60-0x63`: PPI 8255;
- `0x80`: POST;
- `0x81-0x8F`: pagine DMA;
- `0x3B4-0x3BB`: MDA;
- `0x3D4-0x3DB`: CGA;
- `0x3F0-0x3F7`: FDC 765.

Il dispatcher `io.Ports` instrada letture e scritture verso il device che possiede
l'intervallo. Le porte non mappate leggono `0xFF`.

## Interrupt

Il percorso tipico:

```text
PIT counter 0 -> IRQ0 -> PIC -> CPU.Interrupt(vettore)
```

Il PIC applica maschere e priorita'. La macchina, a ogni step, controlla se c'e'
un interrupt pendente e se la CPU ha `IF` abilitato. Se si', riconosce
l'interrupt e non esegue una normale istruzione in quel passo.

Questo e' il ponte tra hardware virtuale e CPU real mode.

## Timer

Il modello non e' cycle-accurate. A ogni passo macchina, il PIT avanza di un
numero fisso di cicli. E' una approssimazione sufficiente per BIOS e interrupt
periodici, non per riprodurre timing elettrico preciso.

## Video MDA/CGA

`TextVideo` implementa modo testo 80x25. Ogni cella video e' una coppia:

```text
carattere + attributo
```

Il renderer legge la RAM video e produce testo. Non rende grafica CGA, font
storici o code page 437 completa; i byte non rappresentabili diventano caratteri
semplici. Questo e' coerente col confine didattico.

## Floppy, DMA e FDC

Il controller floppy NEC 765 e' modellato in modo funzionale:

- la CPU scrive comando e parametri sulle porte;
- il controller esegue;
- i dati passano via DMA canale 2;
- il controller alza IRQ6.

Il trasferimento avviene in blocco, non ciclo per ciclo. Questo basta per far
bootare un settore e parlare con BIOS, ma non e' una simulazione elettrica del
765.

## BIOS reale

Il repo non include BIOS. La documentazione spiega come usare GLaBIOS, un BIOS
XT compatibile esterno. Con BIOS e floppy, la macchina puo' completare il POST,
mostrare testo e bootare da floppy.

Questo e' un traguardo importante: significa che CPU, memoria, I/O, timer,
interrupt, video, tastiera, DMA e floppy collaborano abbastanza da soddisfare un
BIOS vero.

## ALU native/gate

Per un PC completo il default e' `native`, per velocita'. Ma si puo' scegliere
`gate`. In quel caso un PC/XT intero calcola aritmetica e flag attraverso le
porte logiche dell'ecosistema. Non e' pratico come prestazioni, ma e'
straordinario come dimostrazione didattica.

## Tour del codice

I file principali:

- `retronet-pc\machine\machine.go`: cablaggio della macchina;
- `retronet-pc\memory\bus.go`: 1 MB e ROM protette;
- `retronet-pc\io\ports.go`: dispatcher I/O;
- `retronet-pc\device\pic.go`, `retronet-pc\device\pit.go`, `retronet-pc\device\ppi.go`, `retronet-pc\device\dma.go`, `retronet-pc\device\fdc.go`: periferiche;
- `retronet-pc\device\textvideo.go`: MDA/CGA testo;
- `retronet-pc\disk\floppy.go`: geometria e settori;
- `retronet-pc\cmd\retronet-pc\main.go`: CLI.

`NewXT` e' il punto migliore da leggere: crea device, collega callback IRQ,
mappa porte e sceglie default ALU.

## Limiti

Il PC non e' ancora un emulatore cycle-accurate. DMA e FDC sono funzionali.
Video grafico CGA non e' reso. Tastiera e layout sono parziali. ROM esterne non
sono incluse.

## Collegamenti

`retronet-pc` dipende da `retronet-8086`. I boot sector prodotti da
`retronet-asm` possono essere avviati. Il progetto e' il punto in cui la catena
"porte logiche -> CPU -> sistema" arriva a una macchina storica complessa.

---

# Capitolo 9 - `retronet-asm`

## Cosa risolve

`retronet-asm` evita di scrivere programmi come array di byte a mano. Traduce
assembly testuale in ROM o file binari eseguibili dagli emulatori RetroNet.

Supporta:

- `i4004`;
- `i8008`;
- `i8080`;
- `i8086`.

Per i programmi CP/M-like supporta `.com`/`.orgbase`; per 8086 puo' generare
boot sector avviabili da `retronet-pc`.

## Modello mentale semplice

Un assembler e' un traduttore:

```text
sorgente .asm -> token -> statement -> byte
```

Il problema principale sono le label. Se scrivi:

```asm
    JMP fine
    NOP
fine:
    HLT
```

quando l'assembler vede `JMP fine`, non sa ancora dove sara' `fine`. Per questo
serve una pipeline a due passate.

## Lexer

Il lexer legge caratteri e produce token:

- identificatori;
- numeri;
- direttive;
- stringhe;
- memoria tra parentesi quadre;
- `:`, `,`, newline.

Ignora spazi e commenti `;`. E' indipendente dall'architettura: non sa cosa sia
`ADD` o `MOV`, sa solo riconoscere pezzi di testo.

## Parser

Il parser trasforma token in statement. Uno statement puo' contenere:

- label;
- istruzione;
- `.org`;
- `.orgbase`;
- `.com`;
- `.byte`;
- `.equ`.

I mnemonici vengono normalizzati in maiuscolo, gli operandi restano testo. Le
label sono case-sensitive.

## Architetture

L'interfaccia `arch.Arch` chiede a ogni backend due cose:

- `Size`: quanti byte occupera' l'istruzione;
- `Encode`: quali byte produrre.

Questa separazione permette la doppia passata.

Ogni backend conosce il proprio set di istruzioni. `i4004` conosce registri a
nibble e vincoli di pagina; `i8008` conosce mnemonici 8008; `i8080` conosce
istruzioni CP/M-like; `i8086` conosce registri, ModR/M, immediati, memoria e
salti relativi.

## Due passate

Passata 1:

```text
pc = base
per ogni statement:
  applica .org/.orgbase
  registra label -> pc
  registra .equ -> valore
  pc += Size(istruzione)
  pc += len(.byte)
```

Passata 2:

```text
pc = base
per ogni statement:
  emetti padding .org
  emetti .byte
  Encode(istruzione, pc, resolver)
  pc += len(byte emessi)
```

Il resolver cerca label e costanti nella symbol table.

## Direttive

`.arch` sceglie backend. Se manca, il default e' i4004.

`.include` espande file locali, con controllo per restare dentro la directory
radice del sorgente principale. Non e' un package manager, non fa rete.

`.org` sposta la posizione di emissione e riempie il vuoto.

`.orgbase` cambia il PC logico senza aggiungere padding. Serve quando il file
viene caricato a un indirizzo noto ma deve iniziare subito dal primo byte.

`.com` e' scorciatoia per base logica `0x0100`, utile per programmi CP/M.

`.byte` emette dati letterali.

`.equ` definisce costanti simboliche.

## Backend i8086 e boot sector

Il backend i8086 supporta registri 8/16 bit, segmenti, molte ALU, push/pop,
interrupt, stringhe, shift, operandi in memoria e salti relativi.

Per un boot sector:

```asm
.arch i8086
.orgbase 0x7C00
    ; codice
.org 0x7DFE
.byte 0x55, 0xAA
```

Il file prodotto e' lungo 512 byte se riempito correttamente. Il BIOS lo carica
a `0000:7C00`; `.orgbase` fa si' che le label vengano risolte come se il codice
vivesse li', senza inserire 0x7C00 byte di zeri all'inizio del file.

## Tour del codice

I file centrali:

- `retronet-asm\internal\lexer\lexer.go`;
- `retronet-asm\internal\parser\parser.go`;
- `retronet-asm\internal\emitter\emitter.go`;
- `retronet-asm\internal\source\source.go`;
- `retronet-asm\internal\symbols\symbols.go`;
- `arch/*`;
- `retronet-asm\cmd\retronet-asm\main.go`.

La CLI registra i backend in una mappa nome -> costruttore. Il comando `build`
legge include, separa `.arch`, tokenizza, parse-a, assembla e scrive output.

## Limiti

Non e' un macro assembler completo. Non ha linker, relocazioni, macro complesse,
espressioni ricche o include di rete. Questa e' una scelta positiva per il
progetto: l'obiettivo e' imparare come si passa da testo a byte.

## Collegamenti

`retronet-asm` e' la colla tra programmi umani e CPU emulate. Produce ROM per
4004/8008/8080/8086, `.COM` per CP/M-like e boot sector per PC/XT.

---

# Capitolo 10 - `retronet-cpm`

## Cosa risolve

`retronet-cpm` crea un ambiente CP/M-like didattico sopra `retronet-8080`. Non e'
CP/M storico completo. Non include BDOS o BIOS originali. Offre invece il minimo
utile per caricare programmi `.COM`, intercettare `CALL 0005h`, gestire una
shell `A>` e leggere/scrivere file con regole controllate.

## Modello mentale semplice

Un programma CP/M `.COM` viene caricato a `0100h`. Quando vuole parlare col
sistema, mette un numero funzione in `C`, parametri in altri registri, e chiama
`0005h`.

RetroNet non mette un vero BDOS in memoria. Intercetta il momento in cui la CPU
arriva a `0005h` o alla trap interna e chiama codice Go che simula la funzione.

```text
programma .COM -> CALL 0005h -> runtime intercetta -> bdos.Handler.Call
```

## Mappa memoria didattica

I punti principali:

- `0000h`: warm boot didattico, termina run;
- `0005h`: vettore BDOS;
- `005Ch`: FCB default 1;
- `006Ch`: FCB default 2;
- `0080h`: command tail;
- `0100h`: base `.COM`;
- `F000h`: trap interna documentale;
- `EFFEh`: stack iniziale.

Questa mappa e' abbastanza compatibile per esempi e programmi console, ma non
pretende di ricostruire un sistema CP/M completo.

## Loader `.COM`

`LoadCOM` resetta programma, copia i byte a `0100h`, imposta `PC` e `SP`. Se il
programma e' troppo grande per non collidere con la trap BDOS, restituisce
errore.

`LoadCOMWithCommand` aggiunge command tail e FCB default dai primi argomenti.
Questo e' importante per programmi che si aspettano lo stile CP/M:

```text
A>RUN PROG FILE.TXT
```

Il tail finisce a `0080h`; gli FCB default a `005Ch` e `006Ch`.

## BDOS subset

Le funzioni supportate includono console:

- `0`: terminate;
- `1`: input con echo;
- `2`: output;
- `6`: direct console I/O;
- `9`: stringa terminata da `$`;
- `10`: buffered input;
- `11`: console status;
- `12`: version stub.

E file:

- `15`: open;
- `16`: close;
- `19`: delete;
- `20`: read sequential;
- `21`: write sequential;
- `22`: make file;
- `23`: rename;
- `26`: set DMA.

Le funzioni mutanti richiedono un drive scrivibile. Senza opt-in, falliscono in
modo controllato.

## FCB e DMA

FCB sta per File Control Block. E' una struttura CP/M in memoria che contiene
drive, nome 8.3, estensione e record corrente. Il BDOS legge l'FCB da memoria,
normalizza il nome e usa il drive host.

Il DMA e' l'indirizzo in memoria dove leggere o scrivere record da 128 byte.
`read sequential` copia un record nel DMA e riempie l'ultimo record con `0x1A`
quando serve.

## Drive host sicuro

`retronet-cpm/disk` mappa `A:` a una directory host, ma con limiti:

- nomi normalizzati 8.3;
- niente path traversal;
- scrittura solo se abilitata;
- limiti di dimensione e numero file nelle integrazioni API.

Questo e' fondamentale perche' `retronet-api` espone upload e sessioni remote.

## Shell `A>`

La shell implementa:

- `DIR`;
- `TYPE <file>`;
- `RUN <programma[.COM]> [argomenti]`;
- `HELP`;
- `EXIT`.

Quando esegue un programma, crea una macchina CP/M-like, carica il `.COM`, passa
console e drive, lancia `Run` e poi stampa un riepilogo con reason, step e
chiamate BDOS.

## Terminale condiviso

`retronet-cpm` usa `retronet-terminal` come console. Questo permette alla stessa
sessione di essere usata da CLI, live terminal, API e UI. La CPU non parla con
il browser; scrive byte BDOS, il terminale li registra, l'adapter li consegna.

## Sessioni API-ready

Il package `session` espone:

- `RunCommand`;
- `Input`;
- `DrainOutput`;
- `Snapshot`;
- `Prompt`;
- accesso al terminale.

Questo e' il contratto usato da `retronet-api`. Invece di invocare una CLI, l'API
crea sessioni Go importabili.

## ALU default

Il core 8080 defaulta a `Gate`, ma `retronet-cpm` defaulta a `Native`, perche'
programmi CP/M-like possono essere lunghi. L'opzione gate resta disponibile per
dimostrazioni.

## Tour del codice

File chiave:

- `retronet-cpm\cpm\machine.go`: loader, pagina zero, run loop, BDOS trap;
- `retronet-cpm\bdos\bdos.go`: funzioni BDOS;
- `retronet-cpm\bdos\terminal_console.go`: adattatore verso terminale;
- `retronet-cpm\disk\host.go`: drive host e sicurezza;
- `retronet-cpm\shell\shell.go`: comandi `A>`;
- `retronet-cpm\session\session.go`: contratto API-ready;
- `retronet-cpm\cmd\retronet-cpm-live`: live locale.

La parte piu' istruttiva e' `Machine.Run`: a ogni passo controlla se la CPU e'
ferma, se il PC e' warm boot, se e' BDOS, oppure se deve eseguire una istruzione
8080 normale.

## Limiti

Non e' CP/M completo:

- niente BDOS/BIOS storico incluso;
- niente immagini disco storiche;
- niente user area;
- niente wildcard CCP complete;
- niente BIOS S-100;
- compatibilita' incrementale e didattica.

## Collegamenti

Usa `retronet-8080`, `retronet-terminal` e programmi assemblati da
`retronet-asm`. E' il cuore delle sessioni esposte da `retronet-api` e
consumate da `retronet-ui`.

---

# Capitolo 11 - `retronet-terminal`

## Cosa risolve

`retronet-terminal` centralizza input, output, schermo, snapshot, ANSI minimale
e runner live. Senza questo repo, ogni emulatore reinventerebbe code input,
buffer output e gestione CR/LF.

## Modello mentale semplice

Un terminale RetroNet e' byte-oriented:

```text
input queue -> programma legge byte
programma scrive byte -> output raw + schermo derivato
```

Il buffer raw conserva i byte scritti. Lo schermo e' una interpretazione
testuale di quei byte.

## Terminal core

`Terminal` contiene:

- configurazione larghezza/altezza/ANSI;
- coda input;
- buffer output;
- matrice schermo;
- cursore;
- stato escape ANSI;
- mutex per uso concorrente.

Le API principali:

- `QueueInput`;
- `ReadByte` / `Read`;
- `WriteByte` / `Write`;
- `DrainOutput`;
- `Snapshot`;
- `Resize`;
- `Reset`.

## Snapshot

Lo snapshot e' il contratto per UI e websocket:

- dimensioni;
- righe a larghezza fissa;
- cursore;
- input pendente;
- byte output in attesa.

Questo permette a un client remoto di riallineare lo schermo anche se perde
qualche output raw.

## ANSI minimale

Il terminale supporta un subset:

- pulizia schermo/riga;
- posizionamento cursore;
- movimento relativo;
- attributi `m` ignorati ma preservati nel raw.

Sequenze sconosciute o incomplete non devono causare panic. Questo e' importante
per robustezza: un programma puo' emettere escape non supportati, ma il terminale
non deve crollare.

## Live runner

Il package `live` fornisce un runner riusabile:

- raw mode host dove possibile;
- rendering snapshot;
- output a delta;
- handler applicativo.

Il runner non conosce CP/M. Chiede a un handler cosa fare quando arriva un byte.
Questo e' il confine giusto: il terminale gestisce trasporto e schermo, l'app
decide semantica.

## Client API

`retronet-terminal-api` collega una console host a `retronet-api`:

- crea o usa una sessione;
- apre WebSocket;
- invia input JSON;
- stampa output ricevuto.

Anche qui il core terminale resta indipendente: il client e' un adattatore di
trasporto.

## Tour del codice

File chiave:

- `retronet-terminal\terminal.go`: core;
- `retronet-terminal\live\runner.go`: runner;
- `retronet-terminal\live\raw_windows.go`, `retronet-terminal\live\raw_linux.go`: raw mode;
- `retronet-terminal\internal\wsclient\websocket.go`: client WebSocket minimale;
- `retronet-terminal\cmd\retronet-terminal-api\main.go`: adapter API.

`writeByteLocked` e' il punto centrale: scrive sempre nel raw output; se ANSI e'
attivo, aggiorna anche lo schermo interpretando escape note.

## Limiti

Non e' un VT100 completo. Non usa terminfo. Non include font, ROM terminali o
scrollback storico completo. E' un terminale didattico generico, non una replica
di una marca storica.

## Collegamenti

`retronet-cpm` lo usa come console. `retronet-api` lo espone tramite snapshot e
output. `retronet-ui` renderizza snapshot e scrollback.

---

# Capitolo 12 - `retronet-api`

## Cosa risolve

`retronet-api` espone sessioni RetroNet via HTTP e WebSocket. Non emula CPU, non
implementa BDOS e non renderizza UI. Orchestra `retronet-cpm/session`, drive
temporanei e terminale.

## Modello mentale semplice

Il server vede una sessione come:

```text
comando/input -> sessione CP/M-like -> output/snapshot/stato
```

Il client puo' essere uno script REST, un terminale host o la UI browser.

## Session manager

`Manager` mantiene sessioni in memoria. Ogni sessione ha:

- ID casuale;
- created/expires;
- stato;
- errore ultimo;
- sessione CP/M;
- drive temporaneo scrivibile ma confinato;
- cleanup;
- line editor minimale.

Gli stati sono:

- `idle`;
- `running`;
- `closed`;
- `error`.

## Creazione sessione

`POST /sessions` crea un drive temporaneo, crea una sessione CP/M-like, stampa
il prompt `A>` e restituisce metadati. Il client non passa path host. Questa e'
una scelta di sicurezza fondamentale.

## REST

Endpoint principali:

- `GET /health`;
- `GET /version`;
- `POST /sessions`;
- `GET /sessions`;
- `GET /sessions/{id}`;
- `DELETE /sessions/{id}`;
- `GET /sessions/{id}/files`;
- `POST /sessions/{id}/files`;
- `POST /sessions/{id}/command`;
- `POST /sessions/{id}/run`;
- `POST /sessions/{id}/input`;
- `GET /sessions/{id}/output`;
- `GET /sessions/{id}/ws`.

`command` e' sincrono. `run` e' asincrono e serve per programmi interattivi.

## Upload `.COM`

L'upload accetta solo `.COM`. Il nome viene normalizzato 8.3. Limiti di
dimensione e numero file vengono dal drive. Path traversal e nomi invalidi sono
rifiutati.

Questo e' il punto in cui l'API deve essere piu' conservativa della CLI: un
server HTTP non puo' fidarsi del client.

## Input idle/running

Se la sessione e' `running`, input viene accodato al terminale: il programma lo
leggera' tramite BDOS console.

Se la sessione e' `idle`, input passa da un line editor minimale:

- caratteri stampabili;
- backspace;
- invio;
- Ctrl+L;
- Ctrl+C/D/Q per chiusura.

Quando arriva invio, il comando viene avviato.

## WebSocket

Il WebSocket usa JSON testuale. Client:

- `command`;
- `run`;
- `input`;
- `output`;
- `snapshot`.

Server:

- `output`;
- `accepted`;
- `state`;
- `snapshot`;
- `error`.

Il server ha anche polling periodico per inviare output e cambi stato mentre un
comando asincrono gira.

## CORS

Il server abilita CORS locale configurabile per `retronet-ui`. Non usa wildcard
di default. `*` e' possibile solo con configurazione esplicita, adatta a prove
locali controllate.

## Tour del codice

File chiave:

- `retronet-api\internal\server\manager.go`: sessioni e stati;
- `retronet-api\internal\server\server.go`: route HTTP;
- `retronet-api\internal\server\websocket_messages.go`: payload socket;
- `retronet-api\internal\ws\websocket.go`: WebSocket minimale server-side;
- `retronet-api\cmd\retronet-api\main.go`: CLI e configurazione.

`ManagedSession.handleInput` e' uno dei metodi piu' importanti: contiene il
confine tra shell idle e programma running.

## Limiti

Sessioni sono in memoria. Non c'e' autenticazione/TLS. Non espone macchine
diverse da CP/M-like in questa versione. Non include ROM o programmi storici.

## Collegamenti

Dipende da `retronet-cpm` e `retronet-terminal`. E' consumata da
`retronet-terminal-api` e `retronet-ui`.

---

# Capitolo 13 - `retronet-ui`

## Cosa risolve

`retronet-ui` e' la prima interfaccia browser dell'ecosistema. Serve asset
statici da Go e parla con `retronet-api` tramite REST e WebSocket.

Non emula CPU, non implementa CP/M, non accede al filesystem host e non contiene
asset storici. E' una console web minimale con dashboard sessioni/file e upload
`.COM`.

## Modello mentale semplice

Il browser fa:

```text
carica UI -> legge config -> controlla API -> crea sessione
          -> apre WebSocket -> invia tasti -> renderizza output/snapshot
```

Il lavoro pesante resta sul server API e nei moduli Go.

## Server Go

`internal/site` usa `embed.FS` per servire:

- `index.html`;
- `styles.css`;
- `retronet-ui\internal\site\static\app.js`;
- `config.json`;
- health UI.

`Check` verifica che gli asset essenziali esistano e contengano marker attesi.

## JavaScript

`retronet-ui\internal\site\static\app.js` mantiene stato client:

- URL API;
- sessione corrente;
- WebSocket;
- conteggi output;
- raw text e scrollback.

Le operazioni principali:

- health/version;
- creazione sessione;
- connessione a sessione esistente;
- chiusura sessione;
- refresh dashboard;
- refresh file;
- upload `.COM`;
- invio input;
- rendering snapshot.

## Terminale browser

La UI renderizza snapshot del terminale come testo con cursore evidenziato.
Tiene anche uno scrollback raw separato. Questo e' un buon compromesso:

- snapshot = stato schermo corrente;
- scrollback = storia dei byte ricevuti.

Non usa ancora `xterm.js`; la release resta senza dipendenze frontend esterne.

## Tastiera

La UI traduce tasti browser in byte o sequenze:

- Enter -> `\r`;
- Backspace -> `0x7F`;
- Tab, Escape;
- frecce come CSI;
- Home/End/Delete;
- Ctrl+C/D/L/Q;
- caratteri stampabili.

Questi byte diventano messaggi WebSocket `input`.

## Upload file

L'upload lato UI controlla che il nome finisca in `.COM`, ma la sicurezza vera
resta lato API. Questo e' corretto: il browser aiuta l'utente, il server difende
il sistema.

## Tour del codice

File chiave:

- `retronet-ui\cmd\retronet-ui\main.go`: CLI server;
- `retronet-ui\internal\site\site.go`: handler e config;
- `retronet-ui\internal\site\static\app.js`: logica browser;
- `retronet-ui\internal\site\static\index.html` e `retronet-ui\internal\site\static\styles.css`: interfaccia.

## Limiti

Niente autenticazione/TLS. Niente dipendenze frontend avanzate. Terminale non
VT completo. L'API deve essere raggiungibile con CORS configurato. La UI e'
pensata per laboratorio locale, non per esposizione pubblica non protetta.

## Collegamenti

La UI consuma `retronet-api`. L'API consuma `retronet-cpm/session`. La sessione
usa `retronet-terminal`. Sotto, i programmi `.COM` girano su `retronet-8080`.
Questo e' l'intero percorso web:

```text
browser -> retronet-ui -> retronet-api -> retronet-cpm/session
        -> shell/BDOS -> retronet-terminal -> retronet-8080
```

---

# Appendice 0 - Concetti trasversali spiegati da zero

Questa appendice raccoglie i concetti che ricorrono in piu' capitoli. Se un
capitolo ti sembra difficile, torna qui: quasi sempre manca uno di questi mattoni
mentali.

## Che cosa fa davvero una CPU

Una CPU non "capisce" programmi nel senso umano. Ripete un ciclo molto semplice:

```text
1. guarda l'indirizzo nel Program Counter
2. legge il byte in memoria a quell'indirizzo
3. interpreta quel byte come opcode
4. legge eventuali byte aggiuntivi
5. modifica registri, memoria, flag o Program Counter
6. ricomincia
```

Tutto il resto e' dettaglio: quanti registri ci sono, quanto e' grande la
memoria, quali opcode esistono, come si calcola un indirizzo, dove vive lo stack.
Il modo migliore per non perdersi e' chiedersi sempre:

```text
questa istruzione cosa legge?
questa istruzione cosa scrive?
questa istruzione cambia il PC?
questa istruzione cambia i flag?
```

Esempio 8080:

```asm
MVI A, 2Ah
HLT
```

`MVI A, 2Ah` legge due byte: opcode e immediato. Scrive il registro `A`. Avanza
il PC oltre l'immediato. Di solito non cambia flag. `HLT` ferma la CPU. Tutto
qui.

Esempio 8086:

```asm
mov ax, 1234h
add ax, 1
```

`mov` scrive `AX`; `add` legge `AX` e l'immediato, scrive `AX`, aggiorna flag.
Anche se l'encoding 8086 e' piu' complesso, il ragionamento base resta identico.

## Opcode, mnemonico e byte

Il mnemonico e' la forma leggibile da umani:

```asm
ADD R1
```

L'opcode e' il byte o gruppo di byte che la CPU vede:

```text
0x81
```

L'assembler traduce mnemonici in opcode. L'emulatore fa il contrario mentale:
legge opcode e decide quale comportamento eseguire. Il disassembler produce una
rappresentazione leggibile degli opcode.

In RetroNet questa relazione compare ovunque:

- `retronet-asm` produce byte;
- `retronet-4004`, `8008`, `8080`, `8086` consumano byte;
- i debugger e trace mostrano di nuovo mnemonici per aiutare l'umano.

## Program Counter e salti

Il Program Counter e' l'indirizzo della prossima istruzione. Normalmente cresce:

```text
PC = PC + lunghezza_istruzione
```

Un salto cambia questa regola. Invece di continuare, la CPU carica un nuovo PC.

```asm
loop:
    ...
    JMP loop
```

Questo non e' altro che:

```text
PC = indirizzo_di_loop
```

Una call e' un salto con memoria del ritorno:

```text
push indirizzo_successivo
PC = indirizzo_subroutine
```

Un return recupera:

```text
PC = pop()
```

La differenza tra CPU storiche sta in dove vive lo stack:

- 4004: stack interno a 3 livelli;
- 8008: stack interno a 8 voci/7 livelli utili;
- 8080: stack in memoria con `SP`;
- 8086: stack in memoria su `SS:SP`.

## Registri

Un registro e' una piccola memoria dentro la CPU. E' piu' veloce e piu' vicino
alla logica di calcolo rispetto alla RAM. Le CPU storiche hanno pochi registri,
quindi il programmatore deve usarli con cura.

Sul 4004 i registri sono piccoli nibble. Sull'8008 e 8080 trovi `A,B,C,D,E,H,L`.
Sull'8086 trovi registri a 16 bit con ruoli piu' ricchi: `AX`, `BX`, `CX`,
`DX`, `SP`, `BP`, `SI`, `DI`, piu' segmenti.

L'accumulatore e' il registro privilegiato da molte istruzioni. Sul 4004 e'
`A`, sull'8008/8080 e' `A`, sull'8086 e' spesso `AL` o `AX`.

## Memoria piatta e memoria mappata

Una memoria piatta e' facile:

```text
mem[0x0000]
mem[0x0001]
...
```

Una memoria mappata aggiunge significato agli intervalli:

```text
0x00000-0x9FFFF = RAM
0xB0000         = video MDA
0xF0000-0xFFFFF = BIOS ROM
```

Dal punto di vista della CPU sono sempre letture e scritture. Dal punto di vista
della macchina, scrivere in video RAM cambia lo schermo; scrivere in ROM viene
ignorato; leggere dal BIOS restituisce firmware.

Questa distinzione spiega perche' `retronet-8086` ha solo un'interfaccia `Bus`,
mentre `retronet-pc` implementa un bus concreto con RAM, ROM e periferiche.

## I/O memory-mapped e port-mapped

Ci sono due grandi modi per parlare con periferiche:

1. memory-mapped I/O: una periferica risponde a indirizzi di memoria;
2. port-mapped I/O: una periferica risponde a porte separate.

L'8080 e l'8086 hanno istruzioni `IN`/`OUT` per spazio I/O separato. Il PC/XT
usa moltissimo questa idea: il PIC sta sulle porte `0x20-0x21`, il PIT su
`0x40-0x43`, la tastiera/PPI su `0x60-0x63`.

Il video testuale PC e' invece memory-mapped: scrivi caratteri in video RAM e lo
schermo cambia.

## Flag senza paura

I flag sembrano intimidire perche' hanno nomi brevi e regole storiche. In realta'
sono solo appunti presi dalla CPU dopo un calcolo.

`Zero`: il risultato e' zero.

`Sign`: il bit piu' alto e' 1. Nei numeri con segno in complemento a due, questo
indica un valore negativo.

`Carry`: nell'addizione indica riporto fuori dalla larghezza. Nella sottrazione
puo' indicare prestito o "nessun prestito" secondo la CPU. Attenzione qui:
RetroNet usa bridge proprio per tradurre queste convenzioni.

`Parity`: negli Intel storici vale 1 se gli 8 bit bassi contengono un numero
pari di bit a 1.

`Auxiliary Carry`: riporto/prestito tra bit 3 e bit 4, utile per aggiustamenti
BCD.

`Overflow`: overflow signed. E' diverso da Carry. Carry riguarda aritmetica
unsigned; Overflow riguarda il segno.

Esempio a 8 bit:

```text
127 + 1 = 128
0x7F + 0x01 = 0x80
```

Unsigned va bene: 128 esiste. Signed no: 127 era il massimo positivo, e il bit
di segno si accende. Qui Overflow e' vero, Carry puo' essere falso.

## Complemento a due

Il complemento a due e' il trucco con cui una CPU usa lo stesso sommatore per
fare sottrazioni.

Per calcolare `a - b`:

```text
a + NOT(b) + 1
```

Esempio a 4 bit:

```text
5 - 3
5      = 0101
3      = 0011
NOT(3) = 1100
+1     = 1101
0101 + 1101 = 1 0010
```

Il risultato basso e' `0010`, cioe' 2. Il carry esterno racconta se c'e' stato
prestito secondo la convenzione scelta.

Questo spiega perche' `retronet-logic/alu` implementa `Sub` usando `Add` su
`NOT(b)`.

## BCD con un esempio completo

BCD salva ogni cifra decimale separatamente. Immagina di voler sommare `7 + 5`
su una cifra:

```text
7 = 0111
5 = 0101
somma binaria = 1100
```

`1100` vale 12, ma una cifra BCD valida deve stare tra 0 e 9. Quindi si aggiunge
6:

```text
1100 + 0110 = 1 0010
```

La cifra bassa diventa `0010` (2) e il carry diventa la decina (1). Risultato:
12.

Sul 4004 questo e' centrale perche' il chip nasce vicino al mondo delle
calcolatrici. Sul 8080 e 8086 restano istruzioni di adjust (`DAA`, ecc.) per
compatibilita' e software decimale.

## Endianness

Molte CPU Intel salvano parole a 16 bit in little-endian: prima byte basso, poi
byte alto.

Se un indirizzo e' `0x1234`, in memoria trovi:

```text
34 12
```

Questo compare in:

- target di salti 8008/8080;
- immediate word 8080;
- stack 8080/8086;
- boot sector e istruzioni 8086.

Un principiante spesso legge `34 12` e pensa sia "al contrario". Non e' al
contrario: e' little-endian.

## Assembly: leggere senza panico

Un listato assembly si legge meglio se dividi ogni riga in tre parti:

```text
label:  mnemonico operandi   ; commento
```

La label e' un nome per un indirizzo. Il mnemonico e' l'operazione. Gli operandi
dicono su cosa agire.

Esempio CP/M-like:

```asm
.arch i8080
.com
        mvi c, 9
        lxi d, msg
        call 5
        ret
msg:    .byte "CIAO$"
```

Lettura:

- `.arch i8080`: usa backend 8080;
- `.com`: label logiche a partire da `0100h`;
- `mvi c, 9`: funzione BDOS print string;
- `lxi d, msg`: `DE` punta alla stringa;
- `call 5`: entra nel BDOS;
- `ret`: ritorna al chiamante;
- `msg`: dati terminati da `$`.

## Perche' l'assembler ha due passate

Senza due passate, una label definita dopo il salto sarebbe sconosciuta:

```asm
        jmp fine
        nop
fine:   hlt
```

La prima passata risponde: "dove sono le label?". La seconda risponde: "quali
byte devo emettere?". Questa e' una delle idee piu' importanti per capire
`retronet-asm`.

## Segmentazione 8086 in parole semplici

L'8086 non mette direttamente indirizzi fisici da 20 bit nelle istruzioni. Usa
segmenti da 16 bit e offset da 16 bit.

```text
fisico = segmento * 16 + offset
```

Poiche' `segmento * 16` e' `segmento << 4`, segmenti diversi possono puntare a
zone sovrapposte.

Esempio:

```text
1000:0010 = 10010
1001:0000 = 10010
```

Stesso indirizzo fisico, due rappresentazioni logiche. Questo e' normale in real
mode.

## ModR/M spiegato come indirizzo in busta chiusa

Nel 8086 molte istruzioni non mettono tutto nell'opcode. L'opcode dice "fai una
certa famiglia di operazione"; il byte ModR/M dice "con quali registri o quale
memoria".

Pensalo come una busta:

```text
opcode: fai ADD tra registro e r/m
ModR/M: il registro e' CX, r/m e' [BP+SI+4]
```

Il decoder deve aprire la busta, calcolare l'indirizzo effettivo, scegliere il
segmento e poi leggere/scrivere il valore.

## CP/M-like: cosa succede a `CALL 0005h`

Un programma `.COM` non stampa da solo sul terminale host. Fa una chiamata BDOS.
Per stampare una stringa:

```text
C = 9
DE = indirizzo della stringa terminata da $
CALL 0005h
```

In RetroNet:

1. la CPU 8080 esegue istruzioni normali;
2. il run loop vede `PC == 0005h` o trap BDOS;
3. chiama `bdos.Handler.Call`;
4. il handler legge `C` e parametri;
5. scrive byte sul terminale;
6. simula il ritorno dalla call.

Quindi non c'e' un BDOS storico nascosto: c'e' un contratto didattico
compatibile con lo stile CP/M.

## Terminale: raw output vs schermo

Quando un programma scrive byte, ci sono due viste:

```text
raw output: tutti i byte esatti
schermo: interpretazione visibile
```

Se il programma scrive `ESC [ 2 J`, il raw output contiene quei byte. Lo schermo
li interpreta come "pulisci schermo" se ANSI e' abilitato.

Questa doppia vista e' utilissima per API e UI: puoi inviare byte raw per fedelta'
e snapshot per riallineare il browser.

## WebSocket nel progetto

Il WebSocket di `retronet-api` non e' un protocollo terminale storico. E' un
trasporto JSON semplice:

```json
{"type":"input","data":"DIR\r"}
```

Risposta:

```json
{"type":"output","data":"A>DIR\r\n..."}
```

Il vantaggio e' chiarezza. Il browser non deve sapere cos'e' un 8080, un BDOS o
un FCB. Invia input, riceve output e snapshot.

## Come riconoscere un buon confine nel codice

Un confine sano ha queste proprieta':

- il modulo a valle non importa dettagli inutili del modulo a monte;
- i dati passano attraverso interfacce piccole;
- i test possono esercitare il modulo da solo;
- la CLI e' un adattatore, non il core.

Esempi buoni in RetroNet:

- `retronet-terminal` non importa CP/M;
- `retronet-api` usa `session`, non invoca una CLI;
- `retronet-pc` usa interfacce `Bus` e `Ports`, non modifica il core 8086;
- `retronet-asm` separa lexer, parser, emitter e backend.

Questa e' una lezione architetturale che vale oltre RetroNet.

---

# Appendice A - Glossario essenziale

## ALU

Arithmetic Logic Unit. Il blocco che esegue operazioni aritmetiche e logiche:
somma, sottrazione, AND, OR, XOR, confronto, ecc. In RetroNet la ALU base e'
costruita da porte e sommatori.

## Accumulatore

Registro principale usato implicitamente da molte istruzioni. Nel 4004 e' `A` a
4 bit; nell'8008/8080 e' `A` a 8 bit; nell'8086 e' `AL/AX`.

## BCD

Binary Coded Decimal. Ogni cifra decimale viene salvata separatamente in binario.
Utile per calcolatrici e display decimali. Richiede correzioni come `DAA`.

## BDOS

Basic Disk Operating System in CP/M. In RetroNet e' un subset didattico
intercettato dal runtime, non un BDOS storico incluso in memoria.

## BIOS

Firmware di base della macchina. In `retronet-pc` non e' incluso; l'utente puo'
fornire un BIOS compatibile esterno come GLaBIOS.

## Bus

Insieme di linee o interfaccia su cui viaggiano dati, indirizzi o I/O. In
RetroNet il termine appare sia come bus di bit (`retronet-logic`) sia come bus
memoria/I/O di macchine emulate.

## Carry

Flag di riporto o prestito. Attenzione: non tutte le CPU lo interpretano nello
stesso modo durante sottrazione. I bridge servono anche a tradurre convenzioni.

## COM

Formato semplice di programma CP/M: byte caricati a `0100h`, senza header.

## Fetch/decode/execute

Ciclo base di una CPU:

1. fetch: leggi istruzione;
2. decode: capisci cosa significa;
3. execute: modifica stato.

## Flag

Bit di stato prodotti da operazioni. Esempi: Carry, Zero, Sign, Parity,
Auxiliary Carry, Overflow.

## FCB

File Control Block, struttura CP/M in memoria per descrivere file 8.3 e record
corrente.

## Gate

Porta logica. NOT, AND, OR, NAND, NOR, XOR.

## I/O

Input/output. Nelle CPU storiche puo' essere separato dalla memoria, come su
8008, 8080 e 8086.

## ModR/M

Byte dell'8086 che descrive combinazioni registro/memoria e campo esteso per
alcune istruzioni.

## Program Counter

Registro che punta alla prossima istruzione. Si chiama `PC` in molte CPU, `IP`
nell'8086.

## Real mode

Modalita' dell'8086/8088 con indirizzi fisici calcolati da segmento e offset,
senza protezione memoria moderna.

## Snapshot

Vista immutabile dello stato del terminale: righe, cursore, dimensioni, input e
output pendente.

## Stack

Struttura LIFO. Nel 4004 e 8008 e' interno e limitato; nell'8080 e 8086 vive in
memoria.

---

# Appendice B - Flussi end-to-end

## Assembly 4004 -> ROM -> emulatore

```text
calcolatrice.asm
  -> retronet-asm build
  -> calc.rom
  -> retronet-4004 -io calc.rom
  -> output display/tastiera virtuale
```

Concetti coinvolti: sintassi assembly, label, BCD, opcodes 4004, RAM 4002,
callback I/O.

## Assembly 8080 -> COM -> CP/M-like

```text
hello-bdos.asm
  -> retronet-asm build
  -> HELLO.COM
  -> upload/copia nel drive A:
  -> RUN HELLO
  -> CALL 0005h
  -> bdos.Handler
  -> retronet-terminal
```

Concetti coinvolti: `.com`, base `0100h`, BDOS function 9, terminale raw,
snapshot.

## Boot sector 8086 -> PC/XT

```text
i8086-bootok.asm
  -> retronet-asm build
  -> boot sector 512 byte
  -> retronet-pc -bios GLaBIOS -floppy boot.img
  -> BIOS legge settore a 0000:7C00
  -> codice usa INT 10h
  -> video MDA/CGA
```

Concetti coinvolti: `.orgbase 0x7C00`, firma `55 AA`, BIOS, real mode,
interrupt, video RAM.

## UI browser -> sessione CP/M

```text
browser
  -> retronet-ui
  -> POST /sessions
  -> WebSocket /sessions/{id}/ws
  -> input JSON
  -> retronet-api
  -> retronet-cpm/session
  -> shell/BDOS
  -> retronet-terminal snapshot/output
  -> browser renderizza
```

Concetti coinvolti: CORS, WebSocket JSON, stato sessione, line editor idle,
input running, upload `.COM`.

---

# Appendice C - Comandi principali

Questi comandi sono una mappa pratica, non un sostituto dei README dei singoli
repo.

## Test per repo Go

```powershell
cd C:\work\source\retronet-logic
go test ./...
```

Ripetere per i repo con `go.mod`.

## Assemblare un programma

```powershell
cd C:\work\source\retronet-asm
go run ./cmd/retronet-asm build examples\i8080-hello.asm -o C:\tmp\HELLO.COM
```

## Eseguire 4004

```powershell
cd C:\work\source\go-4004
go run ./cmd/retronet-4004 -trace testdata\bcd-add.rom
```

## Eseguire 8008

```powershell
cd C:\work\source\retronet-8008
go run ./cmd/retronet-8008 -bin programma.rom -steps 1000 -trace
```

## Eseguire 8080 con conformance

```powershell
cd C:\work\source\retronet-8080
go run ./cmd/retronet-8080 -conformance
```

## Avviare CP/M-like

```powershell
cd C:\work\source\retronet-cpm
go run ./cmd/retronet-cpm -disk C:\tmp\cpm
```

## Avviare API e UI

```powershell
cd C:\work\source\retronet-api
go run ./cmd/retronet-api -addr 127.0.0.1:8080
```

```powershell
cd C:\work\source\retronet-ui
go run ./cmd/retronet-ui -addr 127.0.0.1:18081
```

Aprire `http://127.0.0.1:18081`.

## Avviare PC/XT

```powershell
cd C:\work\source\retronet-pc
go run ./cmd/retronet-pc -bios C:\path\GLABIOS.ROM -floppy C:\path\disk.img
```

Per usare ALU a porte:

```powershell
go run ./cmd/retronet-pc -bios C:\path\GLABIOS.ROM -floppy C:\path\disk.img -alu gate
```

---

# Appendice D - Mappa dei repository

| Repo | Ruolo | Dipendenze concettuali principali |
| --- | --- | --- |
| `retronet` | Manifesto, roadmap, architettura, demo | tutti i moduli |
| `retronet-logic` | Logica combinatoria | nessuna dipendenza esterna |
| `retronet-hardware` | Stato, mini-CPU, bridge | `retronet-logic` |
| `go-4004` / `retronet-4004` | Emulatore Intel 4004 | bridge i4004 |
| `retronet-8008` | Emulatore Intel 8008 | bridge i8008, machine profile |
| `retronet-8080` | Emulatore Intel 8080 | bridge i8080 |
| `retronet-8086` | Emulatore Intel 8086/8088 | bridge i8086 |
| `retronet-pc` | IBM PC/XT compatibile | `retronet-8086` |
| `retronet-asm` | Assembler multi-arch | backend CPU |
| `retronet-cpm` | Ambiente CP/M-like | `retronet-8080`, `retronet-terminal` |
| `retronet-terminal` | Terminale condiviso | nessun core CPU |
| `retronet-api` | HTTP/WebSocket sessioni | `retronet-cpm/session` |
| `retronet-ui` | Browser UI | `retronet-api` |

---

# Appendice E - Fonti Markdown consultate

I file sotto `AGENTS.md`, `CLAUDE.md`, release note e `docs_do_not_commit` sono
stati usati come contesto tecnico e operativo, non come testo da copiare nel
libro. I file `docs_do_not_commit` sono materiale locale non pubblico.

## `go-4004`

- `go-4004\CLAUDE.md`
- `go-4004\docs\bcd.md`
- `go-4004\docs\debugger.md`
- `go-4004\docs\istruzioni-accumulatore.md`
- `go-4004\docs\istruzioni-io-ram.md`
- `go-4004\docs\istruzioni-registro.md`
- `go-4004\docs\istruzioni-salto.md`
- `go-4004\examples\moltiplicazione\README.md`
- `go-4004\examples\ram\README.md`
- `go-4004\examples\somma-bcd\README.md`
- `go-4004\examples\somma-multicifra\README.md`
- `go-4004\examples\subroutine\README.md`
- `go-4004\readme.md`

## `retronet`

- `retronet\assets\demos\calcolatrice-4004.md`
- `retronet\CONTRIBUTING.md`
- `retronet\docs\architecture.md`
- `retronet\docs\migration.md`
- `retronet\docs\milestones.md`
- `retronet\docs\references.md`
- `retronet\docs\vision.md`
- `retronet\README.md`
- `retronet\ROADMAP.md`

## `retronet-8008`

- `retronet-8008\AGENTS.md`
- `retronet-8008\docs\architettura.md`
- `retronet-8008\docs\cli.md`
- `retronet-8008\docs\conformance.md`
- `retronet-8008\docs\control-lines.md`
- `retronet-8008\docs\debugger.md`
- `retronet-8008\docs\decoder.md`
- `retronet-8008\docs\disassembler.md`
- `retronet-8008\docs\flags.md`
- `retronet-8008\docs\front-panel.md`
- `retronet-8008\docs\io.md`
- `retronet-8008\docs\istruzioni.md`
- `retronet-8008\docs\memoria.md`
- `retronet-8008\docs\periferiche.md`
- `retronet-8008\docs\profili.md`
- `retronet-8008\docs\registri.md`
- `retronet-8008\docs\release-v0.1.0.md`
- `retronet-8008\docs\roadmap.md`
- `retronet-8008\docs\stack.md`
- `retronet-8008\docs\terminale.md`
- `retronet-8008\docs\timing.md`
- `retronet-8008\docs_do_not_commit\deep-research-report.md`
- `retronet-8008\docs_do_not_commit\guida-utente.md`
- `retronet-8008\examples\README.md`
- `retronet-8008\readme.md`
- `retronet-8008\testdata\README.md`

## `retronet-8080`

- `retronet-8080\AGENTS.md`
- `retronet-8080\docs\architettura.md`
- `retronet-8080\docs\cli.md`
- `retronet-8080\docs\conformance.md`
- `retronet-8080\docs\istruzioni.md`
- `retronet-8080\docs\profili.md`
- `retronet-8080\docs\release-v0.1.0.md`
- `retronet-8080\docs\roadmap.md`
- `retronet-8080\examples\README.md`
- `retronet-8080\readme.md`
- `retronet-8080\testdata\README.md`

## `retronet-8086`

- `retronet-8086\CLAUDE.md`
- `retronet-8086\docs\architettura.md`
- `retronet-8086\README.md`

## `retronet-api`

- `retronet-api\AGENTS.md`
- `retronet-api\docs\api.md`
- `retronet-api\docs\architettura.md`
- `retronet-api\docs\release-v0.1.0.md`
- `retronet-api\docs\release-v0.2.0.md`
- `retronet-api\docs\release-v0.3.0.md`
- `retronet-api\docs\release-v0.4.0.md`
- `retronet-api\docs\sicurezza.md`
- `retronet-api\docs\websocket.md`
- `retronet-api\README.md`

## `retronet-asm`

- `retronet-asm\CLAUDE.md`
- `retronet-asm\docs\arch-i4004.md`
- `retronet-asm\docs\arch-i8008.md`
- `retronet-asm\docs\arch-i8086.md`
- `retronet-asm\docs\due-passate.md`
- `retronet-asm\docs\guida-i8008.md`
- `retronet-asm\docs\lexer.md`
- `retronet-asm\docs\org.md`
- `retronet-asm\docs\parser.md`
- `retronet-asm\docs\sintassi-asm.md`
- `retronet-asm\README.md`

## `retronet-cpm`

- `retronet-cpm\AGENTS.md`
- `retronet-cpm\docs\architettura.md`
- `retronet-cpm\docs\bdos.md`
- `retronet-cpm\docs\cli.md`
- `retronet-cpm\docs\compatibilita-cpm.md`
- `retronet-cpm\docs\demo.md`
- `retronet-cpm\docs\guida-uso.md`
- `retronet-cpm\docs\live.md`
- `retronet-cpm\docs\prossimi-passi.md`
- `retronet-cpm\docs\release-v0.1.0.md`
- `retronet-cpm\docs\release-v0.2.0.md`
- `retronet-cpm\docs\release-v0.3.0.md`
- `retronet-cpm\docs\release-v0.4.0.md`
- `retronet-cpm\docs\release-v0.4.1.md`
- `retronet-cpm\docs\release-v0.4.2.md`
- `retronet-cpm\docs\release-v0.5.0.md`
- `retronet-cpm\docs\roadmap.md`
- `retronet-cpm\docs\sessioni.md`
- `retronet-cpm\docs\shell.md`
- `retronet-cpm\docs\sicurezza-drive.md`
- `retronet-cpm\docs\stato-attuale.md`
- `retronet-cpm\docs\terminale.md`
- `retronet-cpm\docs\verso-retronet-api.md`
- `retronet-cpm\examples\lib\README.md`
- `retronet-cpm\examples\README.md`
- `retronet-cpm\README.md`
- `retronet-cpm\testdata\README.md`

## `retronet-hardware`

- `retronet-hardware\AGENTS.md`
- `retronet-hardware\CLAUDE.md`
- `retronet-hardware\CONTRIBUTING.md`
- `retronet-hardware\docs\bridge.md`
- `retronet-hardware\docs\cpu-isa.md`
- `retronet-hardware\docs\flip-flop.md`
- `retronet-hardware\docs\latch.md`
- `retronet-hardware\docs\miniasm.md`
- `retronet-hardware\docs\mini-cpu.md`
- `retronet-hardware\docs\program-counter.md`
- `retronet-hardware\docs\README.md`
- `retronet-hardware\docs\register.md`
- `retronet-hardware\docs\register-file.md`
- `retronet-hardware\README.md`

## `retronet-logic`

- `retronet-logic\AGENTS.md`
- `retronet-logic\CLAUDE.md`
- `retronet-logic\CONTRIBUTING.md`
- `retronet-logic\docs\adder.md`
- `retronet-logic\docs\alu.md`
- `retronet-logic\docs\bit.md`
- `retronet-logic\docs\bus.md`
- `retronet-logic\docs\full-adder.md`
- `retronet-logic\docs\gates.md`
- `retronet-logic\docs\half-adder.md`
- `retronet-logic\docs\mux.md`
- `retronet-logic\docs\README.md`
- `retronet-logic\docs\shifter.md`
- `retronet-logic\README.md`

## `retronet-pc`

- `retronet-pc\CLAUDE.md`
- `retronet-pc\docs\architettura.md`
- `retronet-pc\README.md`

## `retronet-terminal`

- `retronet-terminal\AGENTS.md`
- `retronet-terminal\docs\ansi.md`
- `retronet-terminal\docs\api.md`
- `retronet-terminal\docs\architettura.md`
- `retronet-terminal\docs\contratto.md`
- `retronet-terminal\docs\live.md`
- `retronet-terminal\docs\release-v0.1.1.md`
- `retronet-terminal\docs\release-v0.2.0.md`
- `retronet-terminal\docs\release-v0.2.1.md`
- `retronet-terminal\docs\release-v0.3.0.md`
- `retronet-terminal\docs\release-v0.4.0.md`
- `retronet-terminal\README.md`

## `retronet-ui`

- `retronet-ui\AGENTS.md`
- `retronet-ui\docs\architettura.md`
- `retronet-ui\docs\guida-uso.md`
- `retronet-ui\docs\release-v0.1.0.md`
- `retronet-ui\docs\release-v0.2.0.md`
- `retronet-ui\docs\sicurezza.md`
- `retronet-ui\README.md`

---

# Appendice F - Codice ispezionato per il tour tecnico

Oltre ai Markdown, sono stati ispezionati i nuclei di codice necessari a
spiegare responsabilita' reali e data flow:

- `retronet-logic\alu\alu.go`
- `retronet-hardware\cpu\cpu.go`
- `retronet-hardware\bridge\i4004\i4004.go`
- `retronet-hardware\bridge\i8008\i8008.go`
- `retronet-hardware\bridge\i8080\i8080.go`
- `retronet-hardware\bridge\i8086\i8086.go`
- `go-4004\cpu\cpu.go`
- `go-4004\cpu\instructions.go`
- `retronet-8008\cpu\cpu.go`
- `retronet-8008\cpu\step.go`
- `retronet-8080\cpu\cpu.go`
- `retronet-8080\cpu\step.go`
- `retronet-8086\cpu\registers.go`
- `retronet-8086\cpu\cpu.go`
- `retronet-8086\cpu\step.go`
- `retronet-8086\cpu\execute.go`
- `retronet-pc\machine\machine.go`
- `retronet-pc\memory\bus.go`
- `retronet-pc\device\fdc.go`
- `retronet-pc\device\textvideo.go`
- `retronet-asm\internal\lexer\lexer.go`
- `retronet-asm\internal\parser\parser.go`
- `retronet-asm\internal\emitter\emitter.go`
- `retronet-asm\cmd\retronet-asm\main.go`
- `retronet-cpm\cpm\machine.go`
- `retronet-cpm\bdos\bdos.go`
- `retronet-cpm\session\session.go`
- `retronet-cpm\shell\shell.go`
- `retronet-terminal\terminal.go`
- `retronet-terminal\live\runner.go`
- `retronet-terminal\cmd\retronet-terminal-api\main.go`
- `retronet-api\internal\server\manager.go`
- `retronet-api\internal\server\server.go`
- `retronet-ui\internal\site\site.go`
- `retronet-ui\internal\site\static\app.js`
