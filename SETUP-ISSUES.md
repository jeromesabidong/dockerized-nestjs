# Setup Issues and Troubleshooting Guide

> **📦 Note**: This project has been migrated from npm to pnpm. The issues below are historical and documented for reference. Current setup uses pnpm as the package manager. See [PNPM-MIGRATION.md](PNPM-MIGRATION.md) for migration details.

This document outlines all the issues encountered during the scaffolding and setup of the Dockerized NestJS application, along with their solutions. This serves as a reference for future development and troubleshooting.

## Table of Contents

1. [Initial Setup Issues](#initial-setup-issues)
2. [Docker Configuration Issues](#docker-configuration-issues)
3. [Dependency Management Issues](#dependency-management-issues)
4. [TypeScript Configuration Issues](#typescript-configuration-issues)
5. [Testing and Linting Issues](#testing-and-linting-issues)
6. [Development Environment Issues](#development-environment-issues)
7. [Lessons Learned](#lessons-learned)

---

## Initial Setup Issues

### Issue 1: Empty Workspace

**Problem**: Starting with a completely empty workspace with no existing project structure.

**Solution**:

- Created complete NestJS project structure from scratch
- Scaffolded all necessary files including source code, configuration, and Docker files
- Set up proper directory structure following NestJS conventions

**Files Created**:

```
src/
├── main.ts
├── app.module.ts
├── app.controller.ts
├── app.service.ts
└── app.controller.spec.ts
test/
├── app.e2e-spec.ts
└── jest-e2e.json
```

---

## Docker Configuration Issues

### Issue 2: Node.js Version Compatibility

**Problem**: Initial Dockerfile used outdated Node.js version that caused compatibility issues with modern npm.

**Error**:

```
npm install commands failing with package resolution errors
```

**Solution**:

- Updated Dockerfile to use Node.js 20 Alpine image
- Ensured compatibility with modern npm versions (>=9.0.0)

**Before**:

```dockerfile
FROM node:16-alpine
```

**After**:

```dockerfile
FROM node:20-alpine
```

### Issue 3: Docker Compose Version Field

**Problem**: Docker Compose files included deprecated `version` field causing warnings.

**Error**:

```
WARN[0000] The "version" field is deprecated and will be removed in a future Docker Compose version
```

**Solution**:

- Removed `version: '3.8'` from both `docker-compose.yml` and `docker-compose.dev.yml`
- Modern Docker Compose doesn't require version specification

### Issue 4: npm Install Strategy in Docker

**Problem**: Inconsistent npm install commands between development and production stages.

**Error**:

```
failed to solve: process "/bin/sh -c npm ci --only=development" did not complete successfully: exit code: 1
```

**Solution**:

- Updated development stage to use `npm install` for flexibility
- Updated production stage to use `npm ci --omit=dev` for reproducible builds
- Ensured package-lock.json exists for consistent dependency resolution

**Fixed Dockerfile**:

```dockerfile
# Development stage
RUN npm install

# Production stage
RUN npm ci --omit=dev && npm cache clean --force
```

---

## Dependency Management Issues

### Issue 5: Package Version Conflicts

**Problem**: `tsconfig-paths` package had version conflicts in package.json.

**Error**:

```
npm ERR! Could not resolve dependency:
npm ERR! peer tsconfig-paths@"^4.1.0" from package.json
```

**Solution**:

- Updated `tsconfig-paths` version to `^4.1.0` in package.json
- Regenerated package-lock.json with `npm install --package-lock-only`

### Issue 6: Missing package-lock.json

**Problem**: No package-lock.json file for reproducible Docker builds.

**Error**:

```
Docker build failing due to inconsistent dependency resolution
```

**Solution**:

- Generated package-lock.json using `npm install --package-lock-only`
- Ensured lockfile is included in Docker builds for consistency

### Issue 7: Local Development Dependencies

**Problem**: TypeScript compilation errors in local environment due to missing dependencies.

**Error**:

```
Cannot find module '@nestjs/core' or its corresponding type declarations
Cannot find name 'process'. Do you need to install type definitions for node?
```

**Solution**:

- Ran `npm install` locally to install all dependencies
- Verified all NestJS and TypeScript packages were properly installed
- Ensured `@types/node` was available for Node.js type definitions

---

## TypeScript Configuration Issues

### Issue 8: TypeScript Module Resolution

**Problem**: TypeScript compiler not recognizing NestJS modules and Node.js types.

**Error**:

```
Cannot find module '@nestjs/common' or its corresponding type declarations
Cannot find name 'process'
```

**Solution**:

- Verified tsconfig.json configuration was correct
- Installed all dependencies locally with `npm install`
- Confirmed TypeScript compilation works with `npx tsc --noEmit`

**Working tsconfig.json**:

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2020",
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": "./",
    "incremental": true,
    "skipLibCheck": true,
    "strictNullChecks": false,
    "noImplicitAny": false,
    "strictBindCallApply": false,
    "forceConsistentCasingInFileNames": false,
    "noFallthroughCasesInSwitch": false
  }
}
```

---

## Testing and Linting Issues

### Issue 9: ESLint Configuration Problems

**Problem**: ESLint couldn't find TypeScript configuration to extend from.

**Error**:

```
ESLint couldn't find the config "@typescript-eslint/recommended" to extend from
```

**Solution**:

- Updated `.eslintrc.js` to use correct configuration format
- Changed from `@typescript-eslint/recommended` to `plugin:@typescript-eslint/recommended`

**Fixed .eslintrc.js**:

```javascript
extends: [
  'plugin:@typescript-eslint/recommended',
  'plugin:prettier/recommended',
],
```

### Issue 10: TypeScript Version Warning

**Problem**: ESLint TypeScript plugin warning about unsupported TypeScript version.

**Warning**:

```
WARNING: You are currently running a version of TypeScript which is not officially supported
SUPPORTED TYPESCRIPT VERSIONS: >=4.3.5 <5.4.0
YOUR TYPESCRIPT VERSION: 5.8.3
```

**Solution**:

- Acknowledged this is a non-blocking warning
- Verified all functionality works despite the version mismatch
- Noted for future dependency updates

---

## Development Environment Issues

### Issue 11: VS Code TypeScript Server Cache

**Problem**: VS Code showing TypeScript errors even after dependencies were installed.

**Symptoms**:

- Red underlines in TypeScript files
- Module not found errors in editor
- Compilation works in terminal but not in VS Code

**Solution**:

- Dependencies installation resolved the underlying issues
- TypeScript compiler verification showed no actual errors
- VS Code eventually recognized the correct module resolution

### Issue 12: Docker Build Caching

**Problem**: Docker build process was slow due to inefficient layer caching.

**Solution**:

- Structured Dockerfile to optimize layer caching
- Copy package files before source code
- Use multi-stage build for production optimization

**Optimized Dockerfile Structure**:

```dockerfile
# Copy package files first for better caching
COPY package*.json ./
RUN npm install

# Copy source code after dependencies
COPY . .
```

---

## Development Workflow Issues

### Issue 13: Hot Reload in Development

**Problem**: Need for efficient development workflow with hot reload.

**Solution**:

- Created separate `docker-compose.dev.yml` for development
- Configured NestJS to run with `--watch` flag in development
- Set up volume mounts for live code reloading

**Development Configuration**:

```yaml
command: npm run start:dev
volumes:
  - .:/app
  - /app/node_modules
```

### Issue 14: Build Task Integration

**Problem**: No VS Code build tasks for easy Docker management.

**Solution**:

- Created VS Code tasks.json for Docker Compose operations
- Added build and run tasks for development workflow
- Integrated with VS Code's task runner system

---

## Lessons Learned

### Best Practices Identified

1. **Dependency Management**
   - Always include package-lock.json in version control
   - Use `npm ci` in production for reproducible builds
   - Install dependencies locally even when using Docker

2. **Docker Configuration**
   - Use multi-stage builds for production optimization
   - Structure Dockerfile layers for optimal caching
   - Remove deprecated Docker Compose version fields

3. **TypeScript Setup**
   - Ensure all type definitions are properly installed
   - Use consistent TypeScript configuration
   - Verify compilation works both locally and in Docker

4. **Development Workflow**
   - Separate development and production Docker configurations
   - Use Makefile for common Docker operations
   - Implement proper hot reload for development

5. **Testing Strategy**
   - Set up both unit and e2e tests from the beginning
   - Ensure test configuration works in Docker environment
   - Verify all tests pass before deployment

### Common Pitfalls to Avoid

1. **Version Mismatches**: Keep Node.js, npm, and package versions consistent
2. **Missing Dependencies**: Don't rely solely on Docker; install locally too
3. **Configuration Drift**: Keep development and production configs synchronized
4. **Build Optimization**: Don't ignore Docker layer caching opportunities
5. **Tool Updates**: Stay aware of deprecation warnings in build tools

---

## Quick Reference

### Commands for Troubleshooting

```bash
# Verify TypeScript compilation
npx tsc --noEmit

# Check dependency installation
npm list --depth=0

# Test Docker build
docker-compose -f docker-compose.dev.yml build

# Run tests
npm test && npm run test:e2e

# Check linting
npm run lint

# Format code
npm run format
```

### Common Error Patterns

| Error Pattern                    | Likely Cause         | Solution                           |
| -------------------------------- | -------------------- | ---------------------------------- |
| `Cannot find module '@nestjs/*'` | Missing dependencies | Run `npm install`                  |
| `Cannot find name 'process'`     | Missing @types/node  | Install Node.js types              |
| `ESLint couldn't find config`    | Wrong ESLint config  | Update .eslintrc.js                |
| `npm ci failed`                  | Missing lockfile     | Generate package-lock.json         |
| `Docker build failed`            | Dockerfile issues    | Check Node.js version and commands |

---

_This document is maintained as issues are discovered and resolved. Last updated: July 17, 2025_
