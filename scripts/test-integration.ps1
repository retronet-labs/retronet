# Verifica i contratti pubblici tra assembler ed emulatori usando checkout
# sibling. E' l'equivalente Windows di test-integration.sh.
[CmdletBinding()]
param(
    [string]$AsmDir,
    [string]$Cpu4004Dir,
    [string]$Cpu8008Dir
)

$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))

if (-not $AsmDir) { $AsmDir = Join-Path $workspace 'retronet-asm' }
if (-not $Cpu4004Dir) { $Cpu4004Dir = Join-Path $workspace 'go-4004' }
if (-not $Cpu8008Dir) { $Cpu8008Dir = Join-Path $workspace 'retronet-8008' }

$public4004Dir = Join-Path $workspace 'retronet-4004'
if (-not (Test-Path -LiteralPath $Cpu4004Dir) -and (Test-Path -LiteralPath $public4004Dir)) {
    $Cpu4004Dir = $public4004Dir
}

foreach ($dir in @($AsmDir, $Cpu4004Dir, $Cpu8008Dir)) {
    if (-not (Test-Path -LiteralPath (Join-Path $dir 'go.mod'))) {
        throw "repository richiesto non trovato: $dir"
    }
}

$tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$temp = Join-Path $tempRoot ("retronet-integration-" + [guid]::NewGuid().ToString('N'))
[IO.Directory]::CreateDirectory($temp) | Out-Null

function Build-Command([string]$ProjectDir, [string]$Package, [string]$Output) {
    Push-Location $ProjectDir
    try {
        & go build -o $Output $Package
        if ($LASTEXITCODE -ne 0) { throw "go build fallito in $ProjectDir" }
    }
    finally {
        Pop-Location
    }
}

try {
    $asmBin = Join-Path $temp 'retronet-asm.exe'
    $cpu4004Bin = Join-Path $temp 'retronet-4004.exe'
    $cpu8008Bin = Join-Path $temp 'retronet-8008.exe'
    Build-Command $AsmDir './cmd/retronet-asm' $asmBin
    Build-Command $Cpu4004Dir './cmd/retronet-4004' $cpu4004Bin
    Build-Command $Cpu8008Dir './cmd/retronet-8008' $cpu8008Bin

    $rom4004 = Join-Path $temp 'calcolatrice-4004.rom'
    & $asmBin build (Join-Path $AsmDir 'examples\calcolatrice-completa.asm') -o $rom4004
    if ($LASTEXITCODE -ne 0) { throw 'assemblaggio demo 4004 fallito' }
    $out4004 = '1.5+2.25=' | & $cpu4004Bin -io $rom4004 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $out4004 -notlike '*3.75*') {
        throw "integrazione 4004 fallita: output inatteso`n$out4004"
    }

    $rom8008 = Join-Path $temp 'calcolatrice-8008.rom'
    & $asmBin build (Join-Path $AsmDir 'examples\i8008-calc.asm') -o $rom8008
    if ($LASTEXITCODE -ne 0) { throw 'assemblaggio demo 8008 fallito' }
    $out8008 = & $cpu8008Bin -bin $rom8008 -terminal-input '6*7=' -steps 100000 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $out8008 -notlike '*42profile=generic*') {
        throw "integrazione 8008 fallita: output inatteso`n$out8008"
    }

    Write-Output 'integrazione RetroNet completata: 4004=3.75, 8008=42'
}
finally {
    $resolvedTemp = [IO.Path]::GetFullPath($temp)
    if ($resolvedTemp.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase) -and
        (Split-Path -Leaf $resolvedTemp).StartsWith('retronet-integration-')) {
        [IO.Directory]::Delete($resolvedTemp, $true)
    }
}
