Write-Host "[WATCHER] Started. Monitoring unknown intents..."

$path = "C:\WorkEngine\memory\unknown_intents.json"

$reported = @{}

while ($true) {

    if (Test-Path $path) {

        $json = Get-Content $path | ConvertFrom-Json

        foreach ($intent in $json.PSObject.Properties.Name) {

            $count = $json.$intent

            if ($count -ge 3) {

                if (-not $reported.ContainsKey($intent)) {

                    Write-Host "[WATCHER] Candidate intents detected:"
                    Write-Host " - $intent ($count)"

                    $reported[$intent] = $true
                }
            }
        }
    }

    Start-Sleep -Seconds 2
}
