#!/bin/bash
# =========================================
# init.sh
# 功能：初始化 MoonTV 数据目录权限，确保 Kvrocks 容器可写
# =========================================

# 项目数据目录
DATA_DIR="./data"

# Kvrocks 容器默认用户 UID/GID
KVROCKS_UID=999    # 可根据实际情况调整
KVROCKS_GID=999

# 创建目录（如果不存在）
if [ ! -d "$DATA_DIR" ]; then
  echo "📁 创建数据目录: $DATA_DIR"
  mkdir -p "$DATA_DIR"
fi

# 设置属主
echo "🛠 设置属主为 UID:$KVROCKS_UID GID:$KVROCKS_GID"
sudo chown -R $KVROCKS_UID:$KVROCKS_GID "$DATA_DIR"

# 设置权限 0777
echo "🔑 设置目录权限为 0777"
chmod -R 0777 "$DATA_DIR"

echo "✅ 初始化完成，目录权限已配置为可写"
ls -ld "$DATA_DIR"
