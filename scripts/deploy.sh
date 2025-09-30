#!/bin/bash

# SitEye Deployment Script
# Automates the deployment process for production environments

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${1:-production}
DOMAIN=${2:-localhost}
SSL_EMAIL=${3:-admin@example.com}

echo -e "${BLUE}🚀 SitEye Deployment Script${NC}"
echo -e "${BLUE}==============================${NC}"
echo -e "Environment: ${YELLOW}$ENVIRONMENT${NC}"
echo -e "Domain: ${YELLOW}$DOMAIN${NC}"
echo ""

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    echo -e "${BLUE}🔍 Checking prerequisites...${NC}"
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed"
        exit 1
    fi
    print_status "Docker is installed"
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed"
        exit 1
    fi
    print_status "Docker Compose is installed"
    
    # Check if .env file exists
    if [ ! -f .env ]; then
        print_warning ".env file not found, copying from env.example"
        cp env.example .env
        print_warning "Please update .env file with your configuration"
    fi
    print_status "Environment configuration ready"
}

# Build and deploy
deploy() {
    echo -e "${BLUE}🏗️  Building and deploying...${NC}"
    
    # Pull latest images
    print_status "Pulling latest images..."
    docker-compose pull
    
    # Build custom images
    print_status "Building custom images..."
    docker-compose build --no-cache
    
    # Stop existing containers
    print_status "Stopping existing containers..."
    docker-compose down
    
    # Start services
    print_status "Starting services..."
    docker-compose up -d
    
    # Wait for services to be healthy
    print_status "Waiting for services to start..."
    sleep 30
    
    # Run database migrations
    print_status "Running database migrations..."
    docker-compose exec -T backend python manage.py migrate
    
    # Collect static files
    print_status "Collecting static files..."
    docker-compose exec -T backend python manage.py collectstatic --noinput
    
    # Create superuser if not exists
    print_status "Setting up admin user..."
    docker-compose exec -T backend python manage.py shell -c "
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@siteye.com', 'admin123')
    print('Admin user created: admin/admin123')
else:
    print('Admin user already exists')
"
}

# Health check
health_check() {
    echo -e "${BLUE}🏥 Running health checks...${NC}"
    
    # Check backend health
    if curl -f http://localhost:8000/health &> /dev/null; then
        print_status "Backend is healthy"
    else
        print_error "Backend health check failed"
        return 1
    fi
    
    # Check frontend
    if curl -f http://localhost:3000 &> /dev/null; then
        print_status "Frontend is healthy"
    else
        print_error "Frontend health check failed"
        return 1
    fi
    
    # Check database
    if docker-compose exec -T postgres pg_isready &> /dev/null; then
        print_status "Database is healthy"
    else
        print_error "Database health check failed"
        return 1
    fi
    
    print_status "All services are healthy!"
}

# Setup SSL (optional)
setup_ssl() {
    if [ "$DOMAIN" != "localhost" ] && [ "$ENVIRONMENT" = "production" ]; then
        echo -e "${BLUE}🔒 Setting up SSL...${NC}"
        
        # Install certbot
        if ! command -v certbot &> /dev/null; then
            print_warning "Installing certbot..."
            sudo apt-get update
            sudo apt-get install -y certbot python3-certbot-nginx
        fi
        
        # Get SSL certificate
        print_status "Obtaining SSL certificate..."
        sudo certbot --nginx -d $DOMAIN --email $SSL_EMAIL --agree-tos --non-interactive
        
        # Setup auto-renewal
        print_status "Setting up SSL auto-renewal..."
        echo "0 12 * * * /usr/bin/certbot renew --quiet" | sudo crontab -
    fi
}

# Backup function
backup() {
    echo -e "${BLUE}💾 Creating backup...${NC}"
    
    BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p $BACKUP_DIR
    
    # Backup database
    docker-compose exec -T postgres pg_dump -U siteye_user siteye > $BACKUP_DIR/database.sql
    
    # Backup media files
    docker-compose exec -T backend tar -czf - media/ > $BACKUP_DIR/media.tar.gz
    
    print_status "Backup created in $BACKUP_DIR"
}

# Cleanup old containers and images
cleanup() {
    echo -e "${BLUE}🧹 Cleaning up...${NC}"
    
    # Remove unused containers
    docker container prune -f
    
    # Remove unused images
    docker image prune -f
    
    # Remove unused volumes
    docker volume prune -f
    
    print_status "Cleanup completed"
}

# Main execution
main() {
    case "$ENVIRONMENT" in
        "production")
            check_prerequisites
            backup
            deploy
            health_check
            setup_ssl
            cleanup
            ;;
        "staging")
            check_prerequisites
            deploy
            health_check
            cleanup
            ;;
        "development")
            check_prerequisites
            deploy
            health_check
            ;;
        *)
            print_error "Invalid environment: $ENVIRONMENT"
            echo "Usage: $0 [production|staging|development] [domain] [ssl_email]"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo -e "Dashboard: ${BLUE}http://$DOMAIN${NC}"
    echo -e "API: ${BLUE}http://$DOMAIN/api/v1/${NC}"
    echo -e "Admin: ${BLUE}http://$DOMAIN/admin/${NC} (admin/admin123)"
    echo -e "Grafana: ${BLUE}http://$DOMAIN:3001${NC} (admin/admin)"
    echo ""
}

# Run main function
main "$@"
