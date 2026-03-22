param($jobName, $originalContent)

$basePath = "C:\WorkEngine\deliverables"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$folder = "$basePath\DELIVERABLE_$timestamp"

New-Item -ItemType Directory -Force -Path $folder | Out-Null
New-Item -ItemType Directory -Force -Path "$folder\Output" | Out-Null

# === Explanation ===
@"
This system processed a task and determined the appropriate actions
based on priority, intent, and system state.

The goal is to reduce manual work, improve response time,
and handle tasks automatically.
"@ | Set-Content "$folder\Explanation.txt"

# === What Was Done ===
@"
- Task analyzed
- Priority determined
- Appropriate actions executed
- Outputs generated automatically
"@ | Set-Content "$folder\What_Was_Done.txt"

# === How To Use ===
@"
1. Drop job into:
C:\WorkEngine\jobs\active\

2. System will process automatically

3. Results appear in:
C:\WorkEngine\output\

4. Deliverables generated in:
C:\WorkEngine\deliverables\
"@ | Set-Content "$folder\How_To_Use.txt"

# === Copy Output Files ===
Get-ChildItem "C:\WorkEngine\output\" | 
    Copy-Item -Destination "$folder\Output" -Force

Write-Host "DELIVERABLE CREATED: $folder" -ForegroundColor Green
