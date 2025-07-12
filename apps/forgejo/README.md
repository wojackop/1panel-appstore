# Forgejo

Forgejo 是一个 **社区驱动** 的代码托管平台，源自 Gitea 的分支，主打 **自由、去中心化与透明协作**。它支持自托管，具备 Git 仓库管理、Issue 跟踪、Pull Request、CI/CD 等完整功能，适合个人开发者、小团队或企业部署使用。

## ✨ 特性

- 自托管 Git 服务
- 支持 Pull Request、Issue、Wiki、Releases 等
- 支持 Web 界面和 Git 命令操作
- 内置 CI/CD 工作流（Actions）
- 活跃的社区与持续更新
- 支持多架构部署（`amd64` / `arm64`）

## 📚 文档与链接

- 官网：🌐 [https://forgejo.org](https://forgejo.org/)
- 文档：📘 https://forgejo.org/docs/
- 源码：🧑‍💻 https://code.forgejo.org/forgejo/forgejo

## 🐳 Docker 部署（示例）

```bash
docker run -d --name forgejo \
  -p 3000:3000 -p 222:22 \
  -v /opt/forgejo:/data \
  codeberg.org/forgejo/forgejo:latest
```

> 默认 Web 端口为 `3000`，SSH 为 `222`，可根据需求修改。

## 🧑‍🤝‍🧑 关于 Forgejo

Forgejo 旨在成为一个真正由社区掌控的开源项目，强调协作、公平治理，并鼓励开发者共建更加开放的代码托管生态。
