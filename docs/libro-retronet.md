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
gate-level, gli emulatori 4004/8008/8080/8086, un PC/XT in sviluppo avanzato,
un assembler multi-architettura, un runtime CP/M-like, un terminale condiviso,
API e UI.

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

## Come analizzare il progetto

Un buon modo per leggere RetroNet e' trattarlo come una serie di contratti, non
come una pila indistinta di codice. Ogni repo risponde a tre domande:

- quali dati riceve?
- quali dati produce?
- quali responsabilita' rifiuta di assumersi?

Per esempio, `retronet-asm` riceve testo e produce byte. Non esegue i byte, non
renderizza output, non conosce sessioni WebSocket. `retronet-8080` riceve byte
in memoria e produce modifiche a registri, memoria, I/O e flag. Non sa nulla di
file CP/M o upload HTTP. `retronet-cpm` traduce convenzioni CP/M-like in servizi
host controllati. Non deve sapere come il browser disegna il terminale.

Questa griglia di analisi aiuta anche quando si cerca un bug. Se un programma
`.COM` non stampa, le domande diventano concrete:

```text
assembler: ha prodotto CALL 0005h e stringa terminata da $?
8080: PC, SP e registri arrivano allo stato atteso?
cpm: la trap BDOS intercetta la chiamata?
terminal: i byte scritti compaiono nel raw output?
api/ui: il client sta drenando output e snapshot?
```

La risposta restringe subito il campo.

## Esempio di percorso completo

Immagina un programma CP/M-like che stampa `CIAO`. Il percorso reale non e'
"la UI esegue un programma", ma una catena di passaggi piccoli:

```text
retronet-asm
  legge sorgente i8080 con .com
  produce CIAO.COM

retronet-api
  crea una sessione con drive temporaneo
  riceve upload di CIAO.COM

retronet-cpm
  carica CIAO.COM a 0100h
  intercetta CALL 0005h
  scrive byte sul terminale

retronet-terminal
  conserva raw output
  aggiorna snapshot schermo

retronet-ui
  renderizza snapshot e scrollback nel browser
```

Questo esempio mostra perche' i repo sono separati: ogni passaggio si puo'
testare da solo, ma l'insieme racconta una macchina usabile.

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

La terza scelta e' rendere osservabile ogni tappa. Quasi tutti i moduli hanno
trace, snapshot, conformance, esempi o test che trasformano lo stato interno in
qualcosa di leggibile. Questo e' essenziale in un progetto educativo: se il
lettore non puo' vedere `PC`, registri, flag, memoria o output, resta davanti a
una scatola nera.

## Dentro il codice del repo vetrina

`retronet` non e' il posto in cui cercare un package Go centrale. Il suo codice
operativo e' fatto soprattutto di documentazione e script. Questo e' coerente
con il ruolo del repo: non deve diventare una dipendenza comune, deve restare la
mappa dell'ecosistema.

I due file piu' utili da leggere come "codice di orchestrazione" sono gli script
di integrazione:

```text
scripts/test-integration.sh
scripts/test-integration.ps1
```

La loro logica e' didatticamente importante:

```text
1. entra nel repo assembler
2. assembla sorgenti di esempio
3. entra nel repo emulatore
4. esegue i byte prodotti
5. confronta l'output atteso
```

Questo evita un anti-pattern frequente nei monorepo didattici: importare tutto
da tutto. RetroNet preferisce verificare il contratto tra programmi separati,
come farebbe un utente reale dalla riga di comando.

Anche gli script di migrazione (`scripts/migrate.sh` e `scripts/migrate.ps1`)
sono parte dell'architettura: ricreano checkout sibling e `go.work` locali,
senza versionare nel repo vetrina i workspace privati della macchina dello
sviluppatore. Questo separa il codice pubblicabile dalla comodita' di sviluppo.

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

## Esempio guidato: sommare 3 e 5

Per capire perche' il progetto parte dai gate, guarda una somma minuscola a 4
bit:

```text
3 = 0011
5 = 0101
    ----
8 = 1000
```

La CPU non vede il numero "otto" come concetto matematico. Vede quattro full
adder in fila. Il bit 0 somma `1+1` e produce `0` con carry. Il bit 1 riceve
`1+0+carry` e produce ancora `0` con carry. Il bit 2 riceve `0+1+carry` e
produce `0` con carry. Il bit 3 riceve `0+0+carry` e produce `1`.

La tabella intermedia e':

```text
bit | a b cin | sum cout
0   | 1 1  0  |  0    1
1   | 1 0  1  |  0    1
2   | 0 1  1  |  0    1
3   | 0 0  1  |  1    0
```

Il risultato e' `1000`. Il carry finale e' `0`, quindi non c'e' overflow
unsigned fuori dai 4 bit. Da questa micro-tabella nascono somme a 8, 16 e piu'
bit: cambia la larghezza del bus, non il principio.

## Esempio guidato: sottrarre 5 da 3

La sottrazione mostra ancora meglio il valore didattico della ALU:

```text
3 - 5, a 4 bit

3       = 0011
5       = 0101
NOT(5)  = 1010
+ 1     = 1011
0011 + 1011 = 1110
```

`1110` e' -2 in complemento a due a 4 bit. Il circuito ha fatto solo una somma,
ma l'interpretazione signed dice "meno due". Se invece guardi lo stesso pattern
come unsigned, vale 14. Questa distinzione spiega perche' le CPU hanno flag
diversi: `Carry` parla di aritmetica unsigned, `Sign` guarda il bit alto,
`Overflow` serve per l'aritmetica con segno.

## Cosa osservare nei test

I test di `retronet-logic` sono particolarmente utili perche' hanno forma quasi
matematica. Un buon test non verifica soltanto "un caso carino", ma l'intera
tabella di verita' quando lo spazio e' piccolo:

```text
AND: 4 combinazioni
half adder: 4 combinazioni
full adder: 8 combinazioni
ALU 4 bit: molte combinazioni, ma ancora campionabili
```

Quando una ALU fallisce, il bug spesso non e' nell'operazione visibile ma nella
semantica dei flag. Per questo i test devono controllare risultato e flag
insieme: `0xFF + 0x01` e `0x7F + 0x01` possono sembrare entrambe "somme", ma
raccontano storie diverse per `Carry` e `Overflow`.

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

## Dentro il codice Go

La prima cosa da sapere e' che `bus.Bus` e' una slice con il bit meno
significativo all'indice 0:

```go
type Bus []bit.Bit
```

Questa convenzione rende naturale il ripple-carry. Il sommatore parte da `i=0`,
cioe' dal bit di peso 1, e propaga il carry verso gli indici successivi:

```go
cout = cin
sum = make(bus.Bus, a.Width())
for i := range a {
    sum[i], cout = fulladder.Add(a[i], b[i], cout)
}
```

Quando `Bus.String()` stampa un valore, deve invertire la prospettiva: l'umano
si aspetta il bit piu' significativo a sinistra, quindi `b[0]` finisce
all'estrema destra della stringa.

`alu.Compute` e' il punto di ingresso piu' importante:

```go
func Compute(op Op, a, b bus.Bus, cin bit.Bit) (out bus.Bus, flags Flags)
```

La funzione fa tre cose:

- controlla che i bus abbiano la stessa larghezza;
- sceglie l'operazione con uno `switch`;
- calcola i flag derivati dal risultato.

La sottrazione e' il caso piu' istruttivo:

```go
out, flags.Carry = adder.Add(a, notBus(b), cin)
```

Non c'e' un sottrattore separato. Con `cin=1`, questa riga significa:

```text
a + NOT(b) + 1
```

Il flag `Carry` che torna dall'adder significa "nessun prestito" nella
convenzione interna della ALU. I bridge verso 8008, 8080 e 8086 lo trasformano
quando la CPU storica vuole invece un flag di prestito.

I flag `Zero` e `Parity` sono riduzioni logiche:

```text
Zero   = NOT(OR di tutti i bit)
Parity = NOT(XOR di tutti i bit)
```

Questo e' un dettaglio elegante: anche i flag non sono calcolati con scorciatoie
aritmetiche, ma con la stessa logica elementare del resto del repo.

## Esempio Go: usare la ALU a 4 bit

Un lettore puo' immaginare questo piccolo uso:

```go
a := bus.FromUint(7, 4)
b := bus.FromUint(5, 4)
out, flags := alu.Compute(alu.Add, a, b, bit.Zero)
```

