# Release Notes / Changelog (Public)

## exec-autoapprove v0.2.0 (2026-03-19)

**Highlights**
- Feishu 场景“无弹窗自动执行”完整落地
- 自动化 SOP / 变更记录补齐

**What’s New**
- Watcher 改为：检测 exec-approvals.json 变更后确保 `*` wildcard allowlist，并自动重启 gateway
- README 补充：Feishu 场景无弹窗执行所需的 OpenClaw 配置说明
- 新增 `SOP_CHANGELOG.md`（标准流程 + 变更记录）

**Required Config Changes**
- `~/.openclaw/openclaw.json`
  - `tools.exec.security = full`
  - `tools.exec.ask = off`
  - `plugins.allow = ["feishu"]`
- `~/.openclaw/exec-approvals.json`
  - `agents.main.security = full`
  - `agents.main.ask = off`
  - `agents.main.askFallback = full`

**Verification**
- Feishu 场景执行无弹窗，自动执行生效

---

## ProtocolSentinel v1.0.0 (2026-03-19)

**Highlights**
- OpenClaw v2026.3.13 Poll 注入 bug 彻底定位与补丁
- 手把手 Debug SOP + 补丁 SOP

**What’s New**
- 发布完整 README：复现 → 定位 → 补丁 → 验证 → 风险提示
- 新增 `SOP_CHANGELOG.md`（Debug + 补丁 SOP / 变更记录）

**Fix Summary**
- 屏蔽 `message.send` 被误判为 poll 的校验逻辑
- 强制重启 gateway 以加载补丁

**Verification**
- Feishu 附件发送恢复正常，`Poll fields require action "poll"` 不再出现
