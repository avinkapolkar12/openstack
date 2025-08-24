#!/bin/bash

# OpenStack Deployment Script for Dummy App
# Run this script on your Ubuntu VM in VirtualBox

echo "=== OpenStack Dummy App Deployment ==="

# Update system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt install -y docker.io docker-compose
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    echo "Docker installed. Please log out and log back in for group changes to take effect."
fi

# Create application directory
echo "Creating application directory..."
mkdir -p ~/dummy-app
cd ~/dummy-app

# Check if we're pulling from a registry or building locally
if [ "$1" = "build" ]; then
    echo "Building application locally..."
    # Copy your application files here (you would need to transfer them)
    # For now, we'll create a simple setup
    docker-compose up --build -d
else
    echo "Setting up for registry pull..."
    # Create docker-compose for pulling from registry
    cat > docker-compose.prod.yml << 'EOF'
version: '3.8'

services:
  database:
    image: postgres:15-alpine
    container_name: dummy-database-prod
    environment:
      POSTGRES_DB: dummydb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - dummy-network
    restart: unless-stopped

  server:
    image: your-registry/dummy-server:latest  # Replace with your registry
    container_name: dummy-server-prod
    environment:
      - NODE_ENV=production
      - DB_HOST=database
      - DB_PORT=5432
      - DB_NAME=dummydb
      - DB_USER=postgres
      - DB_PASSWORD=password
    ports:
      - "5000:5000"
    depends_on:
      - database
    networks:
      - dummy-network
    restart: unless-stopped

  client:
    image: your-registry/dummy-client:latest  # Replace with your registry
    container_name: dummy-client-prod
    ports:
      - "80:80"
    depends_on:
      - server
    networks:
      - dummy-network
    environment:
      - REACT_APP_API_URL=http://your-openstack-ip:5000
    restart: unless-stopped

volumes:
  postgres_data:

networks:
  dummy-network:
    driver: bridge
EOF

    echo "Production docker-compose created. Update the image URLs in docker-compose.prod.yml"
fi

# Create startup script
cat > start-app.sh << 'EOF'
#!/bin/bash
cd ~/dummy-app
docker-compose -f docker-compose.prod.yml up -d
echo "Application started!"
echo "Access the app at: http://$(hostname -I | awk '{print $1}')"
EOF

chmod +x start-app.sh

# Create stop script
cat > stop-app.sh << 'EOF'
#!/bin/bash
cd ~/dummy-app
docker-compose -f docker-compose.prod.yml down
echo "Application stopped!"
EOF

chmod +x stop-app.sh

echo "=== Deployment setup complete! ==="
echo "Next steps:"
echo "1. Update docker-compose.prod.yml with your registry URLs"
echo "2. Run './start-app.sh' to start the application"
echo "3. Run './stop-app.sh' to stop the application"
