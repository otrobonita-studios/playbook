[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)] [string]$TargetDir,
    [ValidateSet('generic', 'web', 'node')] [string]$Stack = 'generic',
    [ValidateSet('evals', 'verification', 'infrastructure', 'nemoclaw', 'mcp')] [string[]]$Include = @(),
    [switch]$Force,
    [switch]$AllowNonGit
)

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not (Test-Path -LiteralPath $TargetDir -PathType Container)) { throw "Target directory does not exist: $TargetDir" }
$TargetDir = (Resolve-Path -LiteralPath $TargetDir).Path
if (-not $AllowNonGit -and -not (Test-Path -LiteralPath (Join-Path $TargetDir '.git') -PathType Container)) {
    throw 'Target is not a Git repository. Initialize Git first or pass -AllowNonGit.'
}

$artifacts = [ordered]@{
    'templates/ai-instructions/AGENTS.md' = 'AGENTS.md'
    'templates/ai-instructions/CLAUDE.md' = 'CLAUDE.md'
    'templates/ai-instructions/CONTINUE.md' = 'CONTINUE.md'
    'CONSTITUTION.md' = 'CONSTITUTION.md'
    'templates/governance/GUARDRAILS.md' = 'governance/GUARDRAILS.md'
    'templates/governance/TOOL-POLICY.md' = 'governance/TOOL-POLICY.md'
    'templates/governance/APPROVAL-MATRIX.md' = 'governance/APPROVAL-MATRIX.md'
    'templates/governance/SKILLS-POLICY.md' = 'governance/SKILLS-POLICY.md'
    'templates/sdd/1-spec-template.md' = 'specs/template/1-spec.md'
    'templates/sdd/2-tech-plan-template.md' = 'specs/template/2-technical-plan.md'
    'templates/sdd/3-tasks-template.md' = 'specs/template/3-tasks.md'
}
if ($Stack -in @('web', 'node')) { $artifacts['templates/github-workflows/dependency-audit.yml'] = '.github/workflows/dependency-audit.yml' }
if ($Include -contains 'evals') { $artifacts['templates/sdd/4-evaluation-plan.md'] = 'evals/template/evaluation.md' }
if ($Include -contains 'verification') {
    $artifacts['templates/optional/VERIFICATION.md'] = 'VERIFICATION.md'
    $artifacts['templates/optional/CONCURRENT-AGENTS.md'] = 'governance/CONCURRENT-AGENTS.md'
}
if ($Include -contains 'infrastructure') { $artifacts['templates/optional/INFRASTRUCTURE.md'] = 'INFRASTRUCTURE.md' }
if ($Include -contains 'nemoclaw') { $artifacts['templates/optional/NEMOCLAW.md'] = 'NEMOCLAW.md' }
if ($Include -contains 'mcp') {
    $artifacts['mcp-server/index.js'] = '.engineering-playbook/mcp-server/index.js'
    $artifacts['mcp-server/package.json'] = '.engineering-playbook/mcp-server/package.json'
    $artifacts['mcp-server/README.md'] = '.engineering-playbook/mcp-server/README.md'
}

$conflicts = @($artifacts.Values | Where-Object { Test-Path -LiteralPath (Join-Path $TargetDir $_) })
if ($conflicts.Count -gt 0 -and -not $Force) {
    throw "Installation stopped because files already exist:`n  - $($conflicts -join "`n  - ")`nReview them first, or use -Force to back them up and replace them."
}

$backupDir = $null
if ($conflicts.Count -gt 0) {
    $backupDir = Join-Path $TargetDir ".engineering-playbook-backup/$([DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'))"
    foreach ($relative in $conflicts) {
        $source = Join-Path $TargetDir $relative
        $backup = Join-Path $backupDir $relative
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup) | Out-Null
        Copy-Item -LiteralPath $source -Destination $backup -Recurse -Force
    }
    Write-Host "Backed up existing files to $backupDir"
}

foreach ($entry in $artifacts.GetEnumerator()) {
    $source = Join-Path $ScriptDir $entry.Key
    $destination = Join-Path $TargetDir $entry.Value
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw "Missing source artifact: $source" }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination -Force
}

$stateDir = Join-Path $TargetDir '.engineering-playbook'
New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
@('PLAYBOOK_VERSION=1.0.0', "STACK=$Stack", "MODULES=$(if ($Include.Count) { $Include -join ',' } else { 'core' })") |
    Set-Content -LiteralPath (Join-Path $stateDir 'install.env') -Encoding utf8NoBOM

if ($Include -contains 'mcp') {
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { throw 'MCP selected, but npm is not available.' }
    & npm install --omit=dev --ignore-scripts --prefix (Join-Path $TargetDir '.engineering-playbook/mcp-server')
    if ($LASTEXITCODE -ne 0) { throw 'MCP dependency installation failed.' }
}

foreach ($relative in $artifacts.Values) {
    $installed = Get-Item -LiteralPath (Join-Path $TargetDir $relative) -ErrorAction Stop
    if ($installed.Length -eq 0) { throw "Verification failed: $relative is empty." }
}

Write-Host ''
Write-Host 'Engineering Playbook 1.0.0 installed and verified.'
Write-Host "Target: $TargetDir"
Write-Host "Stack: $Stack"
Write-Host "Modules: $(if ($Include.Count) { $Include -join ',' } else { 'core' })"
Write-Host "Installed files: $($artifacts.Count)"
if ($backupDir) { Write-Host "Backup: $backupDir" }
Write-Host 'Next: customize the Project-specific additions section in AGENTS.md.'
