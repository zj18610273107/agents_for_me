# AGENTS.md

版本：0.0.0

## 工作方式

- 默认中文回答；涉及 Linux、C、内核、嵌入式、驱动时解释准确、简洁，不啰嗦。
- 用户粘贴的 Linux 命令不执行，提示“你可能把 Linux 命令输到 Codex 里了”；只有用户明确说“执行/确认执行/帮我运行”时才执行。
- Ctrl+L 表示清屏；Ctrl+Z 表示撤销/回撤，按终端或界面语义处理，不转成任务。
- 每次只做一件事；修改前说明原因、目标文件和范围；完成后停止，等用户输入 `next` 再继续。
- 不主动编译、测试、运行程序，除非用户明确确认；可以给出命令建议，但默认不替用户执行。
- 例外：如果我在对话中输入“只看功能，不关注实现细节”，可以按 AI 自主方式连续修改代码，不强制每次停下等 `next`；必要时也可以执行编译、测试或运行命令验证。
- 全托管项目白名单中的项目，视为用户只看结果、不关注具体实现过程；可以连续完成分析、修改、必要验证和总结，不强制等待 `next`。
- 尽量少写代码：先复用已有接口，能少改就不大改，不做无必要封装和抽象。

## 低资源与文件创建

- 默认按低资源模式工作，尽量减少磁盘写入、CPU 占用和内存占用，不启动非必要的后台任务、文件监听或持续采样。
- 除非完成当前任务确有必要，否则不创建日志、缓存、临时文件、备份、副本、数据库、索引、报告、下载文件或其他生成物；优先复用已有文件，并将诊断结果输出到终端。
- 不主动启用 `TRACE`、`DEBUG` 等高频持久化日志，不把大量命令输出重定向到文件。
- 编译、测试或运行可能生成缓存、构建目录及其他文件时，即使项目处于全托管模式，也要先说明用途、目标路径和预计影响，并获得用户确认。
- 必须创建文件时，只创建完成任务所需的最少文件；提前说明原因、路径和清理方式，任务结束后不得遗留无用的临时产物。
- 本节约束 Codex 执行任务时采取的操作；Codex 客户端自身必需的内部状态、日志或缓存不能仅通过 `AGENTS.md` 关闭。

## 全托管项目白名单

当前项目名或仓库根目录名命中以下任一项时，启用全托管模式：

- `A_info_Report`
- `self-runbook`
- `codex_code_selected`
- `common_skills`
- `agents_for_me`

## 提交规则

- 当用户要求创建或整理 git commit 时，所有提交信息末尾都加上 `Signed-off-by: zhou jie <zj18610273107@163.com>`。
- 如果提交内容由 Codex 参与分析、修改或生成，则额外加上 `Co-authored-by: Codex <codex@openai.com>` 作为 Codex 署名。
- 务必记得多个提交署名连续书写，中间不加空行。

## 输出

- 命令和代码放独立代码块，不加 `$`、`#`、`>` 提示符；多条命令放同一个代码块；解释写在代码块外。
- 代码位置单独一行，使用 `relative/path/file.c:line`，必须用英文冒号。
- 函数签名使用 `# int foo(...)`；单独提函数名使用 `#foo`。
- 修改建议优先使用 diff；不输出危险命令，除非用户明确要求并先说明风险。
- C/Linux/嵌入式代码尽量接近 Linux kernel 风格：职责单一、命名清楚、错误路径清晰、资源申请和释放成对出现、避免复杂宏和隐藏副作用。
- 空实现、stub、mock 必须用有明确说明的 `TODO` 标注，不能只写一个空泛的 `TODO`。

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `build/codegraph.db` exists at the repo root), reach for it BEFORE grep/find/read when understanding or locating code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call, returning verbatim source plus call paths. If it is listed but deferred, load it by name via tool search.
- **Shell** (always works): `CODEGRAPH_DIR=build codegraph explore "<symbol names or question>"`. If a plain `codegraph ...` says there is no `.codegraph/` index, do not run `codegraph init`; retry with `CODEGRAPH_DIR=build`.

If there is no `build/codegraph.db` and no other configured `CODEGRAPH_DIR` points to an existing database, skip CodeGraph entirely. Indexing is the user's decision.
<!-- CODEGRAPH_END -->
