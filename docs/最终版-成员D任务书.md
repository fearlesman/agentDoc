# 成员 D 最终任务书｜Web、人工复核与报告

> 缩写说明：API 为应用程序编程接口；AI 为人工智能机器结论；JSON 为接口数据格式；Word/PDF 为报告格式；JSDoc 为 JavaScript/TypeScript 注释格式；fixture 为固定测试样例。

## 环境边界

统一使用团队基线 Node.js 20 LTS + pnpm、React/TypeScript/Vite。UI 组件库、状态管理和页面内部组织由你自行选择；只要只调用 C 的 v1.1 API、可在受控内网环境运行并通过端到端验收即可。

## 你要交付

只通过 C 的 API 实现上传、解析预览、匹配确认、审查进度、结果看板、复核、报告和历史；不读原始文件、不访问数据库、不实现第二套规则。

## 页面闭环

1. 上传：DOCX/PDF、大小/类型、进度和错误；
2. 解析预览：文档类型、标题、页数、章节/表格数、warnings、匹配候选和 selected 数量；
3. 匹配确认：允许选择专用+通用项，调用 matches/confirm；
4. 审查进度：展示 stage、current_item_id、completed/total、partial_failure；
5. 结果：按 passed/failed/needs_review/not_applicable/error 和风险筛选，展示 step_results、证据、位置、问题、期望、实际、建议；数量按实际 selected IDs，不能写死 32；
6. 复核：仅 failed/needs_review，accepted/rejected/modified；rejected comment 必填，modified 显示 final 字段；
7. 导出/历史：JSON、Word、PDF 异步导出，下载过期/失败可见。

## 报告必须包含

文档名称/type/hash、审查时间、解析/规则/引擎/prompt 版本、覆盖范围、AI 原判统计、effective 最终统计、逐项步骤、证据、位置、风险、建议、全部复核事件、report/template version。页码不可用显示“页码不可用”。报告快照不可变。

## TypeScript 注释

```typescript
/**
 * Fetches a review and maps it to the result view model.
 *
 * @param reviewId Stable review ID returned by the service.
 * @returns Review bundle used by the result dashboard.
 * @throws ApiError If the service returns a non-success response.
 */
```

Python 项目使用 Google `Args/Returns/Raises`。

## 验收

用 `review.json/export.json` fixture 独立开发；真实联调完成 PSAC、SRS 两条链路。展示异常：解析失败、规则缺失、低置信度、导出失败、越权和过期下载。复核后同时显示 AI 初判与 effective 结论；不把 error 显示成不通过；所有操作由后端审计。