`out.String()` vale `1100`, cioe' 12 binario. `flags.Carry` e' `0`, perche' 12
entra ancora in 4 bit. Se poi un bridge o una istruzione BCD decide che `1100`
non e' una cifra decimale valida, quello e' un livello semantico superiore: la
ALU ha fatto correttamente il suo lavoro binario.

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

## Esempio guidato: una istruzione attraversa la mini-CPU

Prendi un'istruzione ideale `ADD R0, R1`. Il suo viaggio e' piu' interessante
del risultato:

```text
1. PC punta al byte opcode
2. fetch legge mem[PC]
3. PC viene incrementato
4. decode separa opcode, registro destinazione e sorgente
5. register file espone R0 e R1
6. ALU riceve due bus a 8 bit
7. risultato e flag tornano al datapath
8. il clock scrive il nuovo valore in R0
```

La cosa da notare e' che lo stato cambia solo nei punti controllati. La ALU puo'
calcolare un risultato combinatorio appena vede gli ingressi, ma il registro non
lo conserva finche' il clock non lo cattura. Questa separazione tra "valore
calcolato" e "valore registrato" e' uno dei mattoni mentali piu' importanti per
capire una CPU.

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

La stessa sequenza puo' essere letta come pseudocodice:

```text
R0 = 0
R1 = 5
R2 = 1
while R1 != 0:
    R0 = R0 + R1
    R1 = R1 - R2
mem[0x20] = R0
halt
```

Il valore didattico sta nella distanza fra i due livelli. Il pseudocodice e'
comodo per l'umano; l'ISA mostra quali registri, flag e salti servono davvero.

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

## Dettagli da osservare

Tre dettagli meritano attenzione quando leggi il codice:

- `PC` e `SP` sono registri speciali, ma vengono comunque trattati come stato
  aggiornato a passi controllati;
- `push` e `pop` non sono operazioni astratte: scrivono e leggono memoria,
  poi muovono lo stack pointer;
- gli helper che simulano clock basso/alto rendono visibile il confine tra
  circuito combinatorio e circuito sequenziale.

Questo e' il capitolo in cui RetroNet smette di essere una libreria di funzioni
logiche e diventa una macchina che evolve nel tempo.

## Dentro il codice Go

La mini-CPU sta quasi tutta in `retronet-hardware/cpu/cpu.go`. La struct mostra
subito il confine tra componenti:

```go
type CPU struct {
    regs *registerfile.File
    pc   *pc.PC
    sp   *register.Register
    mem  *memory.RAM

    Carry bool
    Zero  bool
    Halted bool
}
```

`regs`, `pc` e `sp` sono componenti sequenziali. `mem` e' memoria. I flag sono
stato della CPU. `Halted` e' controllo di esecuzione.

Il ciclo istruzione e' tutto in `Step`:

```go
opcode := c.fetch()
op := opcode >> 4
rd := int((opcode >> 2) & 0x03)
rs := int(opcode & 0x03)
```

Questa decodifica rispecchia l'ISA del capitolo: nibble alto per l'operazione,
due campi da 2 bit per registri. Poi lo `switch` e' volutamente diretto:

```go
case opLDI:
    c.writeReg(rd, byteBus(c.fetch()))
case opADD:
    c.aluOp(alu.Add, rd, rs, bit.Zero)
case opJZ:
    addr := c.fetch()
    if c.Zero {
        c.jump(addr)
    }
```

`fetch` e' piccolo ma denso:

```go
b := c.mem.Read(c.PC())
c.tickPC(zeroAddr, bit.Zero, bit.One)
return b
```

Il PC non viene incrementato con `c.pc++`: viene pilotato come componente
sequenziale. `tickPC` chiama `Step` due volte, clock basso e clock alto:

```go
c.pc.Step(addr, load, inc, bit.Zero)
c.pc.Step(addr, load, inc, bit.One)
```

Lo stesso pattern appare in `writeReg` e `writeSP`. Questo rende visibile il
clock anche se siamo in Go.

`push` e `pop` sono un altro buon esempio:

```go
c.mem.Write(c.SP(), v)
dec, _ := adder.Add(c.sp.Value(), byteBus(0xFF), bit.Zero)
c.writeSP(dec)
```

Per decrementare uno stack pointer a 8 bit, il codice somma `0xFF`, cioe' -1 in
complemento a due. Anche qui, l'idea didattica e' piu' importante della
scorciatoia: si poteva scrivere `SP--`, ma si perderebbe il legame con i gate.

## Dentro i bridge

I bridge sono traduttori tra due mondi:

```text
valori Go della CPU storica -> bus.Bus -> alu.Compute -> flag CPU storica
```

Nel bridge i8080, per esempio, `ALU` converte `a` e `value` in bus a 8 bit,
chiama la ALU e poi applica convenzioni 8080:

```go
out, f := alu.Compute(alu.Sub, av, bv, bit.One)
return arith(out, f, auxSub(a, value, false), true)
```

Il parametro `isSub` dice ad `arith` di invertire il carry interno:

```go
carry := f.Carry.IsHigh()
if isSub {
    carry = !carry
}
```

Questa riga spiega un intero problema storico: la ALU di base dice "nessun
prestito"; l'8080 espone `Carry` come prestito.

Nel bridge i8086 il lavoro e' piu' ricco. `arith` calcola anche Overflow:

```text
OF = carry_entrante_nel_bit_di_segno != carry_uscente
```

e la parity guarda solo gli 8 bit bassi anche per operazioni a 16 bit. Questi
dettagli sono proprio il motivo per cui i bridge esistono: non basta sommare,
bisogna sommare con la semantica esatta della CPU chiamante.

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

## Esempio guidato: `7 + 5` in BCD

Un programma 4004 per `7 + 5` puo' stare in pochissime istruzioni:

```asm
    FIM R0, 0x05   ; R1 = 5
    LDM 7          ; A = 7
    ADD R1         ; A = 12 binario, cifra BCD non valida
    DAA            ; A=2, C=1 dopo la correzione BCD
halt:
    JUN halt
```

La parte importante e' distinguere due risultati:

```text
somma binaria a 4 bit: 7 + 5 = 12 -> A=12, carry=0
dopo DAA: carry=1 e A=2 -> "12"
```

Senza `DAA`, molte somme decimali sembrerebbero funzionare solo per caso. `3+4`
resta valido perche' produce `7`; `7+5` produce una cifra non valida e richiede
l'aggiustamento.

## Esempio guidato: scrivere nella RAM 4002

Per scrivere una cifra in RAM, il 4004 non usa un indirizzo lineare come
`mem[0x20]`. Prima prepara una coppia di registri con `FIM`, poi la seleziona
con `SRC`, poi scrive con `WRM`:

```asm
    LDM 0
    DCL            ; seleziona banco RAM 0
    FIM R0, 0x03   ; coppia R0:R1 seleziona registro/carattere
    SRC R0
    LDM 9
    WRM            ; scrive 9 nella cella selezionata
halt:
    JUN halt
```

Questo esempio e' piccolo ma rivela il carattere del 4004: la RAM non e' un
array neutro, e' un dispositivo indirizzato tramite registri e segnali dedicati.

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

## Come leggere una traccia 4004

Una traccia tipica mostra `PC`, opcode, mnemonico, accumulatore e carry:

```text
PC=002 OP=D7 LDM 7      A=7 C=false
PC=003 OP=81 ADD R1     A=12 C=false
PC=004 OP=FB DAA        A=2 C=true
```

Non bisogna leggerla come log di alto livello, ma come storia del fetch/execute.
Il `PC` indica dove si trova l'opcode; `OP` e' il byte in ROM; `A` e `C` sono lo
stato visibile dopo l'istruzione. Se una routine BCD sbaglia, questa traccia
permette di capire se l'errore nasce prima della somma, nella propagazione del
carry o nell'aggiustamento decimale.

## Tour del codice

`go-4004\cpu\cpu.go` contiene lo stato: `A`, `C`, `R`, `PC`, `CL`, `Stack`, `SP`,
`SRCAddr` e callback I/O. `Step` si occupa di fetch, lunghezza istruzione e
dispatch. `go-4004\cpu\instructions.go` contiene la semantica: ogni caso dello switch
modifica stato CPU o RAM.

Il codice e' esplicito, quasi narrativo. Questo e' un bene per un emulatore
didattico: invece di comprimere tutto in tabelle opache, fa vedere cosa succede.

## Dentro il codice Go

La struct `CPU4004` e' una mappa compatta del chip:

