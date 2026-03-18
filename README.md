# ⚡️ OpenClaw Exec Auto‑Approve

![License](https://img.shields.io/badge/License-MIT-green.svg)
![OpenClaw](https://img.shields.io/badge/OpenClaw-2026.3.13%2B-blue)
![Platform](https://img.shields.io/badge/Platform-Linux-informational)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success)

> **告别审批弹窗，一键全放行。**
> 你只管跑命令，剩下的交给它。🚀

![AutoApprove Hero](https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1400&q=80)

---

## 🔬 为什么需要它

### 1) 现实痛点（Problem Statement）
- **高频审批打断执行流**：每次 Exec Approval 都在打断心流，累积成本极高。
- **工具链增长导致白名单维护失控**：新工具不断增加，审批滞后阻断自动化。
- **审批依赖人工确认**：在连续任务/批处理场景中，审批成为系统级瓶颈。

### 2) 全新架构！（Innovation）
- **自动化白名单治理**：一次性补齐常用路径 + 自动追踪新路径，消除手工维护。
- **事件驱动式放行**：基于 `exec-approvals.json` 的变化事件，实时补全 allowlist。
- **即时生效机制**：变更后自动触发网关重载，审批门槛即时降低。

### 3) 架构模式（Architecture）
> **“一次性补全 + 持续监听”双层架构**

- **静态层（Bootstrap）**：`patch-allowlist.py` 预置常用路径，建立基线白名单。
- **动态层（Watcher）**：`watcher.sh` 通过 inotify 监听，捕获新路径并自动放行。
- **控制层（systemd user）**：保证 watcher 长驻运行，持续自动治理。

### 4) 逻辑闭环（Logic Loop）
1) OpenClaw 写入新的审批记录
2) Watcher 监听到变更
3) 自动补全 resolved path → 写入 allowlist
4) 触发网关重载 → 立即生效

**结论：** Exec 审批从“人工瓶颈”升级为“自动治理系统”。

---

## ✅ 适用版本（已验证）

- **OpenClaw 2026.3.13+**（当前已实测）
- Linux 环境（systemd user 服务）

---

## 🧠 Skill 版本号

- **exec-autoapprove v0.1.0**

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

![AutoApprove Demo](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExM2UxY2E2Y2U5NDQ4MDUzY2I3ZDA5ZTQ2MWM2OTk5N2JjZTIxYzAxMCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/3o7btPCcdNniyf0ArS/giphy.gif)

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

## 📣 最后一句话（高大上版）

**把审批从“人工摩擦”升级为“系统自治”。**
**这是效率工程的最后一公里。** ⚡️
