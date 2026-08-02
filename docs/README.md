# Webapp dev skeleton

Monorepo-style project with separated backend, frontend, documentation, and infrastructure code.

## Purpose

This repository is prepared for the any  application and currently contains:

- Symfony/PHP backend application in `apps/api`
- Frontend application in `apps/frontend`
- Project documentation in `docs`
- Docker and infrastructure configuration in `ops`
- Root `Makefile` shortcuts for local development and quality tools

The project keeps application code, documentation, and infrastructure concerns separated so the repository can grow in a clean and maintainable way.

## Project structure

```text
.
├── apps/
│   ├── api/
│   └── frontend/
├── docs/
│   ├── hostcreators/
│   ├── README.md
│   └── tictets/
├── ops/
│   ├── compose/
│   │   ├── nginx/
│   │   └── docker-compose.dev.yml
│   └── dockerfiles/
└── Makefile
```

## Directory overview

### `apps/`

Application source code lives here.

#### `apps/api`

Backend application directory.

This folder contains the Symfony/PHP backend application, including:

- application source code
- configuration
- migrations
- tests
- Behat features
- public entry point
- templates and translations
- Composer dependencies

#### `apps/frontend`

Frontend application directory.

This folder contains nothing for now, but it is ready enviroment for any js framework

## Documentation

Project documentation lives in `docs`.

```text
docs/
├── hostcreators/
│   └── pipeline_steps_prod.txt
├── README.md
└── tictets/
    ├── BUG.md
    ├── TASK.md
    └── USER_STORY.md
```

### `docs/README.md`

General documentation index or overview for the project.

Use this file to explain what documentation exists and where developers should look first.

### `docs/hostcreators/`

Contains deployment and production build steps for hosting on HostCreators.

This documentation describes how to build and deploy the whole application, including backend setup, frontend build, database migrations, and other production-related steps.

Deployment is automatically triggered when changes are pushed to the `master` branch.


Current file:

```text
docs/hostcreators/pipeline_steps_prod.txt
```

### `docs/tickets/`

Contains basic ticket templates and work item structure for the project.

This folder is used to keep a consistent format for describing bugs, tasks, and user stories before implementation.

Current templates:

- `BUG.md`
- `TASK.md`
- `USER_STORY.md`

## Operations and infrastructure

Infrastructure-related files live in `ops`.

```text
ops/
├── compose/
│   ├── docker-compose.dev.yml
│   └── nginx/
└── dockerfiles/
    ├── api.Dockerfile
    └── frontend.Dockerfile
```

### `ops/compose`

Docker Compose configuration and local service configuration.

Main development compose file:

```text
ops/compose/docker-compose.dev.yml
```

### `ops/compose/nginx`

nginx configuration used by the local development environment.

### `ops/dockerfiles`

Dockerfiles for application containers.

Current Dockerfiles:

- `api.Dockerfile`
- `frontend.Dockerfile`

## Makefile

The root `Makefile` provides shortcuts for common development commands.

Common commands may include:

```bash
make start
make stop
make restart
make build
make rebuild
make bash
make fe-bash
make phpstan
make rector
make rector-fix
make cs-fix
make cs-fix-apply
make qa
make help
```

Run this command to see the available commands in your local project:

```bash
make help
```

## Backend development

The backend application is located in:

```text
apps/api
```

Typical backend work should happen inside the backend container or local PHP environment, depending on your setup.

Useful backend paths:

```text
apps/api/src
apps/api/config
apps/api/migrations
apps/api/tests
apps/api/features
```

### Quality tools

The project Makefile may provide shortcuts for backend quality tools such as:

- PHPStan
- Rector
- PHP-CS-Fixer
- PHPUnit
- Behat

Recommended general workflow:

```bash
make qa
```

## Frontend development

The frontend application is located in:

```text
apps/frontend
```

Useful frontend paths:

```text
apps/frontend/src
apps/frontend/dist
apps/frontend/package.json
```

Typical frontend commands should be executed inside the frontend container or local Node.js environment, depending on your setup.

Example:

```bash
make fe-bash
```

## Docker setup

The development environment is based on Docker Compose.

Main compose file:

```text
ops/compose/docker-compose.dev.yml
```

The Docker setup separates runtime infrastructure from application code.

This keeps Docker, nginx, and container definitions outside the `apps` folders.

## Behat and test database setup

If the test database is missing, run these commands from the backend application directory:

```bash
APP_ENV=test php bin/console doctrine:database:create --if-not-exists
APP_ENV=test php bin/console doctrine:migrations:migrate --no-interaction
```

