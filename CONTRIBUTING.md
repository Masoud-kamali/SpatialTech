# Contributing to SitEye

Thank you for your interest in contributing to SitEye! This guide will help you get started.

## 🚀 Quick Start

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/SpatialTech.git
   cd SpatialTech
   ```
3. **Set up the development environment**
   ```bash
   cp env.example .env
   docker-compose up -d
   ```

## 🏗️ Development Setup

### Backend Development
```bash
cd backend
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### Frontend Development
```bash
cd frontend
npm install
npm start
```

## 📝 Code Standards

### Python (Backend)
- Follow PEP 8 style guidelines
- Use type hints where appropriate
- Write docstrings for all functions and classes
- Minimum test coverage: 80%

### JavaScript (Frontend)
- Use ESLint and Prettier
- Follow React best practices
- Use functional components with hooks
- Write tests for all components

## 🧪 Testing

### Backend Tests
```bash
cd backend
pytest
```

### Frontend Tests
```bash
cd frontend
npm test
```

## 📋 Pull Request Process

1. Create a feature branch from `main`
2. Make your changes
3. Add tests for new functionality
4. Ensure all tests pass
5. Update documentation if needed
6. Submit a pull request

## 🐛 Bug Reports

Please include:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Screenshots if applicable

## 💡 Feature Requests

We welcome feature suggestions! Please include:
- Clear description of the feature
- Use case and benefits
- Proposed implementation approach

## 📞 Contact

- GitHub Issues: [Report Issues](../../issues)
- Discussions: [GitHub Discussions](../../discussions)
- Email: support@siteye.construction
