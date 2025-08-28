# 🌈 1Panel 第三方 App Store

本仓库是 [清羽飞扬](https://github.com/Liiiu/appstore) 维护的 **1Panel 第三方应用商店** 的镜像分支，基于 [1Panel](https://github.com/1Panel-dev/1Panel) 应用市场架构构建。

收录常用容器化应用，旨在补充官方应用商店，满足个性化部署与实验性环境的需求。并同步至 [cnb.cool](https://cnb.cool/gyhwd.top/1panel-appstore) 以提供更稳定的国内访问支持。

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

### 🧩 想添加自己的应用？

欢迎参考官方教程，构建你自己的 App Store 仓库：

👉 [📘 官方指南：如何提交自己想要的应用](https://github.com/1Panel-dev/appstore/wiki/如何提交自己想要的应用)

---

## 🔄 同步更新脚本

以下是自动同步 App 应用至 1Panel 的脚本，适用于开发或部署用户。

使用github action保持同步更新。

### 📦 普通脚本（仅同步应用）：

```bash
#!/bin/bash
# 清羽飞扬 · 1Panel 第三方应用商店同步脚本（轻量优化版）
# 仅同步应用，不执行镜像替换

# 启用严格模式：遇到错误、未定义变量、管道错误时立即退出
set -euo pipefail

# 设置字段分隔符，防止文件名含空格或换行符时出错
IFS=$'\n\t'

# 配置路径
GIT_REPO="https://cnb.cool/gyhwd.top/1panel-appstore"  # 第三方应用商店地址
TMP_DIR="/opt/1panel/resource/apps/local/appstore-localApps"
LOCAL_APPS_DIR="/opt/1panel/resource/apps/local"

# 确保脚本退出时自动清理临时目录（即使中途出错也会执行）
# trap 'rm -rf "$TMP_DIR"' EXIT
trap 'echo "🧹 清理临时目录: $TMP_DIR"; rm -rf "$TMP_DIR"' EXIT

# 开始克隆应用商店仓库
echo "📥 Cloning appstore repo..."
git clone "$GIT_REPO" "$TMP_DIR"

# 创建本地应用目录（如果不存在）
mkdir -p "$LOCAL_APPS_DIR"

# 遍历所有应用并同步到本地
for app_path in "$TMP_DIR/apps/"*; do
    # 跳过非目录项
    [ -d "$app_path" ] || continue

    app_name=$(basename "$app_path")
    local_app_path="$LOCAL_APPS_DIR/$app_name"

    echo "🔁 Updating app: $app_name"
    # 如果本地已存在同名应用，先删除
    [ -d "$local_app_path" ] && rm -rf "$local_app_path"
    # 复制新版本应用
    cp -r "$app_path" "$local_app_path"
done

# 清理临时克隆的仓库目录
echo "🧼 Cleaning up temporary repo..."
# 注意：rm -rf "$TMP_DIR" 会被 trap 自动执行，此处可省略或保留（重复执行无影响）

echo "✅ Sync completed."
```

### 🔄 `mirror.sh` 版本脚本（支持镜像替换）：

```bash
#!/bin/bash
# 清羽飞扬 · 1Panel 第三方应用商店同步脚本（优化版）
# 支持同步应用并执行镜像替换（通过 mirror.sh）

# 启用严格模式：遇到错误、未定义变量、管道错误时立即退出
set -euo pipefail

# 设置字段分隔符，防止文件名含空格或换行符时出错
IFS=$'\n\t'

# 配置路径
GIT_REPO="https://cnb.cool/gyhwd.top/1panel-appstore"  # 第三方应用商店地址
TMP_DIR="/opt/1panel/resource/apps/local/appstore-localApps"
LOCAL_APPS_DIR="/opt/1panel/resource/apps/local"

# 确保脚本退出时自动清理临时目录（即使中途出错也会执行）
trap 'echo "🧹 清理临时目录: $TMP_DIR"; rm -rf "$TMP_DIR"' EXIT

# 开始克隆应用商店仓库
echo "📥 Cloning appstore repo..."
# 如果临时目录已存在，先删除（避免 git clone 失败）
[ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
git clone "$GIT_REPO" "$TMP_DIR"

# 进入克隆的仓库目录，准备执行镜像替换
cd "$TMP_DIR"

# 执行镜像替换脚本（如果存在）
echo "🔄 Mirroring apps..."
if [[ -f "./mirror.sh" ]]; then
    echo "🔧 mirror.sh found, starting image mirroring process..."
    chmod +x ./mirror.sh
    set +u # 临时关闭未定义变量检查，避免 mirror.sh 内部变量问题
	if ! ./mirror.sh; then
        echo "⚠️ Warning: mirror.sh exited with error, but continuing sync..."
    fi
    set -u # 重新开启
    echo "✅ Image mirroring completed."
else
    echo "⚠️ mirror.sh not found, skipping mirroring"
fi

# 返回原始目录
cd -

# 创建本地应用目录（如果不存在）
mkdir -p "$LOCAL_APPS_DIR"

# 遍历所有应用并同步到本地
echo "🔁 Syncing apps to local directory..."
for app_path in "$TMP_DIR/apps/"*; do
    # 跳过非目录项
    [ -d "$app_path" ] || continue

    app_name=$(basename "$app_path")
    local_app_path="$LOCAL_APPS_DIR/$app_name"

    echo "🔁 Updating app: $app_name"
    # 如果本地已存在同名应用，先删除
    [ -d "$local_app_path" ] && rm -rf "$local_app_path"
    # 复制新版本应用
    cp -r "$app_path" "$local_app_path"
done

echo "✅ Sync completed."
```

🌍 国外环境请替换为 GitHub 仓库：

```bash
GIT_REPO="https://github.com/wojackop/1panel-appstore"
```

------

## 🎡 镜像加速配置

在国内环境下，部分容器镜像源（如 `ghcr.io`、`gcr.io`、`quay.io` 等）可能会出现访问缓慢或被墙的情况。

你可以通过本镜像库独有的 **镜像映射配置文件** 来自动替换 `docker-compose.yml` 中的镜像地址，提升下载速度。

**注意该方式可能仅仅适用于本应用商店。**

### 1️⃣ 配置文件路径

镜像配置文件固定放在：

```bash
/opt/mirror-config.env
```

如果需要配置对应镜像，请自行创建以上文件，然后写入以下内容。

### 2️⃣ 配置文本

```ini
# ====== GHCR (GitHub Container Registry) ======
# 是否经常被墙：是
GHCR_ENABLE=true
GHCR_MIRROR=ghcr.io.mirror

# ====== Quay.io (RedHat/Community images) ======
# 是否经常被墙：是
QUAY_ENABLE=false
QUAY_MIRROR=quay.io.mirror

# ====== GCR (Google Container Registry) ======
# 是否经常被墙：是
GCR_ENABLE=false
GCR_MIRROR=gcr.io.mirror

# ====== k8s.gcr.io (旧 Kubernetes 镜像仓库) ======
# 是否经常被墙：是
K8S_GCR_ENABLE=false
K8S_GCR_MIRROR=k8s.gcr.io.mirror

# ====== registry.k8s.io (新 Kubernetes 镜像仓库) ======
# 是否经常被墙：是
K8S_REG_ENABLE=false
K8S_REG_MIRROR=registry.k8s.io.mirror
```

> 💡 **说明**：
>
> - `*_ENABLE` 为 `true` 时才会进行替换。
> - `*_MIRROR` 填写你可用的镜像源地址。
> - 不存在该配置文件时，脚本会跳过替换步骤，不会影响后续流程。

### 3️⃣ 自动替换逻辑

> 该部分无需配置，仅供说明脚本的绿色性质，替换脚本开源于非docker.io镜像中如**MoonTV**仓库，有需要请自行查看

在克隆仓库后，按照本仓库的脚本，会在应用目录下执行 `mirror.sh` 进行镜像源替换。

这样即使镜像源被墙，也能快速替换为你配置的加速地址。

> **目前还在测试中**：由于目前还在测试中，所以可能会出现一些问题。如果出现问题，请及时反馈。
