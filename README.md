# Dockerized NestJS Application

A production-ready, dockerized NestJS application with modern development practices.

## Features

- 🚀 **NestJS Framework** - Progressive Node.js framework for building efficient and scalable server-side applications
- 📦 **pnpm Package Manager** - Fast, disk space efficient package manager with strict dependency resolution
- 🐳 **Docker Support** - Multi-stage Docker builds for development and production
- 🔧 **Docker Compose** - Easy orchestration of services
- 🧪 **Testing** - Unit and E2E tests with Jest
- 📏 **Code Quality** - ESLint and Prettier for code formatting and linting
- 🔥 **Hot Reload** - Development environment with hot reload
- 🏥 **Health Checks** - Built-in health check endpoint
- 🔒 **Security** - Non-root user in production container
- 📚 **API Documentation** - OpenAPI/Swagger specification for all endpoints

## Quick Start

> 💡 **Having issues?** Check our [Setup Issues and Troubleshooting Guide](SETUP-ISSUES.md) for common problems and solutions.

### Using Docker Compose (Recommended)

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd dockerized-nestjs
   ```

2. **Development environment**

   ```bash
   # Build and start the development environment
   docker-compose -f docker-compose.dev.yml up --build

   # The application will be available at http://localhost:3000
   ```

3. **Production environment**

   ```bash
   # Build and start the production environment
   docker-compose up --build

   # The application will be available at http://localhost:3000
   ```

### Using Docker directly

1. **Build the image**

   ```bash
   docker build -t nestjs-app .
   ```

2. **Run the container**
   ```bash
   docker run -p 3000:3000 nestjs-app
   ```

### Local Development (without Docker)

1. **Install dependencies**

   ```bash
   pnpm install
   ```

2. **Start development server**
   ```bash
   pnpm run start:dev
   ```

## Available Scripts

- `pnpm run build` - Build the application
- `pnpm run start` - Start the application
- `pnpm run start:dev` - Start in development mode with hot reload
- `pnpm run start:debug` - Start in debug mode
- `pnpm run start:prod` - Start in production mode
- `pnpm run test` - Run unit tests
- `pnpm run test:e2e` - Run end-to-end tests
- `pnpm run test:cov` - Run tests with coverage
- `pnpm run lint` - Lint the code
- `pnpm run format` - Format the code

## API Endpoints

The API endpoints are documented using OpenAPI 3.0 specification. You can find the complete API documentation in:

📄 **[API Specification (OpenAPI/Swagger)](api-spec.yaml)**

### Quick Reference

| Endpoint      | Method | Description                              |
| ------------- | ------ | ---------------------------------------- |
| `/`           | GET    | Welcome message                          |
| `/api`        | GET    | API welcome message (with global prefix) |
| `/health`     | GET    | Health check endpoint                    |
| `/api/health` | GET    | API health check (with global prefix)    |

### Example Responses

**Welcome Message:**

```
Hello World! This is a dockerized NestJS application.
```

**Health Check:**

```json
{
  "status": "ok",
  "timestamp": "2025-07-17T12:49:37.581Z",
  "uptime": 60.604752004
}
```

### Using the API Specification

You can use the `api-spec.yaml` file with:

- **Swagger UI**: Import the file to visualize and test the API
  - Online: Copy the content to [Swagger Editor](https://editor.swagger.io/)
  - Local: Use `swagger-ui-serve api-spec.yaml` (requires swagger-ui-serve package)
- **Postman**: Import the OpenAPI spec to create a collection
- **Code Generation**: Generate client SDKs using tools like `openapi-generator`
- **API Testing**: Use with testing tools that support OpenAPI specs

> **Tip**: You can also use the Makefile command `make dev-shell` to access the container and serve the API documentation locally.

## Environment Variables

Copy `.env.example` to `.env` and configure the following variables:

- `NODE_ENV` - Environment (development/production)
- `PORT` - Application port (default: 3000)

## Makefile Commands

This project includes a Makefile for easy Docker management. Use `make help` to see all available commands:

```bash
# Show all available commands
make help

