# Migrazione globale dell'ecosistema RetroNet su una macchina nuova (Windows).
#
# Clona (o aggiorna) tutti i repository come cartelle sibling e ricrea i file
# go.work di sviluppo locale (non versionati: puntano a percorsi della macchina).
# Idempotente. Non scarica gli asset esterni (BIOS, dataset): vedi la fine.
$ErrorActionPreference = 'Stop'

$org  = 'https://github.com/retronet-labs'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

# Repo GitHub -> cartella locale (il 4004 sta storicamente in "go-4004").
$repos = [ordered]@{
  'retronet-logic'    = 'retronet-logic'
  'retronet-hardware' = 'retronet-hardware'
  'retronet-4004'     = 'go-4004'
  'retronet-8008'     = 'retronet-8008'
  'retronet-8080'     = 'retronet-8080'
  'retronet-8086'     = 'retronet-8086'
  'retronet-pc'       = 'retronet-pc'
  'retronet-asm'      = 'retronet-asm'
  'retronet-cpm'      = 'retronet-cpm'
  'retronet-terminal' = 'retronet-terminal'
  'retronet-api'      = 'retronet-api'
  'retronet-ui'       = 'retronet-ui'
  'retronet'          = 'retronet'
}

Write-Host "Radice di lavoro: $root`n"
Write-Host '== Clono / aggiorno i repository =='
foreach ($name in $repos.Keys) {
  $dir = $repos[$name]; $target = Join-Path $root $dir
  if (Test-Path (Join-Path $target '.git')) {
    Write-Host "  [pull]  $dir"
    git -C $target fetch --quiet --tags origin
    git -C $target pull --quiet --ff-only
  } else {
    Write-Host "  [clone] $name -> $dir"
    git clone --quiet "$org/$name.git" $target
  }
}

# Mappa: percorso del modulo Go -> cartella locale.
Write-Host "`n== Rigenero i go.work di sviluppo locale =="
$mod2dir = @{}
foreach ($dir in $repos.Values) {
  $gomod = Join-Path $root "$dir\go.mod"
  if (-not (Test-Path $gomod)) { continue }
  $line = (Get-Content $gomod -TotalCount 1)
  if ($line -match '^module\s+(\S+)') { $mod2dir[$matches[1]] = (Join-Path $root $dir) }
}

foreach ($dir in $repos.Values) {
  $repo = Join-Path $root $dir
  $gomod = Join-Path $repo 'go.mod'
  if (-not (Test-Path $gomod)) { continue }
  $mods = Select-String -Path $gomod -Pattern 'github\.com/retronet-labs/[a-z0-9-]+' -AllMatches |
          ForEach-Object { $_.Matches.Value } | Sort-Object -Unique
  $uses = @()
  foreach ($m in $mods) {
    if ($mod2dir.ContainsKey($m) -and $mod2dir[$m] -ne $repo) { $uses += $mod2dir[$m] }
  }
  if ($uses.Count -gt 0) {
    $names = ($uses | ForEach-Object { Split-Path $_ -Leaf }) -join ' '
    Write-Host "  [go.work] $dir -> $names"
    Remove-Item (Join-Path $repo 'go.work'),(Join-Path $repo 'go.work.sum') -ErrorAction SilentlyContinue
    Push-Location $repo
    try { & go work init . @uses } finally { Pop-Location }
  }
}

Write-Host "`n== Asset esterni (NON in git) da procurarsi a mano =="
Write-Host '  - BIOS GLaBIOS (XT, GPLv3) per retronet-pc:'
Write-Host '      https://github.com/640-KB/GLaBIOS   (testato: release 0.4.2 8X)'
Write-Host '      uso:  go run ./cmd/retronet-pc -bios <ROM> -floppy <img>'
Write-Host '  - SingleStepTests (TomHarte) per retronet-8086:'
Write-Host '      https://github.com/SingleStepTests/8088   (file v2/*.json.gz)'
Write-Host '      uso:  go run ./cmd/retronet-8086 -testsuite <dir>'
Write-Host "`nFatto."
