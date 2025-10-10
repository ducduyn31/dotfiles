# Rose Profile

The **rose** profile is a comprehensive development environment designed for full-stack software engineering work. It provides a complete toolkit for modern application development across multiple languages and platforms.

## Features

### Development Languages & Runtimes

- **Java**: OpenJDK 21 (headless)
- **JavaScript/TypeScript**: pnpm, volta (Node.js version manager), bun
- **Python**: pyenv, Python 3, poetry, uv
- **Go**: Full Go toolchain with development tools

### Development Tools

- **Frontend**: Supabase CLI, Codex
- **AI/Code Assistance**: Claude Code
- **Go Development**: air (hot reload), gotestsum, delve (debugger), golangci-lint, go-mockery, go-swag
- **API Documentation**: Redocly, CUE

### Cloud & Infrastructure

- **Cloud Providers**: AWS CLI v2, Azure CLI, Google Cloud SDK (with GKE auth plugin)
- **Infrastructure as Code**: Terraform, Pulumi (with Node.js support), tflint
- **Container Management**: Orbstack, Docker Compose
- **Kubernetes**: kubectl, k9s, stern, kubectx
- **AWS**: SSM Session Manager Plugin

### Security & Analysis

- **Security Tools**: Sherlock (OSINT), exiftool
- **Code Quality**: Various linters and formatters per language

### Streaming & Productivity

- **Presentation**: KeyCastr (keystroke visualization)
- **Utilities**: Perl, various system tools

### GUI Applications

- **Productivity**: Obsidian (note-taking)
- **System Maintenance**: AppCleaner
- **Development**: Docker Desktop

## Target Use Cases

This profile is ideal for:

- Full-stack web development
- Cloud-native application development
- DevOps and infrastructure automation
- Multi-language project development
- Security research and analysis
- Live coding/streaming

## System Requirements

- Apple Silicon Mac (aarch64-darwin)
- macOS with Nix package manager
- Homebrew (automatically managed via nix-homebrew)

## Configuration Notes

- Go workspace configured with `~/go` as GOPATH
- Automatic garbage collection disabled for Nix
- Home Manager integration for user-level package management

