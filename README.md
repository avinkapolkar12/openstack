# Dummy App

A simple three-tier application demonstrating client-server-database architecture with Docker containerization.

## Architecture

- **Client**: React.js frontend with user interface
- **Server**: Node.js/Express.js REST API backend
- **Database**: PostgreSQL database

## Features

- Add and view users
- REST API endpoints
- Database persistence
- Docker containerization
- Health checks

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Node.js (for local development)

### Running with Docker

1. Clone this repository
2. Navigate to the project directory
3. Run the application:

```bash
docker-compose up --build
```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000
   - Database: localhost:5432

### API Endpoints

- `GET /api/health` - Health check
- `GET /api/users` - Get all users
- `POST /api/users` - Create a new user

### Local Development

#### Server

```bash
cd server
npm install
npm run dev
```

#### Client

```bash
cd client
npm install
npm start
```

## Docker Commands

Build and run:

```bash
docker-compose up --build
```

Run in background:

```bash
docker-compose up -d
```

Stop containers:

```bash
docker-compose down
```

View logs:

```bash
docker-compose logs
```

## OpenStack Deployment

1. Build the Docker image
2. Push to a container registry
3. Deploy to OpenStack using the provided instructions

## Environment Variables

### Server

- `PORT` - Server port (default: 5000)
- `DB_HOST` - Database host
- `DB_PORT` - Database port
- `DB_NAME` - Database name
- `DB_USER` - Database user
- `DB_PASSWORD` - Database password

### Client

- `REACT_APP_API_URL` - Backend API URL
