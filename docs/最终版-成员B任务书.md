# 成员 B 最终任务书｜检查单与审查引擎

> 缩写说明：PSAC 为软件合格审定计划；SRS 为软件需求规格/标准；IR 为中间表示（ParsedDocument）；AI 为人工智能机器结论；fixture 为固定测试样例。

## 环境边界

统一使用团队基线 Python 3.11 + uv。规则执行框架、匹配算法和内部模块结构由你自行选择；只要输出 v1.1 对象、保持证据和状态规则一致，并可在受控内网环境复现即可。

## 你要交付

读取 `课题-检查单.xlsx`，标准化 PSAC 10、SRS 10、通用 12 条；消费 A 的 `ParsedDocument`，输出 `ChecklistMatch`、`Review`、`Finding`。不得读取原始 DOCX/PDF，不做第二套解析。

## 规则

CheckItem 必须有 `item_id/category/document_types/question/logic_version/severity_default/reference/steps`；Step 有 `step_id/order/kind/requirement/keywords/required`。第一版 kind：`section_exists/content_check/table_check/cross_reference`。

按 order 执行；前置失败的非必需项可继续，必需项失败后后续步骤保留并写 `skipped` 原因。required step error→item error；required failed→failed；置信度 <0.70 或证据不足→needs_review；全部 required passed 且有正向证据→passed。

证据 kind：quote、absence、table_cell、cross_reference。通过项必须有正向证据；失败/待复核必须有反向 quote 或结构化 absence（scope/query/not_found_condition）。禁止无证据的可信结论。

## 接口

```python
def load_checklist(xlsx_path: str) -> Checklist:
    """Load and validate all checklist sheets.

    Args:
        xlsx_path: Path to the XLSX checklist.

    Returns:
        Versioned Checklist with normalized items.

    Raises:
        ChecklistFormatError: If sheets or required columns are missing.
    """
```

另实现 `match_checklist(document_type, checklist)`、`review_item(item, document)`、`review_all(items, document)`，均使用 Google docstring。

## 验收

PSAC/SRS 匹配专用+通用项；不写死 32；输出中间步骤、证据、风险、问题、期望、实际、建议；保存 engine/model/prompt 版本；输出 `review.json`、`checklist_match.json`、单测、评测脚本和规则缺失/低置信度测试。
