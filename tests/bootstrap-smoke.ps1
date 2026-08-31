$ErrorActionPreference = 'Stop'
$RepoDir = Split-Path -Parent $PSScriptRoot
$TempRoot = [IO.Path]::GetTempPath().TrimEnd([IO.Path]::DirectorySeparatorChar)
$TestDir = Join-Path $TempRoot ("engineering-playbook-powershell-{0}" -f [guid]::NewGuid().ToString('N'))

try {
    New-Item -ItemType Directory -Path $TestDir | Out-Null
    git -C $TestDir init -q
    & (Join-Path $RepoDir 'setup.ps1') -TargetDir $TestDir -Stack web -Include evals,verification,infrastructure,nemoclaw,mcp

    @(
        'AGENTS.md'
        'evals/template/evaluation.md'
        'VERIFICATION.md'
        'governance/CONCURRENT-AGENTS.md'
        'INFRASTRUCTURE.md'
        'NEMOCLAW.md'
        '.engineering-playbook/mcp-server/node_modules/@modelcontextprotocol/sdk/package.json'
        '.github/workflows/dependency-audit.yml'
    ) | ForEach-Object {
        $item = Get-Item -LiteralPath (Join-Path $TestDir $_) -ErrorAction Stop
        if ($item.Length -eq 0) { throw "Installed artifact is empty: $_" }
    }
    & node (Join-Path $RepoDir 'tests/mcp-smoke.mjs') (Join-Path $TestDir '.engineering-playbook/mcp-server/index.js') $TestDir
    if ($LASTEXITCODE -ne 0) { throw 'MCP server smoke test failed.' }

    $conflictStopped = $false
    try {
        & (Join-Path $RepoDir 'setup.ps1') -TargetDir $TestDir -Stack web
    } catch {
        $conflictStopped = $_.Exception.Message -match 'already exist'
    }
    if (-not $conflictStopped) { throw 'Expected the second installation to stop on conflicts.' }

    'original marker' | Set-Content -LiteralPath (Join-Path $TestDir 'AGENTS.md')
    & (Join-Path $RepoDir 'setup.ps1') -TargetDir $TestDir -Stack web -Include evals,verification,infrastructure,nemoclaw,mcp -Force
    $backup = Get-ChildItem -LiteralPath (Join-Path $TestDir '.engineering-playbook-backup') -Recurse -Filter AGENTS.md | Select-Object -First 1
    if (-not $backup -or (Get-Content -Raw -LiteralPath $backup.FullName) -notmatch 'original marker') {
        throw 'The force installation did not preserve the conflicting AGENTS.md in its backup.'
    }

    Write-Host 'PowerShell bootstrap smoke test passed.'
}
finally {
    $resolved = if (Test-Path -LiteralPath $TestDir) { (Resolve-Path -LiteralPath $TestDir).Path } else { $null }
    if ($resolved -and $resolved.StartsWith($TempRoot, [StringComparison]::OrdinalIgnoreCase) -and
        (Split-Path -Leaf $resolved).StartsWith('engineering-playbook-powershell-')) {
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