```go
type CPU4004 struct {
    A  uint8
    C  bool
    R  [16]uint8
    PC uint16
    CL uint8

    Stack [3]uint16
    SP    uint8
    SRCAddr uint8
}
```

Go non ha un tipo a 4 bit, quindi il codice usa `uint8` e maschera sempre con:

```go
func nibble(v uint8) uint8 {
    return v & 0x0F
}
```

Questa funzione sembra piccola, ma e' il guardrail dell'intero emulatore. Senza
di lei, un registro 4004 potrebbe accidentalmente contenere `0x10`, valore
impossibile per un registro a nibble.

`Step` fa fetch, incrementa `PC`, poi decide se deve leggere un secondo byte:

```go
op, err = readROM(rom, c.PC)
c.PC = (c.PC + 1) & 0x0FFF
```

Il mask `0x0FFF` mantiene il program counter a 12 bit. Le istruzioni a due byte
passano a `executeWithArg`; `FIN` viene gestita direttamente in `Step` perche'
deve leggere la ROM in modo speciale; il gruppo `0xE` passa a `executeIO`
perche' ha bisogno di RAM e porte.

La scelta di tenere `SRCAddr` dentro la CPU e' spiegata dai commenti del codice:
sul 4004 reale `SRC` mette un valore sui pin e il chip RAM 4002 lo trattiene.
Nell'emulatore quel valore resta nella struct per mantenere semplice la firma di
esecuzione. E' una piccola astrazione pratica, non una pretesa di essere pin-level.

## Codice Go: stack e subroutine

Lo stack hardware a tre livelli e' modellato cosi':

```go
func (c *CPU4004) push(addr uint16) {
    c.Stack[c.SP%3] = addr & 0x0FFF
    c.SP++
    if c.SP > 5 {
        c.SP -= 3
    }
}
```

Il modulo `%3` replica il comportamento ciclico: il quarto push non genera un
errore moderno, sovrascrive. Questa e' una scelta storicamente sensata per una
CPU piccola e senza protezioni.

`JMS` salva il PC gia' avanzato oltre i due byte dell'istruzione:

```go
c.push(c.PC)
c.PC = (uint16(high) << 8) | uint16(arg)
```

`BBL` fa il contrario:

```go
c.A = nibble(low)
c.PC = c.pop()
```

Ritorna e carica anche un valore in `A`. Questo doppio effetto e' tipico del
4004 e spiega perche' non bisogna interpretarlo come un semplice `RET` moderno.

## Codice Go: I/O e RAM 4002

`executeIO` traduce `DCL` e `SRC` in coordinate della RAM:

```go
banco := c.CL & 0x3
reg := (c.SRCAddr >> 4) & 0x3
char := int(c.SRCAddr & 0x0F)
```

Poi le istruzioni sono quasi letterali:

```go
case OP_WRM:
    ram.Data[banco][reg][char] = nibble(c.A)
case OP_RDM:
    c.A = nibble(ram.Data[banco][reg][char])
```

Questo e' il vantaggio del codice esplicito: il lettore vede subito che `WRM`
non sta scrivendo in una memoria lineare, ma in una struttura a banco,
registro, carattere.

Le istruzioni `ADD`, `SUB`, `IAC`, `DAC`, `RAL` e `RAR` passano invece dal bridge
i4004:

```go
c.A, c.C = i4004.Add(c.A, c.R[low], c.C)
c.A, c.C = i4004.RotateLeftThroughCarry(c.A, c.C)
```

Il core 4004 resta quindi leggibile, ma l'aritmetica non viene duplicata:
arriva dalla stessa ALU didattica usata dagli altri moduli.

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

## Esempio guidato: sommare 5+4+3+2+1

Un esempio 8008 classico usa un contatore in `B` e l'accumulatore `A`:

```asm
        LBI 5       ; B = 5
        LAI 0       ; A = 0
loop:
        ADB         ; A = A + B
        DCB         ; B = B - 1
        JFZ loop    ; continua finche' Zero non e' impostato
        HLT
```

Il punto non e' memorizzare i mnemonici, ma osservare il ruolo dei flag. `DCB`
aggiorna `Zero`; il salto condizionale decide se il ciclo continua. Alla fine
`A` contiene `15`.

In forma di stato:

```text
inizio: A=0, B=5
giro 1: A=5,  B=4, Z=0
giro 2: A=9,  B=3, Z=0
giro 3: A=12, B=2, Z=0
giro 4: A=14, B=1, Z=0
giro 5: A=15, B=0, Z=1
```

Questa e' la prima tappa RetroNet in cui un loop a 8 bit sembra familiare a chi
ha visto assembly successivi, pur mantenendo limiti storici come stack interno e
spazio indirizzi a 14 bit.

## Esempio guidato: input e output separati

L'I/O separato significa che leggere una porta non e' leggere memoria. Un
programma puo' ricevere un byte da una porta e scriverlo su un'altra senza
toccare il bus memoria:

```text
porta input 0  -> accumulatore
accumulatore   -> porta output 8
```

Nel repo questo flusso puo' essere simulato con callback, trace I/O o terminale
buffered. Se il trace mostra che l'istruzione `OUT` viene eseguita ma il
terminale resta vuoto, il bug probabilmente non e' nel decoder CPU: e' nel
collegamento fra porta, periferica e terminale.

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

## Dentro il codice Go

`CPU8008` espone registri e flag come campi semplici:

```go
type CPU8008 struct {
    A, B, C, D, E, H, L uint8
    Carry, Zero, Sign, Parity bool
    PC uint16
    Stack [8]uint16
    SP uint8
    Halted, Stopped bool
}
```

Il reset storico e' visibile nel codice:

```go
func (c *CPU8008) Reset() {
    *c = CPU8008{
        Halted: true,
        Stopped: true,
    }
}
```

Questa e' una differenza concreta rispetto all'8080. Se `Step` viene chiamato
prima di una jam instruction, restituisce `ErrCPUStopped` e non legge memoria:

```go
if c.Halted || c.Stopped {
    return ErrCPUStopped
}
```

`fetch` legge e poi usa `setPC`, che maschera a 14 bit:

```go
value := mem.Read(c.PC)
c.setPC(c.PC + 1)
return value
```

La maschera non e' decorazione: ricorda che `PC` e' un campo Go da 16 bit, ma
l'8008 vede solo 14 bit di indirizzo.

## Codice Go: decoder da 256 opcode

Il decoder e' generato da `buildDecoder()`:

```go
for i := range table {
    code := byte(i)
    execute := ExecuteFunc(unimplementedExecute)
    if isInputOpcode(code) {
        execute = executeInput
    }
    ...
    table[i] = Opcode{Code: code, Mnemonic: mnemonicFor(code), Execute: execute}
}
```

Il pattern e' semplice:

```text
parti da "non implementato"
riconosci famiglie opcode con funzioni is...
assegna execute appropriato
calcola lunghezza, timing e mnemonico
```

Questo evita una tabella scritta a mano da 256 righe, ma conserva la tabella a
runtime. `Step` poi non deve sapere come si riconosce un `LBI` o un `ADB`:

```go
code := c.fetch(mem)
op := Decode(code)
...
return op.Execute(c, mem, io, inst)
```

Il decoder descrive; le funzioni `execute...` modificano lo stato.

## Codice Go: ALU 8008

L'ALU 8008 non e' implementata come aritmetica sparsa nei casi opcode. Il file
`cpu/alu.go` delega al bridge:

```go
result, flags := i8008.ALU(group, c.A, value, c.Carry)
c.Carry = flags.Carry
c.Zero = flags.Zero
c.Sign = flags.Sign
c.Parity = flags.Parity
if group&0x07 != i8008.GroupCMP {
    c.A = result
}
```

La riga su `CMP` e' didatticamente preziosa: compare e' una sottrazione che
aggiorna i flag ma non salva il risultato nell'accumulatore. Il codice lo rende
esplicito.

`INR` e `DCR` usano bridge dedicati e non modificano il carry:

```text
Increment/Decrement -> aggiorna Zero, Sign, Parity
Carry resta quello che era
```

Questo piccolo dettaglio rompe molti emulatori se viene dimenticato.

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

## Esempio guidato: da byte a stato CPU

Il programma raw minimo del README e':

```text
3E 2A 76
```

Disassemblato:

```asm
MVI A, 2Ah
HLT
```

La lettura passo-passo e':

```text
PC=0000 legge 3E       -> istruzione MVI A,imm
PC=0001 legge 2A       -> immediato
A=2A, PC=0002
PC=0002 legge 76       -> HLT
Halted=true
```

