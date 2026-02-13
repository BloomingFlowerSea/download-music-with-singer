$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $PSCommandPath
$artistFile = Join-Path $scriptDir "..\haha.txt"
$outDir = Join-Path $scriptDir "..\temp"

if (!(Test-Path $artistFile)) {
    Write-Error "Artist list not found: $artistFile"
    exit 1
}

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$artists = Get-Content -Encoding UTF8 $artistFile |
    ForEach-Object { $_.Trim().Trim('"') } |
    Where-Object { $_ -and -not $_.StartsWith("#") }

if (-not $artists) {
    Write-Error "No artist names found in $artistFile"
    exit 1
}

foreach ($artist in $artists) {
    Write-Host "=== $artist ==="
    $inputText = "0-100`nN`n"
    $inputText | python music-dl -k $artist -n 100 -o $outDir
}
