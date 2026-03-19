# 📘 Autoapprove SOP & 变更记录（Feishu 无弹窗执行）

> 适用版本：OpenClaw v2026.3.13

---

## ✅ SOP（标准流程）

### Step 0. 目标确认
- 目标：Feishu 场景 **无弹窗自动执行**（完全自动化）

### Step 1. 安装/更新 exec-autoapprove
```bash
bash ~/.openclaw/workspace/skills/exec-autoapprove/scripts/install.sh
```

### Step 2. 配置 OpenClaw（必须）

#### 2.1 修改 `~/.openclaw/openclaw.json`
```json
"tools": {
  "exec": { "security": "full", "ask": "off" }
}
```
作用：关闭 exec 弹窗，允许自动执行。

```json
"plugins": { "allow": ["feishu"] }
```
作用：避免 feishu 插件重复加载导致重启失败。

#### 2.2 修改 `~/.openclaw/exec-approvals.json`
```json
"agents": {
  "main": {
    "security": "full",
    "ask": "off",
    "askFallback": "full"
  }
}
```
作用：审批文件层面的放行策略对齐。

> ⚠️ 注意：`tools.exec.security` 优先级高于 `exec-approvals.json`，必须一致。

### Step 3. 重启网关
```bash
systemctl --user restart openclaw-gateway
```

若重启被阻断，使用：
```bash
pkill -f openclaw-gateway
systemctl --user start openclaw-gateway
```

### Step 4. 验证
- 执行任意需要审批的 exec 命令
- 预期：**无弹窗**，直接执行成功

---

## 🧾 变更记录（Change Log）

### v0.2.0
- watcher 改为：监控 `exec-approvals.json`，确保 `*` wildcard allowlist
- README 增补 Feishu 场景配置说明
- 新增本 SOP/变更记录

---

## ✅ 验证结果
- 测试发布成功：`✅ Note published successfully!`
- 全流程无弹窗，自动执行生效