Questo esempio mostra la differenza tra opcode e operando. `3E` dice "carica
un immediato in A"; `2A` e' il dato. Se il PC avanzasse di un solo byte invece
di due, la CPU proverebbe a interpretare `2A` come opcode e l'intero flusso si
romperebbe.

## Esempio guidato: un `.COM` che stampa

Quando l'8080 viene usato da `retronet-cpm`, il programma puo' seguire la
convenzione CP/M:

```asm
.arch i8080
.com
        mvi c, 9
        lxi d, msg
        call 5
        ret
msg:    .byte "CIAO$"
```

Qui `mvi c, 9` sceglie la funzione BDOS "print string"; `lxi d, msg` passa
l'indirizzo della stringa; `call 5` entra nel contratto CP/M-like. Il core 8080
esegue solo istruzioni. E' il runtime CP/M-like, non la CPU, a intercettare la
chiamata e scrivere sul terminale.

Questa separazione e' il motivo per cui `retronet-8080` puo' restare un core
pulito, mentre `retronet-cpm` puo' evolvere il proprio subset BDOS senza
sporcare il decoder della CPU.

## Esempio guidato: flag dopo una sottrazione

Considera:

```asm
MVI A, 03h
SUI 05h
```

Il risultato a 8 bit e' `FEh`, cioe' -2 se lo interpreti in complemento a due.
I flag raccontano piu' del solo byte:

```text
A = FEh
Sign = 1       ; bit alto acceso
Zero = 0       ; risultato non zero
Carry = 1      ; per l'8080 indica prestito nella sottrazione
Parity = 0     ; FEh ha 7 bit a uno, dispari
```

Questo e' uno dei punti in cui il bridge ALU serve davvero: la ALU di base puo'
avere una convenzione interna sul prestito, ma il core 8080 deve esporre la
convenzione storica dell'8080.

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

## Dentro il codice Go

`CPU8080` e' piu' software-friendly dell'8008 gia' nella struct:

```go
type CPU8080 struct {
    A, B, C, D, E, H, L byte
    Carry, Zero, Sign, Parity, AuxiliaryCarry bool
    PC uint16
    SP uint16
    Halted, Stopped, InterruptsEnabled bool
    alu ALUBackend
}
```

`SP` e' un vero indirizzo a 16 bit. Le coppie registro sono helper:

```go
func (c *CPU8080) HL() uint16 { return uint16(c.H)<<8 | uint16(c.L) }
func (c *CPU8080) SetHL(value uint16) {
    c.H = byte(value >> 8)
    c.L = byte(value)
}
```

`readRegister` e `writeRegister` mostrano il significato del pseudo-registro
`M`:

```go
case RegM:
    return mem.Read(c.HL()), nil
```

Quindi `MOV A,M` non legge un registro fisico: legge memoria all'indirizzo `HL`.

## Codice Go: `Step` e istruzioni

`Step` e' simile all'8008, ma senza reset fermo:

```go
pcBefore := c.PC
code := c.fetch(mem)
op := Decode(code)
inst := Instruction{PC: pcBefore, Opcode: op}
```

Poi legge gli operandi secondo `op.Length` e chiama `op.Execute`. La semantica
principale vive in `execute8080`, che usa pattern di bit per famiglie intere:

```go
case code&0xC0 == 0x40:
    return executeMOV(c, mem, code)
case code&0xC7 == 0x06:
    return c.writeRegister(Register((code>>3)&0x07), inst.Operands[0], mem)
case code&0xC0 == 0x80:
    value, _ := c.readRegister(Register(code&0x07), mem)
    c.executeALU((code>>3)&0x07, value)
```

Questo e' un buon modo per leggere emulatori: gli opcode non sono tutti casi
isolati, molte famiglie sono codificate con campi interni.

## Codice Go: stack e PSW

Lo stack 8080 cresce verso il basso:

```go
func (c *CPU8080) pushWord(mem Memory, value uint16) {
    c.SP--
    mem.Write(c.SP, byte(value>>8))
    c.SP--
    mem.Write(c.SP, byte(value))
}
```

`popWord` legge prima il byte basso, poi quello alto:

```go
low := mem.Read(c.SP)
c.SP++
high := mem.Read(c.SP)
c.SP++
return uint16(high)<<8 | uint16(low)
```

Questo spiega la little-endian dello stack: dopo il push, `SP` punta al byte
basso.

`PUSH PSW` usa `FlagsByte`:

```go
var f byte = 0x02
if c.Sign { f |= 0x80 }
if c.Zero { f |= 0x40 }
if c.AuxiliaryCarry { f |= 0x10 }
if c.Parity { f |= 0x04 }
if c.Carry { f |= 0x01 }
```

Il bit `0x02` sempre acceso e' un dettaglio storico del byte flags 8080. Anche
questo e' un esempio di "semantica CPU" che non puo' essere lasciata a una
rappresentazione generica.

## Codice Go: backend ALU

Il core non chiama direttamente il bridge: passa da un'interfaccia `ALUBackend`.
`executeALU` e' corto:

```go
result, flags := c.backend().ALU(group, c.A, value, c.Carry)
c.applyALUFlags(flags)
if group&0x07 != i8080.GroupCMP {
    c.A = result
}
```

Il vantaggio e' che `Gate` e `Native` hanno lo stesso contratto. Il core 8080 non
sa quale sia attivo; sa solo che ricevera' risultato e flag 8080.

`DAA` e' un buon esempio di codice CPU-specifico che resta nel core:

```text
se nibble basso > 9 o AC -> aggiungi 0x06
se A > 0x99 o Carry -> aggiungi 0x60
```

La correzione viene poi eseguita tramite backend ALU, cosi' anche l'aggiustamento
decimale mantiene coerenza con il motore aritmetico scelto.

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

## Esempio guidato: stesso indirizzo, segmenti diversi

In real mode lo stesso indirizzo fisico puo' avere piu' forme logiche:

```text
1000:0010 -> 10010
1001:0000 -> 10010
0FFF:0020 -> 10010
```

Questo non e' un bug: e' una conseguenza del fatto che il segmento viene
spostato di 4 bit. Quando leggi un trace 8086 devi quindi guardare sempre coppia
segmento/offset, non solo l'offset. Un `IP=7C00` significa poco senza sapere il
`CS`; `0000:7C00` e `07C0:0000` puntano allo stesso byte fisico, ma raccontano
due convenzioni di programma diverse.

## Esempio guidato: un byte ModR/M

Prendi un'istruzione concettuale:

```asm
add ax, [bp+si+4]
```

L'opcode dice "questa e' una forma della famiglia ADD"; il ModR/M dice come
trovare l'operando memoria. Il decoder deve:

```text
mod  = displacement a 8 bit
reg  = AX
r/m  = BP + SI
disp = 4
segmento default = SS, perche' c'e' BP
indirizzo effettivo = BP + SI + 4
fisico = SS:indirizzo_effettivo
```

Questa e' la ragione per cui `modrm.go` e' un file centrale: molte istruzioni
non possono nemmeno sapere dove leggere o scrivere finche' il ModR/M non viene
decodificato.

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

## Esempio guidato: copiare una stringa con `REP MOVSB`

Una routine di copia puo' essere pensata cosi':

```asm
    cld             ; Direction Flag = avanti
    mov cx, 5       ; numero byte
    mov si, src
    mov di, dst
    rep movsb
```

Ogni iterazione legge da `DS:SI`, scrive in `ES:DI`, aggiorna `SI` e `DI`, poi
decrementa `CX`. Il prefisso `REP` ripete finche' `CX` arriva a zero.

In forma di stato:

```text
prima: CX=5, SI=src,   DI=dst
dopo:  CX=0, SI=src+5, DI=dst+5
```

Se `STD` avesse impostato il Direction Flag, gli indici si muoverebbero
all'indietro. Questo e' un esempio perfetto di istruzione in cui un flag di
controllo, non un operando esplicito, cambia il comportamento.

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

Sul dataset SingleStepTests 8088 documentato nel README, il core passa il 99,15%
dei casi complessivi e il 100% del comportamento definito. I residui riguardano
aree in cui il silicio storico lascia valori indefiniti, per esempio flag dopo
alcuni errori di divisione o input BCD non validi. Questo e' un dettaglio
importante: una conformance seria non misura solo "quanti test passano", ma
anche se i fallimenti appartengono a comportamento specificato o indefinito.

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

