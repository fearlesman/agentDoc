# 成员 A 最终任务书｜文档解析与定位

> 缩写说明：DOCX/PDF 为 Word/PDF 文件格式；IR 为中间表示（ParsedDocument）；OCR 为光学字符识别；SHA-256 为文件完整性哈希；anchor 为原文定位锚点。完整术语表见最终统一数据契约。

## 环境边界

统一使用团队基线 Python 3.11 + uv。解析库、PDF/OCR方案和内部目录结构由你自行选择；只要输出 v1.1 `ParsedDocument`、可在受控内网环境运行并通过 fixture/测试即可。

## 你要交付

把 DOCX/PDF 转为 v1.1 `ParsedDocument`。只做事实提取、章节/段落/表格结构化和证据定位，不判断符合性。

## 输入/输出

输入：C 保存的 Document 和受控文件路径。输出：`ParsedDocument`，含 sections、顶层 blocks、tables、warnings、full_text_sha256。必须支持两个样例 DOCX；文本型 PDF；扫描 PDF 可返回 `OCR_UNAVAILABLE`/`PARSE_FAILED`，不得伪造结果。

Location 必须固定为 `section_id,page,paragraph_index,line_start,line_end,anchor,source_offset_start,source_offset_end`。页/行不可得写 null。anchor 必须能被 `GET /documents/{id}/parsed` 回指并校验源版本/hash。

## 接口

```python
def parse_document(file_path: str, document_id: str) -> ParsedDocument:
    """Parse a source document into the shared document IR.

    Args:
        file_path: Controlled path of the DOCX or PDF file.
        document_id: Stable document identifier.

    Returns:
        ParsedDocument containing sections, blocks, tables, and locations.

    Raises:
        UnsupportedFormatError: If the format is not accepted.
        ParseError: If parsing fails.
    """
```

公开 API、类、模块使用 Google 风格 `Args/Returns/Raises`。

## 必须测试

标题层级、编号、关键章节、表格、段落 anchor 回指、空/损坏/未知格式、页码不可得、哈希一致。关键章节：PSAC 4.2/6.1；SRS 5.3/9。

## 交付

`parser/`、`document_ir.json`、样例输出、单测、README、已知限制和 parser_version。不得新增审查状态字段。
