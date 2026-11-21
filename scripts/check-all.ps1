# 提交前自检：后端测试 + 契约样例校验。
# 用法：pwsh ./scripts/check-all.ps1
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$env:UV_CACHE_DIR = Join-Path $repoRoot '.uv-cache'
$failed = $false

Write-Host '== 1/2 后端单元测试 =='
try {
    Push-Location (Join-Path $repoRoot 'backend')
    uv run pytest -p no:cacheprovider
}
catch {
    $failed = $true
    Write-Host "后端测试失败：$_"
}
finally {
    Pop-Location
}

Write-Host '== 2/2 契约样例 JSON 解析校验 =='
$fixtureDir = Join-Path $repoRoot 'fixtures'
$jsonFiles = Get-ChildItem -Path $fixtureDir -Filter '*.json' -File -ErrorAction SilentlyContinue
if (-not $jsonFiles) {
    Write-Host '尚未提交 fixture JSON，跳过。'
}
else {
    foreach ($file in $jsonFiles) {
        try {
            Get-Content -Raw -LiteralPath $file.FullName | ConvertFrom-Json | Out-Null
            Write-Host "OK   $($file.Name)"
        }
        catch {
            $failed = $true
            Write-Host "FAIL $($file.Name)：$_"
        }
    }
}

if ($failed) {
    Write-Host '自检未通过。'
    exit 1
}
Write-Host '自检通过。'