## Dentro il codice Go

La struct `CPU8086` separa registri generali, segmenti e flag:

```go
type CPU8086 struct {
    Regs [8]uint16
    Seg  [4]uint16
    IP   uint16
    CF, PF, AF, ZF, SF, TF, IF, DF, OF bool
    Mem Bus
    IO  Ports
    alu ALUBackend
}
```

I mezzi registri non sono campi separati. `AL`, `AH`, `BL`, `BH` condividono lo
stesso storage di `AX`, `BX` e cosi' via:

```go
func (c *CPU8086) Get8(r Reg8) byte {
    full := c.Regs[r&3]
    if r < 4 {
        return byte(full)
    }
    return byte(full >> 8)
}
```

`Set8` fa la scrittura inversa preservando l'altra meta'. Questo dettaglio e'
fondamentale: se scrivi `AL`, `AH` deve restare invariato.

L'indirizzo fisico e' una funzione pura:

```go
func PhysAddr(segment, offset uint16) uint32 {
    return (uint32(segment)<<4 + uint32(offset)) & AddressMask
}
```

Questa riga contiene tutto il real mode: shift del segmento, somma dell'offset,
wrap a 20 bit.

## Codice Go: reset, fetch e stack

`Reset` mette la CPU nello stato di accensione:

```go
c.Seg[CS] = 0xFFFF
c.IP = 0x0000
```

Il primo fetch quindi avviene a `FFFF:0000`, cioe' fisico `0xFFFF0`. Questo e'
il ponte diretto verso `retronet-pc`, che carica il BIOS proprio in alto.

`fetch8` legge da `CS:IP` e incrementa `IP`:

```go
b := c.readMem8(c.Seg[CS], c.IP)
c.IP++
return b
```

Le letture a 16 bit sono little-endian:

```go
lo := uint16(c.fetch8())
hi := uint16(c.fetch8())
return lo | hi<<8
```

Lo stack vive in `SS:SP` e cresce verso il basso:

```go
c.Regs[SP] -= 2
c.writeMem16(c.Seg[SS], c.Regs[SP], value)
```

La differenza rispetto all'8080 e' il segmento: non basta `SP`, serve `SS:SP`.

## Codice Go: prefissi e ModR/M

`Step` legge prefissi in un ciclo:

```go
for {
    op := c.fetch8()
    switch op {
    case 0x26:
        pfx.segOverride, pfx.hasSeg = ES, true
    case 0xF2, 0xF3:
        pfx.rep = op
    default:
        return c.execute(op, pfx)
    }
}
```

Quindi un prefisso non esegue un'azione completa: modifica il contesto
dell'istruzione successiva.

`decodeModRM` legge il byte ModR/M e, se l'operando e' memoria, calcola subito
segmento e offset effettivi:

```go
m.mod = b >> 6
m.reg = b >> 3 & 0x07
m.rm  = b & 0x07
```

`effectiveAddr` contiene la tabella di indirizzamento 8086:

```go
case 0:
    base = c.Regs[BX] + c.Regs[SI]
case 2:
    base = c.Regs[BP] + c.Regs[SI]
    defSeg = SS
case 6:
    if mod == 0 {
        base = c.fetch16()
    } else {
        base = c.Regs[BP]
        defSeg = SS
    }
```

Il segmento default e' `DS`, tranne quando entra `BP`, che implica `SS`. Il
prefisso segmento, se presente, sovrascrive questa scelta.

## Codice Go: execute senza perdersi

`execute.go` e' lungo, ma si legge per blocchi. Il primo blocco compatta molte
ALU:

```go
if op < 0x40 && op&0x07 < 6 {
    group := op >> 3
    ...
}
```

Poi arrivano sezioni commentate: MOV, XCHG, PUSH/POP, TEST, gruppi estesi,
flag, salti, interrupt, I/O, stringhe.

Gli helper mantengono il codice leggibile. Per esempio `aluRMReg` fa:

```text
decode ModR/M
leggi r/m
leggi registro
scegli direzione
chiama backend ALU
scrivi risultato se non CMP
```

Le string instructions usano una closure `one`, poi la ripetono con `REP`:

```text
one() esegue MOVS/STOS/LODS/SCAS/CMPS una volta
se non c'e' REP, termina
se c'e' REP, ripeti finche' CX != 0
```

Questo e' un buon compromesso: il codice resta vicino al manuale Intel, ma non
diventa una tabella opaca.

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

## Esempio guidato: dal reset al BIOS

Quando la macchina parte, la CPU non "cerca" il sistema operativo. Parte da un
indirizzo preciso:

```text
CS:IP = F000:FFF0
fisico = FFFF0
```

Quell'indirizzo cade dentro la ROM BIOS caricata nella parte alta del megabyte.
Il BIOS esegue POST, inizializza periferiche, cerca un dispositivo di boot e
alla fine carica il settore iniziale del floppy a `0000:7C00` oppure a una forma
segmentata equivalente.

In RetroNet questo percorso attraversa piu' moduli:

```text
retronet-8086: esegue istruzioni real mode
memory.Bus: restituisce byte BIOS da F0000-FFFFF
io.Ports: collega OUT/IN alle periferiche
device.FDC + DMA: trasferiscono il boot sector
TextVideo: rende visibile il testo scritto dal BIOS
```

Il risultato osservabile e' molto piu' grande del singolo core CPU: se il BIOS
arriva al boot da floppy, significa che bus, interrupt, video, timer, DMA e FDC
stanno cooperando.

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

## Esempio guidato: IRQ0 del timer

Il timer di sistema passa attraverso una catena precisa:

```text
PIT counter 0 scade
PIT chiama la linea IRQ0
PIC registra la richiesta
CPU ha IF=1 e chiede un interrupt
PIC consegna il vettore configurato
CPU impila FLAGS, CS, IP
CPU salta al gestore
gestore invia EOI al PIC
IRET ripristina FLAGS, CS, IP
```

Questo esempio e' utile per capire perche' un PC non e' solo "8088 piu' RAM".
Il timer non modifica direttamente il `PC`; parla col PIC, il PIC parla con la
CPU, e la CPU usa la tabella vettori in memoria bassa.

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

## Tastiera

La tastiera passa dal PPI e dagli interrupt, non e' una lettura diretta da
stdin. La CLI puo' accodare codici di scansione e il dispositivo li consegna con
un ritardo controllato, simulando il flusso verso il gestore `INT 9`.

La parte gia' coperta include caratteri base e Shift per maiuscole e simboli in
layout US. Restano fuori dal perimetro attuale Ctrl/Alt, tasti estesi e una
modellazione completa di ogni temporizzazione reale.

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

## Esempio guidato: boot sector minimo

Un boot sector prodotto da `retronet-asm` usa di solito:

```asm
.arch i8086
.orgbase 0x7C00
        ; codice reale-mode
.org 0x7DFE
.byte 0x55, 0xAA
```

La firma finale `55 AA` dice al BIOS che il settore e' avviabile. `.orgbase`
serve a risolvere le label come se il codice fosse caricato a `0x7C00`, ma senza
generare 0x7C00 byte di padding nel file. Il PC/XT legge quel settore dal floppy
attraverso FDC e DMA, poi il BIOS trasferisce il controllo al codice caricato.

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

## Dentro il codice Go

`Machine` e' letteralmente il cablaggio del PC:

```go
type Machine struct {
    CPU *cpu.CPU8086
    Mem *memory.Bus
    IO  *io.Ports

    Pic *device.PIC
    Pit *device.PIT
    Ppi *device.PPI
    Dma *device.DMA
    Fdc *device.FDC
    Video *device.TextVideo
}
```

`New()` crea una macchina nuda: CPU, memoria e I/O. `NewXT()` aggiunge
periferiche e collegamenti. La parte piu' importante non e' creare gli oggetti,
ma collegarli:

```go
m.Pit.IRQ0 = func() { m.Pic.RaiseIRQ(0) }
m.Fdc.DMA = m.Dma
m.Fdc.Mem = m.Mem
m.Fdc.IRQ6 = func() { m.Pic.RaiseIRQ(6) }
m.Ppi.IRQ1 = func() { m.Pic.RaiseIRQ(1) }
```

Queste callback sono i fili virtuali della macchina. Il PIT non conosce la CPU:
alza IRQ0 sul PIC. Il FDC non scrive direttamente registri CPU: usa DMA e poi
alza IRQ6.

Poi `NewXT` mappa le porte:

