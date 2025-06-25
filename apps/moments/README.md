# Moments

**Moments** 是一个极简、优雅的朋友圈发布平台，支持匿名记录与自托管部署。你可以将它作为一个轻量级的生活动态记录系统，用于分享、回顾和整理自己的片段思考或生活点滴。

### ✨ 特性亮点

- 📝 极简 UI，专注内容发布
- 🔐 支持 JWT 鉴权，确保内容私密
- 💾 本地持久化，无需数据库
- 🚀 支持 Docker 一键部署
- 🧑‍💻 支持自定义主题与开放 API

### 🚀 快速启动

使用 Docker 快速部署：

```
bash复制编辑docker run -d \
  -p 3000:3000 \
  -v /your/data/path:/app/data \
  -e JWT_KEY=your_secret \
  --name moments \
  kingwrcy/moments:latest
```

浏览器访问：http://localhost:3000