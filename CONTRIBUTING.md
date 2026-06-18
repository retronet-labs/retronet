# Contribuire a RetroNet

Grazie per l'interesse in RetroNet. Il progetto e pensato per essere educativo, leggibile e modulare.

## Principi

- Preferire moduli piccoli, testabili e ben documentati.
- Spiegare le scelte tecniche, soprattutto quando toccano architetture storiche.
- Mantenere esempi eseguibili e semplici da verificare.
- Evitare dipendenze non necessarie.
- Scrivere README utili prima di aggiungere feature molto grandi.

## Workflow

1. Apri una issue o commenta una issue esistente.
2. Crea un branch descrittivo:

```bash
git checkout -b feature/nome-breve
```

3. Aggiungi test o esempi quando il cambiamento modifica comportamento.
4. Aggiorna la documentazione se cambia l'uso pubblico.
5. Apri una pull request con contesto, motivazione e istruzioni di verifica.

## Convenzione commit

Esempi:

```text
feat(cpu): implement RDM instruction
test(cpu): add RAM instruction tests
docs(readme): add RetroNet roadmap section
refactor(cli): move main into cmd directory
feat(ui): add xterm terminal component
feat(api): add websocket terminal sessions
chore(docker): add Dockerfile
```

## Label consigliate

- `good first issue`
- `help wanted`
- `documentation`
- `cpu`
- `assembler`
- `terminal`
- `networking`
- `bbs`
- `browser`
- `dns`
- `docker`
- `testing`
- `refactor`
- `bug`
- `enhancement`

## Licenza

Contribuendo, accetti che il tuo contributo sia distribuito con la licenza MIT del progetto.
