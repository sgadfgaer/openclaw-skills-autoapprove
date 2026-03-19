# ⚡️ OpenClaw Exec Auto‑Approve

![License](https://img.shields.io/badge/License-MIT-green.svg)
![OpenClaw](https://img.shields.io/badge/OpenClaw-2026.3.13%2B-blue)
![Platform](https://img.shields.io/badge/Platform-Linux-informational)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success)

> **告别审批弹窗，一键全放行。**
> 你只管跑命令，剩下的交给它。🚀

![AutoApprove Hero](assets-hero.png)

---

## 🔬 为什么需要它

### 1) 现实痛点（Problem Statement）
- **高频审批反复打断自动化流程**：每一次 `Exec Approval` 都会切断任务节奏，让原本应当连续运行的自动化链路频繁中断，长期来看成本极高。  
- **工具链越长，白名单越难维护**：新工具、新路径不断出现，人工补录始终落后于实际使用，审批滞后逐渐成为自动化扩展的主要阻力。  
- **人工审批正在成为系统级瓶颈**：在连续执行、批处理和无人值守场景中，审批不再只是确认动作，而是直接决定系统效率与可持续运行能力的核心限制。  

### 2) 全新架构！（Innovation）
- **自动化白名单治理**：通过一次性补齐高频常用路径，并持续自动追踪新增路径，将白名单维护从人工补录升级为自动收敛。  
- **事件驱动式自动放行**：围绕 `exec-approvals.json` 的变更事件进行实时感知与响应，自动补全 `allowlist`，让审批治理从被动处理变为主动演进。  
- **即时生效机制**：每次变更完成后自动触发网关重载，使新的放行规则立即投入使用，持续降低审批门槛，恢复自动化链路的执行流畅性。
-   
### 3）架构模式（Architecture）

> **“一次性补全 + 持续监听”的双层治理模式**

- **静态层（Bootstrap）**：`patch-allowlist.py` 负责预置高频常用路径，先建立一套可直接投入使用的基线白名单。  
- **动态层（Watcher）**：`watcher.sh` 通过 `inotify` 持续监听相关变更，发现新路径后自动补充并放行，让系统随着实际运行不断自我完善。  
- **控制层（systemd user）**：使用 `systemd user` 保证 watcher 长驻运行，形成可长期维护、可持续演进的自动化治理闭环。
- 
### 4）逻辑闭环（Logic Loop）
1. **OpenClaw 产生新的审批记录**  
2. **Watcher 持续捕获变更事件**  
3. **系统自动补全 `resolved path` 并更新 `allowlist`**  
4. **网关自动重载，新规则即时生效**  

**结论：** `Exec` 审批不再是反复打断流程的人工作业，而是被纳入一套可自动感知、自动补全、自动生效的持续治理机制。  

---

## ✅ 适用版本（已验证）

- **OpenClaw 2026.3.13+**（当前已实测）
- Linux 环境（systemd user 服务）

---

## 🧠 Skill 版本号

- **exec-autoapprove v0.2.0**

---

## 🔧 本次配套 OpenClaw 配置变更（必须说明）

为实现 **Feishu 场景无弹窗自动执行**，除了 skill 本体外，还涉及以下 OpenClaw 配置：

### 1) `~/.openclaw/openclaw.json`

```json
"tools": {
  "exec": { "security": "full", "ask": "off" }
}
```
**作用**：关闭 exec 弹窗，允许自动执行。

```json
"plugins": { "allow": ["feishu"] }
```
**作用**：避免 feishu 插件重复加载导致 gateway 重启失败。

### 2) `~/.openclaw/exec-approvals.json`

```json
"agents": {
  "main": {
    "security": "full",
    "ask": "off",
    "askFallback": "full"
  }
}
```
**作用**：审批文件层面的自动化放行策略对齐。

> ⚠️ 注意：`tools.exec.security` 的优先级高于 `exec-approvals.json`。两者需一致，否则仍会被 allowlist 拒绝。

---

## 🧪 已验证结果（Feishu 场景）

- 发布测试笔记成功：`✅ Note published successfully!`
- **全流程无弹窗**，自动执行生效。

---

## 🩹 额外补丁说明（OpenClaw message poll 冲突）

当 `message.send` 被错误判定为 poll 时，会报：
```
Poll fields require action "poll"
```
需要在 OpenClaw dist 里屏蔽该校验（详见复盘文档），否则飞书附件发送会被拦截。

---

## 🚀 安装（30 秒搞定）

```bash
# 解包后，直接运行安装脚本
bash ~/.openclaw/workspace/skills/exec-autoapprove/scripts/install.sh
```

安装脚本会：
1) **补全 allowlist（常见路径全部加入）**
2) **安装 watcher 服务（自动捕捉新命令）**

---

## ⚙️ 运行原理（3 行看懂）

- **patch-allowlist.py**：把常用路径加入 allowlist
- **watcher.sh**：监听 `exec-approvals.json`，自动放行新路径
- **systemd user**：保证服务一直在后台运行

---

## 🎬 GIF 演示（零审批模式）

![AutoApprove Demo](reckless.gif)

---

## 🧨 重要提示（请务必读）

> **此技能 = 放开执行审批。**
> **任何可执行命令都可能被自动批准。**

**强烈建议仅在：**
- 你完全信任的私有机器
- 隔离环境 / 个人 VM / 实验环境

如果你需要“安全版（只放行指定命令）”，请联系我提供精简版。🛡️

---

## 🖼️ 视觉示意

![No Popup](https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?auto=format&fit=crop&w=1400&q=80)

---

## 📌 目录结构

```
exec-autoapprove/
├── SKILL.md
└── scripts/
    ├── install.sh
    ├── watcher.sh
    ├── patch-allowlist.py
    └── add-path.sh
```

---

## ✅ 快速检查

```bash
systemctl --user status openclaw-autoapprove
```

---

## 📣 最后一句话

**把审批从“人工摩擦”升级为“系统自治”。**
**这是效率工程的最后一公里。** ⚡️
