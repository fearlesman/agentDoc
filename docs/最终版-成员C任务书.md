# 成员 C 最终任务书｜任务编排、存储与 REST API

> 缩写说明：REST API 为 HTTP 接口；RBAC 为基于角色的访问控制；UUID/ULID 为对象唯一 ID；JSON 为接口数据格式；SHA-256 为文件完整性哈希；CI 为持续集成。

## 环境边界

统一使用团队基线 Python 3.11 + uv、FastAPI/Pydantic、Node.js 20 LTS（如涉及服务管理）。数据库、任务队列、存储方式和迁移工具由你自行选择；对外只能暴露 v1.1 规定的 API、状态、错误和权限行为，并可部署到受控内网。

## 你要交付

C 是唯一状态与存储入口：实现 Document、ParsedDocument、ChecklistMatch、Job、Review、Finding、Decision、Export、AuditEvent 的持久化、异步任务、RBAC、审计、历史和 API。

## API 必须实现

```text
POST /documents                         multipart(file)
GET  /documents/{id}
POST /documents/{id}/parse              → Job
GET  /documents/{id}/parsed
GET  /documents/{id}/matches
POST /documents/{id}/matches/confirm
POST /reviews                           CreateReviewRequest → Job+review_id
GET  /tasks/{task_id}
GET  /reviews/{review_id}
GET  /reviews/{review_id}/findings      cursor/status/severity
POST /findings/{finding_id}/decision
POST /reviews/{review_id}/exports       ExportRequest → Job+export_id
GET  /exports/{export_id}
GET  /exports/{export_id}/download
GET  /history                           cursor,limit,name,status,time_from,time_to
```

实际路径统一加 `/api/v1`。所有接口使用 Authorization、X-Request-ID 和统一响应；HTTP 401/403/404/409/413/415/422/500 映射及错误码见最终契约。

## 必须冻结

- 文件 ≤50MB，扩展名+MIME 校验，空/损坏文件拒绝，服务端 SHA-256；重复文件策略固定并审计。
- Document、Job、Review、Export 状态按契约转换；非法转换、陈旧版本、幂等冲突有明确错误。
- CreateReview 必须校验 parsed、match confirmed、selected IDs 非空/去重/排序且属于 match。
- summary 服务端重算；Finding item_id 唯一；findings 完成后使用 review 快照分页。
- RBAC：admin/reviewer/viewer；owner 隔离；下载短链授权、过期、撤销；删除覆盖原文、IR、缓存、向量、导出和备份并生成证明。

## Google 风格

公开 Python API 必须写 `Args/Returns/Raises`；存储事务注释说明幂等和一致性。交付数据库迁移、OpenAPI、fixture、集成测试、权限/审计/重试/状态机测试。
