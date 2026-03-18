# ⚡️ OpenClaw Exec Auto‑Approve

> **告别审批弹窗，一键全放行。**
> 你只管跑命令，剩下的交给它。🚀

![AutoApprove Hero](https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1400&q=80)

---

## 🔥 你为什么需要它（激进版）

- ✅ **再也不弹 Exec Approval**：从此没有“确认/允许/再点一次”的噩梦
- ✅ **一键解锁生产力**：所有常用工具自动放行，流程不再被打断
- ✅ **后台自动跟进**：新工具第一次出现，自动加入白名单
- ✅ **立刻见效**：安装完成即生效，网关自动重启

> **如果你对“每个命令都要点批准”已经忍无可忍——这就是你的解药。** 😤

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

## 📣 最后一句话（广告模式）

**别再被审批弹窗驯化。**
**把效率交还给你自己。**
**装上它，解锁“零审批”的全速模式。** ⚡️
