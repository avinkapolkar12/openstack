#!/bin/bash

# Stop the Dummy App
echo "Stopping Dummy App..."

# Check if docker-compose.prod.yml exists
if [ ! -f "docker-compose.prod.yml" ]; then
    echo "Error: docker-compose.prod.yml not found!"
    echo "Make sure you're in the correct directory."
    exit 1
fi

# Stop the application
docker-compose -f docker-compose.prod.yml down

echo "Application stopped!"
echo ""
echo "To start again: ./start-app.sh"
echo "To view logs: docker-compose -f docker-compose.prod.yml logs"
