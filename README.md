# Webhook Management System

A Ruby on Rails API for managing webhooks with secure delivery and event tracking.

[![Ruby](https://img.shields.io/badge/Ruby-3.3.5-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.0.0-red.svg)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Latest-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Features](#features)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [API Documentation](#api-documentation)

## Features

- 🔐 **Secure Authentication**
  - JWT-based authentication
  - User registration and login
  - Password encryption with BCrypt

- 🔄 **Webhook Management**
  - Create, read, update, and delete webhooks
  - Automatic secret generation
  - URL validation and health checks
  - Active/inactive status control

- 📨 **Event Delivery**
  - Asynchronous processing with Sidekiq
  - Automatic retries with exponential backoff
  - HMAC signature verification

## System Requirements

- Ruby 3.3.5
- Rails 8.0.0
- PostgreSQL 14+
- Redis 7+

## Setup

1. **Clone the repository**:
```bash
git clone https://github.com/elarabyelaidy19/webhook-system.git
cd webhook-system
```

2. **Install dependencies**:
- build
```bash
make build
```

- run
```bash
make up
```


## Configuration

- Create a `.env` file and set the necessary environment variables.
- Use the provided `.env.example` as a template.


## API Documentation

## API Endpoints

### Authentication

- **Sign Up**: `POST /auth/signup`
- **Login**: `POST /auth/login`

### Webhooks

`Authorization: Bearer <token>`

- **List Webhooks**: `GET /webhooks`
- **Create Webhook**: `POST /webhooks`
- **Get Webhook**: `GET /webhooks/:id`
- **Update Webhook**: `PUT /webhooks/:id`
- **Delete Webhook**: `DELETE /webhooks/:id`