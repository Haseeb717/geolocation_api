# Geolocation App

Welcome to the Geolocation App! This application allows users to fetch and manage geolocation data using a robust API.

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setting Up the Environment](#setting-up-the-environment)
  - [Running the Application](#running-the-application)
    - [Without Docker](#without-docker)
    - [With Docker](#with-docker)
- [API Documentation](#api-documentation)
- [Testing](#run-tests)

## Features
- User registration and authentication
- API key management
- Geolocation fetching based on user input
- Swagger documentation for the API

## Technologies Used
- Ruby on Rails
- PostgreSQL
- RSpec for testing
- Docker for containerization
- Swagger for API documentation

## Getting Started

### Prerequisites
To run this application, you'll need:
- Ruby (version 3.2.0)
- Rails (version 7.0.8)
- PostgreSQL (version 14)
- Docker

## Setting Up the Environment
### 1. Clone the Repository
```sh
git clone https://github.com/Haseeb717/geolocation_api
cd geolocation_app
```

### 2. Configure Environment Variables
Copy the example environment variables file and edit it with your Stripe credentials:

```sh
cp .env_example .env
```
Edit .env with your Stripe keys:

**IPSTACK_API_KEY**: Your IPSTACK api key. You can get it from api-keys on [IPSTACK website](https://ipstack.com/)
**DATABASE_USERNAME**:
**DATABASE_PASSWORD**:
**DATABASE_NAME**:
**DATABASE_HOST**:


## Running the Application 
### Without Docker

### 1. Install Dependencies
```sh
bundle install
```

### 2. Database configuration
```sh
rails db:create
rails db:migrate
```

### 3. Rails Server

Run the rails server on console with port 3000:

```sh
rails s -p 3000
```

### With Docker

### 1. Build the Docker image:
```sh 
  docker-compose build
```

### 2. Start the containers:
```sh
docker-compose up
```

### 3. Run database migrations:
```sh 
docker-compose run web rails db:create
docker-compose run web rails db:migrate
```

Access the application: Open your browser and go to http://localhost:3000.

### API Documentation
The API documentation is available via Swagger. You can access it at [http://localhost:3000/api-docs](Swagger-Api-docs) after starting the application. This documentation includes all the available endpoints and their usage.

### Run Tests

Execute the test suite:

```sh 
bundle exec rspec
```
