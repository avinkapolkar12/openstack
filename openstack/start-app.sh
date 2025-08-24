#!/bin/bash

# Start the Dummy App in production mode
echo "Starting Dummy App..."

# Check if docker-compose.prod.yml exists
if [ ! -f "docker-compose.prod.yml" ]; then
    echo "Error: docker-compose.prod.yml not found!"
    echo "Make sure you're in the correct directory."
    exit 1
fi

# Pull latest images
echo "Pulling latest images..."
docker-compose -f docker-compose.prod.yml pull

# Start the application
echo "Starting application containers..."
docker-compose -f docker-compose.prod.yml up -d

# Show status
echo "Application started! Checking status..."
docker-compose -f docker-compose.prod.yml ps

# Get VM IP
VM_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "=== Application URLs ==="
echo "Frontend: http://$VM_IP"
echo "Backend API: http://$VM_IP:5000"
echo "Health Check: http://$VM_IP:5000/api/health"
echo ""
echo "To view logs: docker-compose -f docker-compose.prod.yml logs"
echo "To stop: ./stop-app.sh"
