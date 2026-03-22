$root = "C:\WorkEngine"
$inbox = Join-Path $root "inbox"
$active = Join-Path $root "active"
$completed = Join-Path $root "completed"

function Write-Section($file, $section, $body) {
    Add-Content $file "SECTION: $section"
    Add-Content $file $body
    Add-Content $file "`n---`n"
}

function Pause-ForApproval($msg) {
    Write-Host ""
    Write-Host "APPROVAL REQUIRED:" -ForegroundColor Yellow
    Write-Host $msg
    $r = Read-Host "Type YES to continue"
    if ($r -ne "YES") { throw "STOPPED" }
}

$jobFile = Get-ChildItem $inbox -Filter *.txt | Select-Object -First 1
if (-not $jobFile) { Write-Host "No jobs found"; exit }

$content = Get-Content $jobFile.FullName -Raw

$jobDir = Join-Path $active ("job_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Path $jobDir | Out-Null

$artifact = Join-Path $jobDir "artifact.txt"
Set-Content $artifact "JOB START`n`n"

# INPUT
$body = @"
PURPOSE:
To formally introduce and validate the opportunity for structured processing.

CONTEXT:
The job originates from a defined input describing a need for automation with explicit constraints.

ANALYSIS:
The task represents a low-complexity, high-efficiency opportunity where automation can immediately reduce manual effort.
The emphasis on simplicity and reliability indicates that stability is more valuable than feature complexity.
This implies that overengineering would increase failure risk without improving outcome value.

DECISION:
The opportunity is accepted as valid and actionable due to its clear objective and manageable constraints.

EXECUTION:
The job is transitioned into deeper contextual analysis.

EVALUATION:
The input is sufficiently defined to proceed without requiring clarification.

ADJUSTMENT:
Future inputs should include concrete examples of current workflows to improve precision.

CONTEXT:
$content

ANALYSIS:
Input appears valid and actionable.

DECISION:
Proceed.

EXECUTION:
Move forward.

EVALUATION:
Clear input.

ADJUSTMENT:
Refine if needed.
"@
Write-Section $artifact "INPUT" $body
Pause-ForApproval "Check INPUT"

# CONTEXT
$body = @"
PURPOSE:
To extract and define all relevant constraints, dependencies, and environmental conditions.

CONTEXT:
The task requires automation within a constrained environment prioritizing simplicity and reliability.

ANALYSIS:
The absence of complex requirements indicates that the optimal solution must minimize system overhead.
The primary risk lies in introducing unnecessary complexity that reduces usability and increases failure points.
This implies that a minimal architecture will produce the highest success probability.

DECISION:
Proceed with a simplified structural model that prioritizes reliability over extensibility.

EXECUTION:
Decompose the task into essential functional components only.

EVALUATION:
All relevant variables are identified and accounted for.

ADJUSTMENT:
Future context extraction should explicitly identify hidden constraints earlier.

CONTEXT:
Extract details from input.

ANALYSIS:
Focus on simplicity.

DECISION:
Proceed.

EXECUTION:
Break into steps.

EVALUATION:
Usable context.

ADJUSTMENT:
Improve clarity.
"@
Write-Section $artifact "CONTEXT" $body
Pause-ForApproval "Check CONTEXT"

# INTENT
$body = @"
PURPOSE:
To define a measurable and outcome-driven definition of success.

CONTEXT:
The task is focused on implementing automation that reduces repetitive manual work.

ANALYSIS:
The client’s emphasis on efficiency implies that success must be measured in time saved and reduction of manual intervention.
A solution that is technically correct but difficult to operate would fail the underlying objective.

DECISION:
Success is defined as a stable, easy-to-use automation system that consistently performs the required task without manual input.

EXECUTION:
Translate this outcome into a clear operational target.

EVALUATION:
The success condition is explicitly defined and testable.

ADJUSTMENT:
Future intent definitions should include quantifiable performance metrics where possible.

CONTEXT:
Automation task.

ANALYSIS:
Client wants efficiency.

DECISION:
Working simple automation.

EXECUTION:
Define outcome.

EVALUATION:
Clear goal.

ADJUSTMENT:
Refine later.
"@
Write-Section $artifact "INTENT" $body
Pause-ForApproval "Check INTENT"

# COMPLETE
Move-Item $jobFile.FullName (Join-Path $completed $jobFile.Name)

Write-Host "JOB COMPLETE"
Write-Host "Artifact:" $artifact


