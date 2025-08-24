# Complete Step-by-Step Guide: Dummy App to OpenStack Deployment

## Project Overview

This project creates a simple three-tier web application:

- **Frontend (Client)**: React.js application with user interface
- **Backend (Server)**: Node.js/Express.js REST API
- **Database**: PostgreSQL database

## Phase 1: Local Development and Testing

### Step 1: Test the Application Locally

1. **Navigate to the project directory:**

   ```powershell
   cd "c:\Users\AvinKapolkar\Desktop\openstack\dummy-app"
   ```

2. **Start the application with Docker Compose:**

   ```powershell
   docker-compose up --build
   ```

3. **Verify the application works:**

   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000/api/health
   - Add some users through the web interface

4. **Stop the application:**
   ```powershell
   docker-compose down
   ```

## Phase 2: Dockerization and Registry

### Step 2: Build and Tag Docker Images

1. **Build the server image:**

   ```powershell
   docker build -t your-dockerhub-username/dummy-server:latest .\server
   ```

2. **Build the client image:**

   ```powershell
   docker build -t your-dockerhub-username/dummy-client:latest .\client
   ```

3. **Verify images are built:**
   ```powershell
   docker images
   ```

### Step 3: Push Images to Docker Hub

1. **Login to Docker Hub:**

   ```powershell
   docker login
   ```

2. **Push the images:**
   ```powershell
   docker push your-dockerhub-username/dummy-server:latest
   docker push your-dockerhub-username/dummy-client:latest
   ```

## Phase 3: OpenStack/VirtualBox Ubuntu Setup

### Step 4: Prepare Ubuntu VM

1. **Ensure your Ubuntu VM is running in VirtualBox**
2. **Update the system:**

   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

3. **Install Docker and Docker Compose:**

   ```bash
   sudo apt install -y docker.io docker-compose
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -aG docker $USER
   ```

4. **Log out and log back in** for group changes to take effect

### Step 5: Transfer Files to Ubuntu VM

1. **Option A: Using SCP (if SSH is enabled):**

   ```powershell
   scp -r "c:\Users\AvinKapolkar\Desktop\openstack\dummy-app\openstack" user@ubuntu-vm-ip:~/
   ```

2. **Option B: Manual transfer:**
   - Copy the `openstack` folder to a USB drive
   - Mount the USB in Ubuntu VM
   - Copy files to home directory

### Step 6: Deploy on Ubuntu VM

1. **SSH into your Ubuntu VM or open terminal:**

   ```bash
   cd ~/openstack
   ```

2. **Make the deployment script executable:**

   ```bash
   chmod +x deploy.sh
   ```

3. **Run the deployment:**

   ```bash
   ./deploy.sh
   ```

4. **Edit the production configuration:**

   ```bash
   nano ~/dummy-app/docker-compose.prod.yml
   ```

   Update these lines:

   ```yaml
   # Replace with your actual Docker Hub username
   image: your-dockerhub-username/dummy-server:latest
   image: your-dockerhub-username/dummy-client:latest

   # Replace with your VM's IP address
   REACT_APP_API_URL: http://YOUR-VM-IP:5000
   ```

5. **Start the application:**
   ```bash
   cd ~/dummy-app
   ./start-app.sh
   ```

## Phase 4: Access and Verify

### Step 7: Access Your Application

1. **Find your VM's IP address:**

   ```bash
   hostname -I
   ```

2. **Access the application:**

   - Frontend: http://YOUR-VM-IP
   - Backend API: http://YOUR-VM-IP:5000/api/health

3. **Test functionality:**
   - Add users through the web interface
   - Verify data persistence by refreshing the page

## Phase 5: Management and Monitoring

### Step 8: Application Management

1. **View running containers:**

   ```bash
   docker ps
   ```

2. **Check application logs:**

   ```bash
   docker-compose -f docker-compose.prod.yml logs
   ```

3. **Stop the application:**

   ```bash
   ./stop-app.sh
   ```

4. **Restart the application:**
   ```bash
   ./start-app.sh
   ```

### Step 9: Updates and Maintenance

1. **Update application images:**

   ```bash
   docker-compose -f docker-compose.prod.yml pull
   docker-compose -f docker-compose.prod.yml up -d
   ```

2. **View resource usage:**

   ```bash
   docker stats
   ```

3. **Clean up unused images:**
   ```bash
   docker system prune -a
   ```

## Troubleshooting Guide

### Common Issues and Solutions

1. **Application not accessible from outside VM:**

   ```bash
   # Check and configure firewall
   sudo ufw status
   sudo ufw allow 80
   sudo ufw allow 5000
   ```

2. **Database connection errors:**

   ```bash
   # Check database container logs
   docker logs dummy-database-prod
   ```

3. **Images won't pull:**

   ```bash
   # Verify internet connection and registry access
   docker login
   docker pull postgres:15-alpine
   ```

4. **Out of disk space:**
   ```bash
   # Clean up Docker resources
   docker system prune -a --volumes
   ```

## Security Best Practices

1. **Change default passwords in production**
2. **Use environment variables for sensitive data**
3. **Configure proper firewall rules**
4. **Keep Docker and system updated**
5. **Monitor logs for suspicious activity**

## Next Steps and Enhancements

1. **Add HTTPS/SSL certificate**
2. **Implement user authentication**
3. **Add monitoring and alerting**
4. **Set up automated backups**
5. **Configure log rotation**
6. **Add load balancing for high availability**

## File Structure Summary

```
dummy-app/
├── client/                 # React frontend
│   ├── src/
│   ├── public/
│   ├── Dockerfile
│   └── package.json
├── server/                 # Node.js backend
│   ├── index.js
│   ├── Dockerfile
│   └── package.json
├── database/               # Database initialization
│   └── init.sql
├── openstack/              # Deployment scripts
│   ├── deploy.sh
│   └── DEPLOYMENT.md
├── docker-compose.yml      # Local development
└── README.md
```

This completes your dummy application with full dockerization and OpenStack deployment capability!
