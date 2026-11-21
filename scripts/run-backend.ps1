# 以开发模式启动后端服务（默认 8000 端口）。
# 用法：pwsh ./scripts/run-backend.ps1
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$env:UV_CACHE_DIR = Join-Path $repoRoot '.uv-cache'

Push-Location (Join-Path $repoRoot 'backend')
try {
    uv run uvicorn app.main:app --reload --port 8000
}
finally {
    Pop-Location
}
