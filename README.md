# GitHub Actions Runner

Simple repository for spinning up Self-Hosted GitHub Actions runner for organizations.

## Prerequisites

1. You must have Admin access to your organization
2. [Docker](https://docker.com) (or a compose compatible alternative)

## How-To

1. Create a personal access token with the `Self-Hosted runner` scope and write-access.
2. Copy the [.env.example](.env.example) file, rename it to `.env` and fill out the required fields.
3. Adjust the [Docker Compose](./docker-compose.yml) file.
4. Run `docker compose up -d` and enjoy your runners.
