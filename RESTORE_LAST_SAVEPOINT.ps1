$src = 'C:\WorkEngine\SAVEPOINT_UNKNOWN_CAPTURE_20260322_112759'

Copy-Item "$src\gogo_loop_executor.ps1" "C:\WorkEngine\gogo_loop_executor.ps1" -Force
Copy-Item "$src\auto_runner.ps1" "C:\WorkEngine\auto_runner.ps1" -Force
Copy-Item "$src\generate_batch.ps1" "C:\WorkEngine\generate_batch.ps1" -Force
Copy-Item "$src\unknown_watcher.ps1" "C:\WorkEngine\unknown_watcher.ps1" -Force

Remove-Item "C:\WorkEngine\memory" -Recurse -Force
Copy-Item "$src\memory" "C:\WorkEngine\memory" -Recurse

Write-Host "[RESTORED] System rolled back to saved state"
