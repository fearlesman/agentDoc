# 文档智能同行评审 Agent

四人协作项目基座：上传 DOCX/PDF，解析文档，匹配检查单，执行逐项审查，支持人工复核、报告导出和历史审计。

## 统一环境

- Windows 11
- Python 3.11 + uv
- FastAPI + Pydantic
- Node.js 20 LTS + pnpm + React/TypeScript/Vite
- Git
- LibreOffice

项目必须支持在受控内网环境运行。保密材料不得上传到外部 API。

## 目录

- `backend/`：后端 API、解析器、审查引擎和测试
- `frontend/`：React/TypeScript 前端基座
- `contracts/`：最终契约与 JSON Schema
- `fixtures/`：跨模块固定测试样例
- `docs/`：开发文档
- `scripts/`：校验与开发脚本
- `data/`：本地运行数据，不提交真实材料

## 快速开始

```powershell
cd backend
uv sync
uv run uvicorn app.main:app --reload
```

前端依赖准备后：

```powershell
cd frontend
pnpm install --frozen-lockfile
pnpm dev
```

API 文档：`http://localhost:8000/docs`

## 重要文件

- `docs/CONTRIBUTING.md`：协作规则
- `contracts/README.md`：契约使用方式
- `backend/pyproject.toml`：Python 依赖
- `frontend/package.json`：前端依赖