```go
m.IO.Map(0x20, 0x21, m.Pic)
m.IO.Map(0x40, 0x43, m.Pit)
m.IO.Map(0x60, 0x63, m.Ppi)
m.IO.Map(0x3F0, 0x3F7, m.Fdc)
```

Questa mappa e' il motivo per cui una istruzione 8086 `OUT 0x20, AL` raggiunge
il PIC senza che il core 8086 sappia cosa sia un PIC.

## Codice Go: bus memoria e ROM

`memory.Bus` e' un array da 1 MB con intervalli ROM:

```go
type Bus struct {
    data [Size]byte
    rom  []romRange
}
```

Le letture mascherano sempre a 20 bit:

```go
func (b *Bus) Read8(addr uint32) byte { return b.data[addr&mask] }
```

Le scritture in ROM sono ignorate:

```go
if b.isROM(addr) {
    return
}
```

`LoadBIOS` calcola la base in modo che l'ultimo byte della ROM cada a `0xFFFFF`:

```go
base := uint32(0x100000 - len(rom))
m.Mem.LoadROM(base, rom)
```

Quindi il reset vector `0xFFFF0` cade dentro il BIOS, come su PC/XT.

## Codice Go: dispatcher I/O

`io.Ports` e' volutamente semplice:

```go
type Ports struct {
    maps []mapping
}
```

Quando la CPU fa `IN`, il dispatcher cerca il device che copre la porta:

```go
for _, m := range p.maps {
    if port >= m.lo && port <= m.hi {
        return m.dev
    }
}
```

Se non trova nulla, legge `0xFF`, cioe' bus a riposo. Questa scelta rende
robusta la macchina mentre il BIOS prova porte non ancora modellate.

## Codice Go: FDC funzionale

Il controller floppy e' una piccola macchina a fasi:

```go
phase 0 = attesa comando
phase 1 = raccolta parametri
phase 2 = risultati disponibili
```

`writeData` raccoglie comando e parametri finche' `len(cmd) >= needed`, poi
chiama `execute`. `paramCount` conosce quanti byte seguono ogni comando NEC 765.

`readWrite` e' la parte piu' istruttiva: legge o scrive settori e usa il DMA
canale 2 per trasferire i dati. Il commento nel codice evita una trappola reale:
non bisogna usare `EOT` come unico limite del ciclo, perche' il BIOS puo'
leggere un settore alla volta con `EOT` fisso. Il trasferimento deve fermarsi
quando il DMA raggiunge il Terminal Count.

Questo e' un esempio perfetto di fedelta' funzionale: non simula ogni ciclo del
765, ma rispetta le condizioni che il BIOS si aspetta.

## Codice Go: passo macchina

`Machine.Step` e' il ciclo esterno:

```go
Pit.Tick(...)
Ppi.Tick(...)
se PIC ha interrupt e IF e' abilitato:
    CPU.Interrupt(...)
altrimenti:
    CPU.Step()
```

Il dettaglio interessante e' che `Run` non si ferma su `HLT`: un interrupt puo'
risvegliare la CPU. Questo e' diverso dai core CPU isolati e spiega perche'
serve una macchina attorno al processore.

## Limiti

Il PC non e' ancora un emulatore cycle-accurate. DMA e FDC sono funzionali.
Video grafico CGA non e' reso. Tastiera base e Shift sono presenti, mentre
Ctrl/Alt, tasti estesi, controller disco fisso e timing piu' fedele restano fuori
dal perimetro attuale. ROM esterne non sono incluse.

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

## Esempio guidato: risolvere una label in avanti

Prendi questo sorgente:

```asm
.arch i8080
        jmp fine
        mvi a, 1
fine:   hlt
```

Alla prima passata l'assembler non deve ancora produrre i byte definitivi.
Deve solo misurare:

```text
pc=0000  jmp fine   size=3
pc=0003  mvi a,1    size=2
pc=0005  fine:      label fine = 0005
pc=0005  hlt        size=1
```

Alla seconda passata, quando incontra `jmp fine`, il resolver sa che `fine`
vale `0005` e il backend i8080 puo' emettere l'opcode con indirizzo little
endian:

```text
C3 05 00 3E 01 76
```

Questo e' il cuore di un assembler a due passate: prima costruisce la mappa,
poi scrive i byte.

## Esempio guidato: `.org` e `.orgbase`

Le due direttive sembrano simili, ma rispondono a problemi diversi.

`.org` sposta anche la posizione nel file:

```asm
.org 0x0010
.byte 0xAA
```

Il file contiene padding fino a `0x0010`, poi `AA`.

`.orgbase` invece cambia solo il PC logico:

```asm
.orgbase 0x7C00
start:
        jmp start
```

Il file inizia subito con i byte del salto, ma la label `start` vale `0x7C00`.
Questo e' indispensabile per boot sector e `.COM`: il loader sa dove mettera' il
file, quindi l'assembler deve ragionare con quell'indirizzo senza riempire il
file di zeri inutili.

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

## Dentro il codice Go

Il contratto centrale e' `arch.Arch`:

```go
type Arch interface {
    Name() string
    Size(in Instruction) (int, error)
    Encode(in Instruction, pc int, resolve Resolver) ([]byte, error)
}
```

Questo e' il punto in cui l'assembler diventa multi-architettura. Lexer, parser
ed emitter non devono sapere come si codifica `JMS`, `LBI`, `CALL` o `MOV AX`.
Chiedono al backend:

```text
quanto e' lunga questa istruzione?
quali byte devo emettere a questo PC?
```

`arch.Instruction` conserva operandi grezzi come stringhe:

```go
type Instruction struct {
    Mnemonic string
    Operands []string
    Line int
}
```

Questo sposta la conoscenza dei registri nei backend. Per il parser, `[bp+si]`
e `R4` sono entrambi testo; per il backend i8086 o i4004 diventano vincoli
precisi.

## Codice Go: parser

`parser.Stmt` rappresenta una riga:

```go
type Stmt struct {
    Label string
    Instr *arch.Instruction
    Org *int
    OrgBase *int
    Data []byte
    Equ *EquDef
    Line int
}
```

Una riga puo' avere label piu' istruzione, label piu' `.byte`, solo `.org`, solo
`.equ`. Questa forma e' abbastanza ricca per i programmi RetroNet, ma ancora
semplice.

Il parser normalizza i mnemonici in maiuscolo:

```go
mnem := strings.ToUpper(toks[i].Text)
```

ma lascia le label case-sensitive. Questo evita sorprese nei simboli e rende
comodi i mnemonici scritti in minuscolo.

## Codice Go: include sicuri

`source.ExpandIncludes` espande `.include "file.asm"`, ma con due difese:

- niente path assoluti;
- niente file fuori dalla root del sorgente principale.

Il controllo usa `filepath.Rel`:

```go
rel, err := filepath.Rel(root, path)
return rel == "." || (rel != ".." && !strings.HasPrefix(rel, ".."+sep))
```

Questo e' importante perche' un assembler che include file arbitrari puo'
diventare accidentalmente un lettore di filesystem. RetroNet mantiene gli
include locali e prevedibili.

## Codice Go: emitter a due passate

`Assemble` fa esattamente quello che il capitolo descrive.

Passata 1:

```go
if st.Label != "" {
    syms.Define(st.Label, pc)
}
if st.Instr != nil {
    sz, _ := a.Size(*st.Instr)
    pc += sz
}
pc += len(st.Data)
```

Passata 2:

```go
b, err := a.Encode(*st.Instr, pc, syms.Lookup)
code = append(code, b...)
pc += len(b)
```

`.orgbase` modifica `base` e `pc`, ma non emette padding. `.org` invece emette
zeri fino alla posizione richiesta:

```go
for pc < *st.Org {
    code = append(code, 0x00)
    pc++
}
```

Questa differenza e' il cuore pratico di `.COM` e boot sector.

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

## Esempio guidato: `CALL 0005h` fino al terminale

Un programma che stampa una stringa passa da registri 8080 a servizio BDOS:

```asm
.arch i8080
.com
        mvi c, 9
        lxi d, msg
        call 5
        ret
msg:    .byte "RETRO$"
```

Il flusso dentro `retronet-cpm` e':

```text
PC=0100 esegue mvi/lxi
PC arriva a 0005h tramite CALL
Machine.Run riconosce BDOS
bdos.Handler legge C=9 e DE=msg
legge byte fino a $
scrive RETRO sul terminale
simula il ritorno al programma
```

La CPU non sa cosa sia `$`. E' il BDOS didattico che interpreta la convenzione
della funzione 9.