# Quick start commands
make start              # Build and start development environment
make stop               # Stop development environment
make restart            # Restart development environment
make rebuild            # Rebuild and restart development environment

# Development commands
make dev-build          # Build development image
make dev-up             # Start development environment
make dev-up-detached    # Start development in background
make dev-down           # Stop development environment
make dev-logs           # Show development logs
make dev-shell          # Access container shell

# Production commands
make prod-build         # Build production image
make prod-up            # Start production environment
make prod-up-detached   # Start production in background
make prod-down          # Stop production environment

# Testing commands
make test               # Run unit tests
make test-e2e           # Run e2e tests
make test-watch         # Run tests in watch mode
make test-cov           # Run tests with coverage

# Utility commands
make health             # Check application health
make clean              # Clean up containers and volumes
make clean-all          # Clean up everything including images
make lint               # Run linter
make format             # Format code

# NestJS CLI commands
make nest-info          # Show NestJS project information
make nest-version       # Show NestJS CLI version
make nest-generate-controller NAME=users    # Generate a controller
make nest-generate-service NAME=users       # Generate a service
make nest-generate-module NAME=users        # Generate a module
make nest-generate-resource NAME=users      # Generate a complete CRUD resource
make nest-cli CMD="info"                    # Run custom NestJS CLI command
```

### NestJS Code Generation

You can use the NestJS CLI through Docker to generate components:

```bash
# Generate specific components
make nest-generate-controller NAME=users
make nest-generate-service NAME=auth
make nest-generate-module NAME=products

# Generate a complete CRUD resource (includes controller, service, module, DTOs, entities)
make nest-generate-resource NAME=posts

# Run any NestJS CLI command
make nest-cli CMD="generate guard auth"
make nest-cli CMD="generate interceptor logging"

# Get project information
make nest-info
```

**Available NestJS generators:**

- `controller` - Generate a controller
- `service` - Generate a service
- `module` - Generate a module
- `guard` - Generate a guard
- `interceptor` - Generate an interceptor
- `pipe` - Generate a pipe
- `filter` - Generate a filter
- `decorator` - Generate a custom decorator
- `gateway` - Generate a WebSocket gateway
- `resolver` - Generate a GraphQL resolver
- `resource` - Generate a complete CRUD resource

## Docker Commands (Manual)

### Development

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up

# Rebuild and start
docker-compose -f docker-compose.dev.yml up --build

# Stop services
docker-compose -f docker-compose.dev.yml down
```

### Production

```bash
# Start production environment
docker-compose up

# Rebuild and start
docker-compose up --build

# Stop services
docker-compose down
```

## Project Structure

```
src/
├── app.controller.ts    # Main application controller
├── app.controller.spec.ts # Controller tests
├── app.module.ts        # Root application module
├── app.service.ts       # Main application service
└── main.ts             # Application entry point

test/
├── app.e2e-spec.ts     # End-to-end tests
└── jest-e2e.json       # E2E test configuration

Docker files:
├── Dockerfile          # Multi-stage Docker build
├── docker-compose.yml  # Production environment
├── docker-compose.dev.yml # Development environment
└── .dockerignore       # Docker ignore rules

Documentation:
├── README.md           # Project documentation
├── SETUP-ISSUES.md     # Setup troubleshooting guide
└── api-spec.yaml       # OpenAPI/Swagger API specification
```

## Troubleshooting

If you encounter any issues during setup or development, please refer to our comprehensive troubleshooting guide:

📋 **[Setup Issues and Troubleshooting Guide](SETUP-ISSUES.md)**

This document covers:

- Common Docker configuration issues
- Dependency management problems
- TypeScript compilation errors
- ESLint and testing setup issues
- Development environment troubleshooting
- Best practices and lessons learned

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is [MIT licensed](LICENSE).
