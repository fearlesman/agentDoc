# AGENTS.md

## 项目概览

本仓库是“文档智能同行评审 Agent”的四人协作项目基座。目标闭环是：

> 上传 DOCX/PDF → 结构化解析 → 判断文档类型 → 匹配检查单 → 用户确认 → 按检查项和业务步骤异步审查 → 输出证据、定位、风险和建议 → 专家复核 → 导出 Word/PDF/JSON 报告 → 历史检索与审计。

项目必须支持在受控内网运行。真实课题材料及衍生数据不得上传到外部 API、公开仓库或提交历史。

## 开始工作前必读

按以下顺序阅读：

1. 本文件 `AGENTS.md`；
2. `contracts/最终统一数据契约v1.1.md`：唯一可执行的数据、状态和 API 契约；
3. `docs/四人最终实施总则.md`：整体闭环、模块边界和验收要求；
4. 自己负责模块对应的任务书：
   - A：`docs/最终版-成员A任务书.md`
   - B：`docs/最终版-成员B任务书.md`
   - C：`docs/最终版-成员C任务书.md`
   - D：`docs/最终版-成员D任务书.md`
5. `docs/CONTRIBUTING.md` 和 `contracts/README.md`。

根目录之外的原始材料、旧版契约和旧版任务书仅用于背景参考；旧版契约不得作为实现依据。

## 目录与模块边界

- `backend/`：Python 3.11、FastAPI/Pydantic 后端；包含 API、任务编排、解析器、审查引擎和测试。
- `frontend/`：Node.js 20 LTS、pnpm、React/TypeScript/Vite 前端。
- `contracts/`：跨模块契约、枚举、状态机和 JSON Schema 的唯一入口。
- `fixtures/`：脱敏的跨模块固定测试样例；禁止放真实文档内容。
- `docs/`：协作规则、总则和成员任务书。
- `scripts/`：本地测试、启动和提交前自检脚本。
- `data/uploads/`、`data/exports/`：本地运行目录，只提交 `.gitkeep`，不提交真实文件。

四人模块边界：

- **A 文档解析与定位**：DOCX/PDF 解析、统一 IR、section/block/table、anchor 和源文件 hash。
- **B 检查单与审查引擎**：检查项/步骤、文档类型匹配、规则执行、Finding 聚合和 summary 重算。
- **C 任务编排、存储与 API**：持久化、异步 Job、状态转换、权限、审计和统一 API。
- **D Web、人工复核与报告**：前端流程、Finding 展示与定位、复核操作、报告生成和下载。

不要跨越边界偷偷修改别人的内部实现；跨模块需求通过契约、fixture、测试和明确的接口变更沟通。

## 不可违反的契约规则

- 实现只使用 `contracts/最终统一数据契约v1.1.md`；发现问题先提议修订，不要在模块内绕过契约。
- API 路径统一以 `/api/v1` 开头；响应使用 `{"request_id":"...","data":{},"error":null}` 包装。
- 保留 `Authorization`、`X-Request-ID`、幂等键和必要的 `If-Match` 并发控制。
- 一次审查使用动态 `selected_item_ids`，不能把检查项数量写死为 32。
- `summary` 必须由服务端根据 Finding 及有效复核快照重算，不能由前端或调用方直接提交可信统计。
- 不得混淆这些对象和状态：Document、Job、Review、Export、ChecklistMatch；状态转换必须符合契约。
- `finding_status`：`passed | failed | needs_review | not_applicable | error`。
- `step_status`：`passed | failed | skipped | uncertain | error`。
- 置信度低于 `0.70` 或证据不足时，结果必须进入 `needs_review`；证据必须包含可复核的定位信息。
- Evidence 支持 `quote`、`absence`、`table_cell`、`cross_reference`；禁止只返回没有 anchor 的自然语言结论。
- 正式审查的报告必须保存结果快照，不能因后续复核或规则版本变化而失去历史可追溯性。

## 开发与验证

后端：

```powershell
cd backend
$env:UV_CACHE_DIR = "..\.uv-cache"
uv sync
uv run pytest -p no:cacheprovider
uv run uvicorn app.main:app --reload
```

从仓库根目录也可以使用：

```powershell
pwsh ./scripts/test-backend.ps1
pwsh ./scripts/check-all.ps1
pwsh ./scripts/run-backend.ps1
```

前端：

```powershell
cd frontend
pnpm install --frozen-lockfile
pnpm dev
pnpm build
```

提交前至少运行后端测试；涉及前端时还要运行前端构建；涉及契约或 fixture 时还要运行契约校验。当前基座后端健康测试应保持 `1 passed`。

## 修改规范

1. 先读文件再改文件；优先小范围编辑，避免无关格式化。
2. 修改共享对象、枚举、状态、错误码或 API 时，同时更新契约、fixture、测试和相关任务书。
3. 所有公开 Python API 使用 Google 风格 docstring（`Args`、`Returns`、`Raises`）；TypeScript 导出 API 使用 JSDoc。
4. 测试数据必须脱敏、可复现；固定 ID 和带时区的 ISO 8601 时间优先。
5. 不提交 `.env`、密钥、token、真实 DOCX/PDF、上传物、导出物、数据库文件、`.venv/`、`node_modules/` 或构建产物。
6. 不新增外部 API 上传保密材料的调用；需要模型能力时必须支持受控内网部署或本地替代方案。
7. 提交信息使用简洁的英文动词开头，例如 `feat: add document parser`、`test: validate finding summary`。

## 常见问题

- `uv` 缓存权限异常：将 `UV_CACHE_DIR` 指向仓库内的 `.uv-cache`，该目录已被 `.gitignore` 忽略。
- pytest 产生缓存权限问题：使用 `pytest -p no:cacheprovider`，不要绕过测试。
- `pnpm` 在受限沙箱中出现 `spawn EPERM`：记录为环境限制；在正常开发终端重新执行，不要因此删除前端依赖或锁文件。
- GitHub 推送必须使用本机 Git Credential Manager/VSCode 已配置凭据；不要把 token 写入远程 URL、代码、日志或配置文件。

## 完成标准

一个改动只有在以下条件都满足时才算完成：

- 代码和文档符合模块边界；
- 契约、类型、fixture 和测试保持一致；
- 正常流程和至少一个异常/人工介入流程可验证；
- 没有泄露真实材料或凭据；
- 相关测试通过，且工作区无意外未跟踪文件；
- 提交信息清楚说明变更目的和影响。
