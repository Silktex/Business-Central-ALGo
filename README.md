# Business Central AL Project with AL-Go CI/CD

This repository contains a comprehensive Business Central AL extension project with full CI/CD automation powered by Microsoft AL-Go for GitHub.

## 🏢 Project Overview

**Silktex Business Central Extensions** - A complete Business Central solution featuring:
- 730+ AL source files including codeunits, pages, tables, reports, and more
- CRM Contact Interaction capabilities
- Integration with FedEx/UPS shipping
- Advanced inventory management
- E-commerce portal integration
- Automated reporting and analytics

## 🚀 AL-Go CI/CD Features

This project leverages Microsoft AL-Go for GitHub to provide:
- **Automated Builds** on every commit
- **Continuous Integration** with automated testing
- **Release Management** with semantic versioning
- **Environment Deployment** to sandbox and production
- **Artifact Publishing** to storage accounts
- **Quality Gates** with code analysis

## 📁 Project Structure

```
├── src/                          # AL source code (730+ files)
│   ├── Codeunit/                # Business logic and integrations
│   ├── Page/                    # User interface pages
│   ├── Table/                   # Database tables and extensions
│   ├── Report/                  # RDLC and Excel reports
│   └── ...                      # Enums, Queries, XMLports
├── .github/workflows/           # AL-Go CI/CD workflows
├── .alpackages/                 # Business Central dependencies
├── artifacts/                   # Built app packages
└── app.json                     # Application manifest
```

## 🛠️ Development Workflow

### Local Development
1. Clone the repository
2. Open in VS Code with AL Language extension
3. Download symbols: `Ctrl+Shift+P` → `AL: Download Symbols`
4. Start developing your features

### CI/CD Pipeline
- **Push to main**: Triggers full CI/CD pipeline
- **Pull Requests**: Automated validation and testing
- **Releases**: Automated deployment to configured environments

## 📋 Available AL-Go Workflows

| Workflow | Purpose |
|----------|---------|
| **CI/CD** | Build, test, and deploy on push |
| **Create Release** | Generate versioned releases |
| **Add Existing App** | Import external AL apps |
| **Create App** | Generate new AL application |
| **Publish to Environment** | Deploy to BC environments |

## 🔧 Configuration

Key configuration files:
- `.AL-Go/settings.json` - AL-Go project settings
- `app.json` - AL application configuration
- `.github/AL-Go-Settings.json` - Repository-level settings

## 🚀 Getting Started

1. **Fork or clone** this repository
2. **Configure environments** in AL-Go settings
3. **Set up secrets** for deployment (optional)
4. **Start developing** your AL extensions
5. **Push changes** to trigger automated builds

## 📚 Documentation

- [AL-Go for GitHub Documentation](https://aka.ms/AL-Go)
- [Business Central AL Development](https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/)
- [AL Language Reference](https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-reference-overview)

## 🤝 Contributing

This project follows AL-Go best practices for collaborative development:
1. Create feature branches from `main`
2. Make your changes and test locally
3. Submit pull requests for review
4. Automated workflows validate all changes

## 📊 Project Status

![CI/CD Status](https://github.com/Silktex/Business-Central-ALGo/workflows/CI%2FCD/badge.svg)

- **AL-Go Version**: Latest
- **Business Central**: v26+ compatible
- **Source Files**: 730+ AL objects
- **Last Updated**: September 2025

---

*This repository was migrated from a traditional AL project to AL-Go while preserving complete git history and all development artifacts.*
