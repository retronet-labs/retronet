# Demo — calcolatrice da tavolo in assembly Intel 4004

Questa demo mostra l'intera catena di RetroNet che funziona end-to-end:

1. un **firmware** scritto in assembly (`retronet-asm/examples/calcolatrice-completa.asm`),
2. assemblato in una ROM con **`retronet-asm`**,
3. eseguito **interattivo** sull'emulatore **`retronet-4004`** (`-io`: tastiera → stdin, display → stdout).

La calcolatrice lavora in **BCD a virgola fissa (2 decimali)**, gestisce i quattro
operatori `+ − × ÷`, i numeri decimali e il segno negativo. In uscita il nibble `15`
è mostrato come `.` e il nibble `11` come `-`.

## Pipeline

```console
$ retronet-asm build examples/calcolatrice-completa.asm -o calc.rom
assemblato examples/calcolatrice-completa.asm (i4004) -> calc.rom (530 byte)

$ echo "1.5+2.25=" | retronet-4004 -io calc.rom
=== retronet-4004 — ROM: calc.rom (530 byte) ===
3.75
HALT a PC=0x0A4 dopo 1171 step
```

La riga `3.75` è il display della calcolatrice; la riga `HALT` è l'emulatore che
riconosce l'arresto (un `JUN` su se stesso) e stampa lo stato finale.

## Sessioni (input → display)

Ogni riga è `echo "<tasti>" | retronet-4004 -io calc.rom`:

```text
   1.5+2.25=   ->  3.75       somma con decimali
   10-2.5=     ->  7.50       sottrazione con decimali
   3-5=        ->  -2.00      risultato negativo
   100-0.5=    ->  99.50
   6*7=        ->  42.00      moltiplicazione (addizioni ripetute)
   2.5*2.5=    ->  6.25       prodotto in virgola fissa
   7/2=        ->  3.50       divisione (sottrazioni ripetute)
   1/8=        ->  0.12
   0.1+0.2=    ->  0.30       esatto: niente errori di virgola mobile (è BCD)
   9/0=        ->  0.00       divisione per zero gestita
```

## Come funziona, in breve

- Ogni operando digitato viene memorizzato come **intero scalato ×100**
  (`1.5` → `150`, `12` → `1200`). Il punto decimale è il tasto `.`.
- `+` e `−` sono somme/sottrazioni dirette (i valori sono già scalati allo stesso modo);
  la sottrazione rileva `A < B` e mostra il segno.
- `×` esegue il prodotto e poi divide per 100 (il prodotto di due valori ×100 è ×10000).
- `÷` moltiplica il dividendo per 100 e poi fa la divisione intera.
- Il risultato (in RAM, scalato ×100) è mostrato inserendo la virgola due cifre da destra.

## Riprodurre la demo

```bash
# build dei due strumenti (Go 1.26)
go build -o retronet-asm   ./cmd/retronet-asm      # nel repo retronet-asm
go build -o retronet-4004  ./cmd/retronet-4004     # nel repo retronet-4004

# assembla ed esegui
retronet-asm build examples/calcolatrice-completa.asm -o calc.rom
echo "2.5*2.5=" | retronet-4004 -io calc.rom        # -> 6.25
```

> Moduli usati: **retronet-4004** e **retronet-asm**, entrambi alla release **v0.2.0**.
