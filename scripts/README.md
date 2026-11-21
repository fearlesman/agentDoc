# scripts：本地开发与校验脚本

本目录存放团队共用的辅助脚本。脚本只做本地开发、测试和校验，不参与运行时业务逻辑。

## 脚本清单

| 脚本 | 用途 |
| --- | --- |
| `test-backend.ps1` | 运行后端单元测试 |
| `run-backend.ps1` | 以开发模式启动后端服务 |
| `check-all.ps1` | 提交前自检：后端测试 + 契约样例校验 |

## 使用方式

在仓库根目录执行：

```powershell
pwsh ./scripts/test-backend.ps1
pwsh ./scripts/run-backend.ps1
pwsh ./scripts/check-all.ps1
```

## 说明

- 脚本会把 `UV_CACHE_DIR` 指向仓库内的 `.uv-cache`，避免使用用户级缓存目录时出现权限问题。
- 脚本使用 `pytest -p no:cacheprovider`，避免在受限目录写入缓存文件。
- 脚本不读取真实保密材料，只使用 `fixtures/` 中的脱敏样例。