## Esempio guidato: leggere un file a record

Le funzioni file non lavorano con stream moderni. Usano FCB e record da 128
byte. Un programma prepara un FCB, imposta eventualmente il DMA con funzione 26,
poi chiama `read sequential`:

```text
FCB a 005Ch -> "TEST    TXT"
DMA = 0080h
C = 20
CALL 0005h
```

Il BDOS cerca `TEST.TXT` nel drive host confinato, legge il prossimo record e lo
copia nel DMA. Se il file finisce a meta' record, riempie il resto con `0x1A`,
come da convenzione testuale CP/M. Questa granularita' a record spiega perche'
il capitolo parla di FCB e DMA invece di "file handle" moderni.

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

## Dentro il codice Go

`retronet-cpm/cpm/machine.go` definisce gli indirizzi chiave come costanti:

```go
const (
    TransientBase   uint16 = 0x0100
    BDOSVector      uint16 = 0x0005
    BDOSTrapAddress uint16 = 0xF000
    DefaultStack    uint16 = 0xEFFE
)
```

`installPageZero` scrive una pagina zero didattica:

```go
mem[0000] = JMP 0000
mem[0005] = JMP F000
mem[F000] = RET
```

Il `RET` a `F000` e' una trappola documentale: il run loop intercetta `PC` prima
di lasciare davvero proseguire la CPU come se fosse un normale sottoprogramma.

`LoadCOM` resetta la macchina e copia i byte a `0100h`:

```go
for i, value := range data {
    m.Memory.Write(TransientBase+uint16(i), value)
}
m.CPU.PC = TransientBase
m.CPU.SP = DefaultStack
```

Il programma non ha header: e' solo un blocco di byte in memoria.

## Codice Go: il run loop CP/M-like

`Machine.Run` e' il cuore:

```go
for result.Steps < limit {
    if CPU ferma -> halted
    switch CPU.PC {
    case 0x0000:
        warm boot
    case BDOSVector, BDOSTrapAddress:
        callBDOS
    default:
        stepInstruction
    }
}
```

Questa e' la parte che trasforma un core 8080 in ambiente CP/M-like. L'8080 non
sa nulla del BDOS; il loop esterno vede il PC e decide che `0005h` e' una
chiamata di sistema.

`callBDOS` chiama `bdos.Handler.Call`, poi simula il ritorno:

```go
low := uint16(m.Memory.Read(m.CPU.SP))
high := uint16(m.Memory.Read(m.CPU.SP + 1))
m.CPU.SP += 2
m.CPU.PC = high<<8 | low
```

Questa e' la stessa convenzione dello stack 8080: il return address e' sullo
stack, byte basso prima.

## Codice Go: BDOS

`bdos.Handler.Call` legge la funzione da `C`:

```go
switch c.C {
case FunctionPrintString:
    return result, h.printDollarString(c, mem)
case FunctionReadSequential:
    return result, h.readSequential(c, mem)
case FunctionSetDMA:
    h.DMA = c.DE()
}
```

La funzione 9 legge da `DE` finche' trova `$`:

```go
start := c.DE()
for offset := 0; offset <= cpu.AddressSpaceSize; offset++ {
    value := mem.Read(start + uint16(offset))
    if value == '$' {
        return nil
    }
    h.Console.WriteByte(value)
}
```

Le funzioni file usano FCB e DMA. `readSequential` calcola:

```text
record = mem[FCB+32]
offset = record * 128
destinazione = DMA
```

poi copia 128 byte, riempiendo con `0x1A` quando il file termina. `writeSequential`
fa l'opposto e marca il file come `dirty`; la scrittura sul drive host avviene a
`closeFile`.

## Codice Go: drive host sicuro

`disk.HostDrive` normalizza sempre i nomi:

```go
NormalizeName("a:hello.com") -> "HELLO.COM"
```

Rifiuta path traversal, slash, colon inattesi e nomi oltre 8.3. Inoltre le
scritture passano da:

```go
if !d.writable {
    return ErrReadOnly
}
```

Questa e' la barriera fra mondo CP/M-like e filesystem host.

## Codice Go: sessione API-ready

`session.Session` e' volutamente piccola:

```go
func (s *Session) Input(data []byte) error {
    s.terminal.QueueInput(data)
}

func (s *Session) DrainOutput() ([]byte, error) {
    return s.terminal.DrainOutput(), nil
}
```

La sessione non conosce HTTP. Espone operazioni che l'API puo' chiamare, ma che
restano usabili anche da test o CLI locali.

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

## Esempio guidato: raw output e snapshot

Immagina che un programma scriva:

```text
CIAO\r\nA>
```

Il terminale conserva due viste:

```text
raw output: 43 49 41 4F 0D 0A 41 3E
schermo:
CIAO
A>
```

Quando un adapter chiama `DrainOutput`, riceve i byte nuovi e il buffer raw si
svuota. Quando chiama `Snapshot`, riceve lo stato dello schermo, compreso il
cursore. Le due chiamate non sono equivalenti:

- il drain serve per streaming e scrollback;
- lo snapshot serve per ricostruire lo stato visibile corrente.

Questa distinzione evita che un client WebSocket debba ricostruire lo schermo
solo dai delta, cosa fragile se perde messaggi o si riconnette.

## ANSI minimale

Il terminale supporta un subset:

- pulizia schermo/riga;
- posizionamento cursore;
- movimento relativo;
- attributi `m` ignorati ma preservati nel raw.

Sequenze sconosciute o incomplete non devono causare panic. Questo e' importante
per robustezza: un programma puo' emettere escape non supportati, ma il terminale
non deve crollare.

## Esempio guidato: clear screen ANSI

Se ANSI e' abilitato, questi byte:

```text
ESC [ 2 J ESC [ H R E A D Y
```

significano:

```text
1. pulisci schermo
2. porta il cursore in home
3. scrivi READY
```

Il raw output conserva comunque la sequenza originale. Lo schermo invece mostra
solo l'effetto finale. Questa scelta e' molto utile per debug: puoi verificare
che il programma abbia emesso l'escape corretto e, separatamente, che il
renderer lo abbia interpretato.

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

## Dentro il codice Go

`Terminal` tiene tre stati separati:

```go
type Terminal struct {
    input  []byte
    output bytes.Buffer
    screen [][]byte
    row, col int
    esc []byte
}
```

`input` e' la tastiera futura, `output` e' il raw stream prodotto dai programmi,
`screen` e' la vista interpretata. Il mutex protegge tutte le operazioni perche'
sessioni API e runner possono leggere e scrivere da goroutine diverse.

`WriteByte` e `Write` chiamano `writeByteLocked`. La prima riga e' sempre:

```go
t.output.WriteByte(value)
```

Quindi il raw output conserva anche byte di controllo e sequenze ANSI. Solo dopo
il terminale decide come aggiornare lo schermo.

## Codice Go: display e ANSI

`writeDisplay` gestisce i controlli base:

```go
case '\r':
    t.col = 0
case '\n':
    t.newLine()
case '\b':
    if t.col > 0 { t.col-- }
case '\t':
    avanza al prossimo tab stop
```

I caratteri stampabili finiscono in `screen[row][col]`; se il cursore supera la
larghezza, va a capo.

Il parser ANSI e' minimale. Quando arriva `ESC`, il terminale accumula byte in
`esc` finche' `escapeComplete` riconosce una sequenza CSI completa. Poi
`handleEscape` gestisce finali come `J`, `K`, `H`, `A`, `B`, `C`, `D`, `m`.

Gli attributi `m` sono ignorati nello schermo, ma restano nel raw output. Questo
mantiene fedelta' del flusso senza costringere il terminale didattico a
implementare colori e stili completi.

## Codice Go: snapshot e runner live

`Snapshot` copia le righe in stringhe e include cursore, input pendente e byte
raw non drenati:

```go
Rows
CursorRow
CursorCol
PendingInput
OutputBytes
```

Il runner `live.Run` mostra come usare questo contratto localmente:

```text
Handler.Start(term)
RenderSnapshot(...)
leggi un byte dall'input host
Handler.HandleByte(term, byte)
WriteDelta(...)
```

Il runner non sa cosa sia CP/M. Sa solo che un handler applicativo riceve byte e
scrive sul terminale. Questo e' esattamente lo stesso confine che poi l'API
riusa da remoto.

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

## Esempio guidato: ciclo REST di una sessione

Un client minimale puo' usare solo REST:

