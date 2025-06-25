# 🌈 清羽飞扬 · 1Panel 第三方 App Store

这是一个由 **清羽飞扬** 自建维护的 **1Panel 第三方应用商店仓库**，用于收纳个人常用的容器化应用与预设配置，基于 [1Panel](https://github.com/1Panel-dev/1Panel) 的 App Store 架构。

> 本项目旨在补充官方 App Store，适用于特定需求场景或实验性环境。

---

## ✅ 应用收录标准

本仓库优先收录以下类型的容器应用：

- 📦 **常用工具或服务**：覆盖个人或开发者日常使用频繁的项目
- 🔒 **官方 Docker 镜像优先**：确保稳定与安全
- 🧑‍🤝‍🧑 **活跃社区支持项目**：优先选择活跃维护或高质量项目
- 🧾 **简洁配置模板**：配套清晰的 Docker Compose 和 formFields 文件，方便一键部署

---

## 🛠 使用说明

你可以将本仓库作为第三方 App Store 添加至 1Panel，即可在 Web 面板中浏览、安装、管理其中的应用。

### 添加第三方应用仓库

参考官方文档：[📚 如何添加第三方应用仓库](https://github.com/1Panel-dev/1Panel/wiki)

---

## 🔄 同步更新脚本

以下是自动同步 App 应用至 1Panel 的脚本，适用于开发或部署用户。

### 📥 国内同步脚本（使用 CNB 仓库）：

```bash
#!/bin/bash

set -e

# 配置路径
GIT_REPO="https://cnb.cool/Liiiu/appstore"
TMP_DIR="/opt/1panel/resource/apps/local/appstore-localApps"
LOCAL_APPS_DIR="/opt/1panel/resource/apps/local"

echo "📥 Cloning appstore repo..."
git clone "$GIT_REPO" "$TMP_DIR"

mkdir -p "$LOCAL_APPS_DIR"

for app_path in "$TMP_DIR/apps/"*; do
  [ -d "$app_path" ] || continue

  app_name=$(basename "$app_path")
  local_app_path="$LOCAL_APPS_DIR/$app_name"

  echo "🔁 Updating app: $app_name"
  [ -d "$local_app_path" ] && rm -rf "$local_app_path"
  cp -r "$app_path" "$local_app_path"
done

echo "🧼 Cleaning up temporary repo..."
rm -rf "$TMP_DIR"

echo "✅ Sync completed."
```

### 🌍 国外环境请替换为 GitHub 仓库：

```bash
GIT_REPO="https://github.com/willow-god/appstore"
```

------

## 📮 问题反馈

如发现配置错误或希望新增应用，欢迎在 Issues 区提交反馈：

- 🛠 [本仓库 Issues](https://github.com/Liiiu/appstore/issues)

> ⚠️ 本项目仅对仓库中提供的应用内容提供支持。1Panel 本体问题请前往 [1Panel 主项目](https://github.com/1Panel-dev/1Panel/issues) 提问。

------

## ✨ 项目作者

- 💻 清羽飞扬（willow-god）
- 🌐 [个人主页](https://www.liushen.fun/)
- 📘 [技术博客](https://blog.liushen.fun/)

------

## 🧩 想添加自己的应用？

欢迎参考官方教程，构建你自己的 App Store 仓库：

👉 [📘 官方指南：如何提交自己想要的应用](https://github.com/1Panel-dev/appstore/wiki/如何提交自己想要的应用)