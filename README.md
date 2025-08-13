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

### 📥 国内同步脚本：

镜像仓库地址：https://cnb.cool/Liiiu/appstore

使用github action保持同步更新。

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

🌍 国外环境请替换为 GitHub 仓库：

```bash
GIT_REPO="https://github.com/willow-god/appstore"
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

如果需要配置对应镜像，请自行创建以上文件。

### 2️⃣ 配置文本

```ini
# ====== GHCR (GitHub Container Registry) ======
# 是否经常被墙：是
GHCR_ENABLE=false
GHCR_MIRROR=ghcr.io

# ====== Quay.io (RedHat/Community images) ======
# 是否经常被墙：是
QUAY_ENABLE=false
QUAY_MIRROR=quay.io

# ====== GCR (Google Container Registry) ======
# 是否经常被墙：是
GCR_ENABLE=false
GCR_MIRROR=gcr.io

# ====== k8s.gcr.io (旧 Kubernetes 镜像仓库) ======
# 是否经常被墙：是
K8S_GCR_ENABLE=false
K8S_GCR_MIRROR=k8s.gcr.io

# ====== registry.k8s.io (新 Kubernetes 镜像仓库) ======
# 是否经常被墙：是
K8S_REG_ENABLE=false
K8S_REG_MIRROR=registry.k8s.io
```

> 💡 **说明**：
>
> - `*_ENABLE` 为 `true` 时才会进行替换。
> - `*_MIRROR` 填写你可用的镜像源地址。
> - 不存在该配置文件时，脚本会跳过替换步骤，不会影响后续流程。

### 3️⃣ 自动替换逻辑

> 该部分无需配置，仅供说明脚本的绿色性质，替换脚本开源于非docker.io镜像中如**MoonTV**仓库，有需要请自行查看

在安装应用之前，脚本会执行 `init.sh`进行镜像源替换：

```bash
#!/bin/bash

# ===== 1. 定义当前应用的镜像类别 =====
# 可选值：ghcr / quay / gcr / k8s_gcr / k8s_reg
MIRROR_TYPE="ghcr"

# ===== 2. 配置文件路径 =====
CONFIG_FILE="/opt/mirror-config.env"

# ===== 3. 检查配置文件是否存在 =====
if [ ! -f "$CONFIG_FILE" ]; then
    echo "未找到配置文件 $CONFIG_FILE，跳过镜像替换步骤。"
else
    # ===== 4. 加载配置文件 =====
    set -a
    source "$CONFIG_FILE"
    set +a

    # ===== 5. 根据镜像类别获取变量 =====
    case "$MIRROR_TYPE" in
        ghcr)
            ENABLE_VAR="$GHCR_ENABLE"
            OLD_DOMAIN="ghcr.io"
            NEW_DOMAIN="$GHCR_MIRROR"
            ;;
        quay)
            ENABLE_VAR="$QUAY_ENABLE"
            OLD_DOMAIN="quay.io"
            NEW_DOMAIN="$QUAY_MIRROR"
            ;;
        gcr)
            ENABLE_VAR="$GCR_ENABLE"
            OLD_DOMAIN="gcr.io"
            NEW_DOMAIN="$GCR_MIRROR"
            ;;
        k8s_gcr)
            ENABLE_VAR="$K8S_GCR_ENABLE"
            OLD_DOMAIN="k8s.gcr.io"
            NEW_DOMAIN="$K8S_GCR_MIRROR"
            ;;
        k8s_reg)
            ENABLE_VAR="$K8S_REG_ENABLE"
            OLD_DOMAIN="registry.k8s.io"
            NEW_DOMAIN="$K8S_REG_MIRROR"
            ;;
        *)
            echo "未知的 MIRROR_TYPE: $MIRROR_TYPE"
            ;;
    esac

    # ===== 6. 检查是否启用镜像替换 =====
    if [ "$ENABLE_VAR" == "true" ]; then
        # ===== 7. 检查 docker-compose 文件 =====
        if [ -f "./docker-compose.yml" ]; then
            COMPOSE_FILE="./docker-compose.yml"
        elif [ -f "./docker-compose.yaml" ]; then
            COMPOSE_FILE="./docker-compose.yaml"
        else
            echo "未找到 docker-compose 文件，跳过替换。"
            COMPOSE_FILE=""
        fi

        # ===== 8. 执行替换 =====
        if [ -n "$COMPOSE_FILE" ]; then
            echo "开始替换 $OLD_DOMAIN -> $NEW_DOMAIN ..."
            if sed -i "s|$OLD_DOMAIN|$NEW_DOMAIN|g" "$COMPOSE_FILE"; then
                echo "成功: 已将 $OLD_DOMAIN 替换为 $NEW_DOMAIN"
            else
                echo "错误: 替换镜像源地址失败"
            fi
        fi
    else
        echo "镜像替换未启用（$MIRROR_TYPE）"
    fi
fi

# ===== 9. 后续其他步骤 =====
echo "这里执行 init.sh 的其他操作..."
```

这样即使镜像源被墙，也能快速替换为你配置的加速地址。

> **目前已知问题**：由于镜像名称的变化，导致在卸载时如果选择删除镜像，可能会无法匹配上，所以需要在1Panel面板右侧容器，镜像中手动删除。

---

## 📮 问题反馈

如发现配置错误或希望新增应用，欢迎在 Issues 区提交反馈：

- 🛠 [本仓库 Issues](https://github.com/willow-god/appstore/issues)

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