```text
POST /sessions
  -> crea sessione, drive temporaneo, prompt A>

POST /sessions/{id}/command {"command":"DIR"}
  -> esegue comando shell sincrono

GET /sessions/{id}/output
  -> drena output raw prodotto dal terminale

GET /sessions/{id}
  -> legge stato idle/running/error/closed

DELETE /sessions/{id}
  -> chiude sessione e pulisce drive temporaneo
```

Questo flusso e' adatto ad automazioni brevi. Per un terminale interattivo e'
meglio WebSocket, perche' input, output, stato e snapshot devono viaggiare in
modo continuo.

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

## Esempio guidato: dialogo WebSocket

Una sequenza tipica e':

```json
{"type":"command","command":"DIR"}
```

Il server puo' rispondere con piu' messaggi:

```json
{"type":"accepted"}
{"type":"state","state":"running"}
{"type":"output","data":"A>DIR\r\nHELLO   COM\r\n"}
{"type":"snapshot","rows":["A>DIR ..."],"cursorRow":0,"cursorCol":6}
{"type":"state","state":"idle"}
```

Se poi l'utente digita mentre un programma e' in esecuzione:

```json
{"type":"input","data":"Y"}
```

quel byte viene accodato al terminale della sessione. Se invece la sessione e'
idle, lo stesso input passa dal line editor minimale della shell. Questa doppia
semantica e' il motivo per cui lo stato `idle/running` e' parte del contratto
pubblico.

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

## Dentro il codice Go

`Manager` e' il proprietario delle sessioni:

```go
type Manager struct {
    mu sync.Mutex
    sessions map[string]*ManagedSession
}
```

`Create` fa quattro cose:

```text
1. pulisce sessioni scadute
2. genera ID casuale
3. crea drive temporaneo scrivibile con limiti
4. crea sessione CP/M e stampa prompt A>
```

Il drive nasce con:

```go
disk.NewTemporaryHostDrive("retronet-api-cpm-", HostDriveOptions{...})
```

Questo e' il motivo per cui l'API non deve accettare path host dal client.

## Codice Go: stato sessione e run asincrono

`ManagedSession` ha un mutex proprio e uno stato:

```go
SessionIdle
SessionRunning
SessionClosed
SessionError
```

`beginCommand` impedisce due run sovrapposti:

```go
if s.State == SessionRunning {
    return ErrSessionBusy
}
s.State = SessionRunning
```

`startCommandWithInput` lancia il comando in goroutine:

```go
go s.executeCommand(command)
```

Poi l'API usa polling WebSocket per drenare output e notificare cambi stato.
Questo rende possibile programmi interattivi: il server non blocca la connessione
HTTP aspettando la fine del programma.

## Codice Go: idle input vs running input

`handleInput` e' il confine piu' delicato:

```go
if state == SessionRunning {
    s.cpm.Input([]byte(data))
    return messagesFromResult(s.drain())
}
```

Se il programma e' in esecuzione, i byte entrano nella coda input del terminale.

Se la sessione e' idle, gli stessi byte alimentano un line editor:

```text
Enter -> avvia comando
Backspace -> aggiorna buffer e terminale
Ctrl+L -> clear screen e prompt
Ctrl+C/D/Q -> chiudi sessione
caratteri stampabili -> echo e append alla linea
```

Questa doppia semantica spiega perche' il client deve conoscere lo stato: `A`
puo' essere input per un programma, oppure testo della shell.

## Codice Go: HTTP e WebSocket

`server.go` usa route esplicite del `ServeMux`:

```go
s.mux.HandleFunc("POST /sessions", s.handleCreateSession)
s.mux.HandleFunc("POST /sessions/{id}/files", s.handleUploadFile)
s.mux.HandleFunc("GET /sessions/{id}/ws", s.handleWebSocket)
```

L'upload limita la dimensione con `http.MaxBytesReader` e poi con
`io.LimitReader`. Anche se il browser fa un controllo lato client, il server
rifa tutto.

Il WebSocket manda un messaggio iniziale (`output`, `state`, `snapshot`) e poi
avvia `pollWebSocket` ogni 50 ms. Il polling drena output, confronta stato e
invia snapshot solo quando serve. E' un protocollo semplice, ma robusto per la
prima UI.

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

## Esempio guidato: aprire una sessione dal browser

Un uso tipico della UI segue questa sequenza:

```text
1. il browser carica index.html, CSS e app.js dal server UI
2. app.js legge /config.json per trovare l'API
3. la UI chiama GET /health e GET /version sull'API
4. l'utente crea una sessione
5. la UI apre /sessions/{id}/ws
6. il terminale mostra il prompt A>
7. i tasti diventano messaggi input
8. output e snapshot aggiornano scrollback e schermo
```

La UI non ha bisogno di sapere che sotto c'e' un 8080. Il suo contratto e'
terminalistico: invia input, riceve output, mostra stato e file.

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

## Esempio guidato: upload ed esecuzione di `HELLO.COM`

Dal punto di vista dell'utente:

```text
crea sessione
upload HELLO.COM
file compare nel drive A:
digita RUN HELLO
legge l'output nel terminale
```

Dal punto di vista dei moduli:

```text
UI controlla estensione .COM
API normalizza nome 8.3 e salva nel drive temporaneo
sessione CP/M carica HELLO.COM a 0100h
programma chiama BDOS
terminale produce output e snapshot
UI aggiorna schermo e scrollback
```

Questo e' un esempio molto piccolo, ma attraversa quasi tutto lo stack software
alto di RetroNet senza violare i confini: il browser non vede path host, l'API
non interpreta opcode, CP/M non conosce DOM o CSS.

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

## Dentro il codice Go e JavaScript

Il server Go della UI e' intenzionalmente piccolo. `site.Handler` serve tre cose:

```text
/health       -> JSON locale
/config.json  -> configurazione API
tutto il resto -> asset statici embedded
```

Gli asset sono incorporati con:

```go
//go:embed static/*
var embedded embed.FS
```

`Check` legge `index.html`, `styles.css` e `app.js` e verifica marker come
`retronet-app`, `session-list`, `file-list`, `scrollback`. Non e' un test
visuale, ma intercetta rotture grossolane dell'asset bundle.

## Codice JavaScript: stato e bootstrap

`app.js` mantiene uno stato client minimale:

```js
const state = {
  ws: null,
  sessionID: "",
  outputBytes: 0,
  rawText: "",
  scrollback: "",
  connected: false
};
```

`init` collega eventi, legge `/config.json`, controlla l'API e aggiorna la
dashboard. Questa sequenza e' importante: la UI non ha configurazione compilata
nel JS, la riceve dal server Go.

`apiFetch` normalizza l'URL API e incapsula JSON/fetch:

```js
const base = ui.apiURL.value.trim().replace(/\/+$/, "");
return fetch(`${base}${path}`, ...);
```

Per upload usa `FormData`, quindi non imposta manualmente `Content-Type`: il
browser deve poter aggiungere il boundary multipart.

## Codice JavaScript: WebSocket e tastiera

`websocketURL` converte `http` in `ws` e `https` in `wss`:

```js
base.protocol = base.protocol === "https:" ? "wss:" : "ws:";
base.pathname = ".../sessions/{id}/ws";
```

`handleTerminalKey` traduce eventi browser in byte:

```text
Enter      -> \r
Backspace  -> 0x7F
Ctrl+C     -> 0x03
frecce     -> ESC [ A/B/C/D
caratteri  -> carattere stesso
```

Poi `sendInput` invia:

```js
state.ws.send(JSON.stringify({ type: "input", data }));
```

Il browser non esegue comandi CP/M. Simula una tastiera remota.

## Codice JavaScript: snapshot e scrollback

`handleSocketMessage` tratta tre famiglie:

```text
output   -> appendRaw
snapshot -> renderSnapshot
state    -> badge stato sessione
```

`appendRaw` mantiene uno scrollback separato e taglia la dimensione massima per
evitare crescita infinita:

```js
if (state.scrollback.length > 24000) {
  state.scrollback = state.scrollback.slice(-24000);
}
```

`renderSnapshot` invece ricostruisce lo schermo riga per riga e inserisce uno
`span` nel punto del cursore. Questa separazione replica il modello del
terminale Go:

```text
output raw = storia
snapshot = stato visibile
```

Il doppio rendering e' il motivo per cui la UI resta utilizzabile anche se un
programma usa clear screen: lo snapshot mostra lo schermo corrente, lo scrollback
conserva cio' che e' passato.

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
