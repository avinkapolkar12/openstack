# OpenStack Deployment Guide

## Prerequisites

1. **VirtualBox with Ubuntu VM**

   - Ubuntu 20.04 LTS or newer
   - At least 4GB RAM, 20GB disk space
   - Network adapter configured for internet access

2. **Docker Registry Access**
   - Docker Hub account (free)
   - Or private registry access

## Step-by-Step Deployment

### 1. Prepare Your Local Environment

First, test the application locally:

```bash
cd dummy-app
docker-compose up --build
```

Verify it works at:

- Frontend: http://localhost:3000
- Backend: http://localhost:5000

### 2. Build and Push Docker Images

```bash
# Build images
docker build -t your-username/dummy-server:latest ./server
docker build -t your-username/dummy-client:latest ./client

# Push to Docker Hub
docker login
docker push your-username/dummy-server:latest
docker push your-username/dummy-client:latest
```

### 3. Transfer Deployment Files to Ubuntu VM

Copy the `openstack` folder to your Ubuntu VM:

```bash
# From your Windows machine, use SCP or copy files manually
scp -r openstack/ user@ubuntu-vm-ip:~/
```

### 4. Run Deployment on Ubuntu VM

```bash
# SSH into your Ubuntu VM
ssh user@ubuntu-vm-ip

# Navigate to deployment folder
cd ~/openstack

# Make deployment script executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

### 5. Configure Production Environment

Edit `docker-compose.prod.yml`:

```yaml
# Update these lines with your actual registry URLs
image: your-username/dummy-server:latest
image: your-username/dummy-client:latest

# Update API URL with your VM's IP
REACT_APP_API_URL: http://10.0.2.15:5000
```

### 6. Start the Application

```bash
./start-app.sh
```

### 7. Access Your Application

- Frontend: http://10.0.2.15
- Backend API: http://10.0.2.15:5000

## Useful Commands

```bash
# Check running containers
docker ps

# View logs
docker-compose -f docker-compose.prod.yml logs

# Restart services
docker-compose -f docker-compose.prod.yml restart

# Update application
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

## Troubleshooting

1. **Can't access application**

   - Check VM firewall: `sudo ufw status`
   - Ensure ports 80 and 5000 are open
   - Verify containers are running: `docker ps`

2. **Database connection issues**

   - Check database logs: `docker logs dummy-database-prod`
   - Verify environment variables

3. **Image pull failures**
   - Check internet connectivity
   - Verify registry URLs
   - Check Docker Hub authentication

## Security Considerations

- Change default database password
- Use environment variables for secrets
- Configure proper firewall rules
- Use HTTPS in production
- Implement proper authentication
