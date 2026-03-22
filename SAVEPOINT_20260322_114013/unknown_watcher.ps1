# ================================
# UNKNOWN WATCHER (EXTERNAL)
# ================================

$unknownPath   = "C:\WorkEngine\memory\unknown_intents.json"
$candidatePath = "C:\WorkEngine\memory\unknown_candidates.json"
$threshold     = 3

Write-Host "[WATCHER] Started. Monitoring unknown intents..."

while ($true) {

    if (Test-Path $unknownPath) {

        try {
            $raw = Get-Content $unknownPath -Raw | ConvertFrom-Json
        } catch {
            Start-Sleep -Seconds 2
            continue
        }

        $data = @{}
        if ($raw) {
            $raw.PSObject.Properties | ForEach-Object {
                $data[$_.Name] = $_.Value
            }
        }

        $candidates = @{}

        foreach ($k in $data.Keys) {
            if ($data[$k] -ge $threshold) {
                $candidates[$k] = $data[$k]
            }
        }

        if ($candidates.Count -gt 0) {
            $candidates | ConvertTo-Json | Set-Content $candidatePath -Encoding UTF8
            Write-Host "[WATCHER] Candidate intents detected:"
            $candidates.GetEnumerator() | ForEach-Object {
                Write-Host " - $($_.Key) ($($_.Value))"
            }
        }
    }

    Start-Sleep -Seconds 2
}
