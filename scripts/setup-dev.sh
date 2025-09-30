#!/bin/bash

# SitEye Development Environment Setup Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 SitEye Development Setup${NC}"
echo -e "${BLUE}=============================${NC}"

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

# Setup Python virtual environment
setup_python_env() {
    echo -e "${BLUE}🐍 Setting up Python environment...${NC}"
    
    cd backend
    
    # Create virtual environment
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        print_status "Virtual environment created"
    fi
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip
    
    # Install requirements
    pip install -r requirements.txt
    print_status "Python dependencies installed"
    
    cd ..
}

# Setup Node.js environment
setup_node_env() {
    echo -e "${BLUE}📦 Setting up Node.js environment...${NC}"
    
    cd frontend
    
    # Install dependencies
    npm install
    print_status "Node.js dependencies installed"
    
    cd ..
}

# Setup Flutter environment
setup_flutter_env() {
    echo -e "${BLUE}📱 Setting up Flutter environment...${NC}"
    
    cd mobile
    
    # Check if Flutter is installed
    if command -v flutter &> /dev/null; then
        # Get dependencies
        flutter pub get
        print_status "Flutter dependencies installed"
    else
        print_warning "Flutter not installed. Please install Flutter SDK to develop mobile app."
    fi
    
    cd ..
}

# Setup environment files
setup_env_files() {
    echo -e "${BLUE}⚙️  Setting up environment files...${NC}"
    
    # Copy environment file if it doesn't exist
    if [ ! -f .env ]; then
        cp env.example .env
        print_status "Environment file created"
        print_warning "Please update .env file with your API keys"
    fi
    
    # Setup frontend environment
    if [ ! -f frontend/.env.local ]; then
        cat > frontend/.env.local << EOL
REACT_APP_API_URL=http://localhost:8000
REACT_APP_WS_URL=ws://localhost:8000
REACT_APP_ENVIRONMENT=development
EOL
        print_status "Frontend environment file created"
    fi
}

# Setup database
setup_database() {
    echo -e "${BLUE}🗄️  Setting up database...${NC}"
    
    # Start database with Docker
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d postgres redis
        print_status "Database containers started"
        
        # Wait for database to be ready
        echo "Waiting for database to be ready..."
        sleep 10
        
        # Run migrations
        cd backend
        source venv/bin/activate
        python manage.py migrate
        print_status "Database migrations completed"
        
        # Create superuser
        echo "Creating admin user..."
        python manage.py shell -c "
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@siteye.com', 'admin123')
    print('Admin user created: admin/admin123')
else:
    print('Admin user already exists')
"
        
        cd ..
    else
        print_warning "Docker Compose not found. Please install Docker to run the full stack."
    fi
}

# Setup pre-commit hooks
setup_git_hooks() {
    echo -e "${BLUE}🔗 Setting up Git hooks...${NC}"
    
    # Install pre-commit if available
    if command -v pre-commit &> /dev/null; then
        pre-commit install
        print_status "Pre-commit hooks installed"
    else
        # Create simple pre-commit hook
        cat > .git/hooks/pre-commit << 'EOL'
#!/bin/bash
echo "Running pre-commit checks..."

# Check Python code formatting
if [ -d "backend" ]; then
    cd backend
    if command -v black &> /dev/null; then
        black --check .
    fi
    if command -v flake8 &> /dev/null; then
        flake8 .
    fi
    cd ..
fi

# Check JavaScript/TypeScript formatting
if [ -d "frontend" ]; then
    cd frontend
    if [ -f "package.json" ]; then
        npm run lint --silent
    fi
    cd ..
fi

echo "Pre-commit checks completed!"
EOL
        chmod +x .git/hooks/pre-commit
        print_status "Basic Git hooks installed"
    fi
}

# Create VS Code workspace settings
setup_vscode() {
    echo -e "${BLUE}💻 Setting up VS Code workspace...${NC}"
    
    mkdir -p .vscode
    
    # Settings
    cat > .vscode/settings.json << EOL
{
    "python.defaultInterpreterPath": "./backend/venv/bin/python",
    "python.linting.enabled": true,
    "python.linting.flake8Enabled": true,
    "python.formatting.provider": "black",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    },
    "typescript.preferences.importModuleSpecifier": "relative",
    "javascript.preferences.importModuleSpecifier": "relative",
    "files.exclude": {
        "**/__pycache__": true,
        "**/node_modules": true,
        "**/.git": true,
        "**/.DS_Store": true
    }
}
EOL

    # Extensions recommendations
    cat > .vscode/extensions.json << EOL
{
    "recommendations": [
        "ms-python.python",
        "ms-python.flake8",
        "ms-python.black-formatter",
        "bradlc.vscode-tailwindcss",
        "esbenp.prettier-vscode",
        "ms-vscode.vscode-typescript-next",
        "dart-code.flutter",
        "dart-code.dart-code",
        "ms-vscode.docker",
        "ms-kubernetes-tools.vscode-kubernetes-tools"
    ]
}
EOL

    print_status "VS Code workspace configured"
}

# Main setup function
main() {
    echo -e "${BLUE}Starting development environment setup...${NC}"
    echo ""
    
    setup_env_files
    setup_python_env
    setup_node_env
    setup_flutter_env
    setup_database
    setup_git_hooks
    setup_vscode
    
    echo ""
    echo -e "${GREEN}🎉 Development environment setup completed!${NC}"
    echo -e "${GREEN}============================================${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "1. Update .env file with your API keys"
    echo -e "2. Start development servers:"
    echo -e "   ${YELLOW}Backend:${NC}  cd backend && source venv/bin/activate && python manage.py runserver"
    echo -e "   ${YELLOW}Frontend:${NC} cd frontend && npm start"
    echo -e "   ${YELLOW}Mobile:${NC}   cd mobile && flutter run"
    echo ""
    echo -e "${BLUE}Access points:${NC}"
    echo -e "   Dashboard: http://localhost:3000"
    echo -e "   API: http://localhost:8000"
    echo -e "   Admin: http://localhost:8000/admin (admin/admin123)"
    echo ""
}

# Run main function
main "$@"
