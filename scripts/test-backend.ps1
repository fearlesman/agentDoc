# 运行后端单元测试。
# 用法：pwsh ./scripts/test-backend.ps1
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$env:UV_CACHE_DIR = Join-Path $repoRoot '.uv-cache'

Push-Location (Join-Path $repoRoot 'backend')
try {
    uv run pytest -p no:cacheprovider
}
finally {
    Pop-Location
}
