#!/bin/bash

echo "🏗️ SitEye - Construction Safety Monitoring Setup"
echo "=============================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is running"

# Copy environment file
if [ ! -f .env ]; then
    cp env.example .env
    echo "✅ Environment file created (.env)"
    echo "⚠️  Please update your API keys in .env file"
else
    echo "✅ Environment file already exists"
fi

# Start the application
echo "🚀 Starting SitEye services..."
docker-compose up -d

echo ""
echo "🎉 SitEye is starting up!"
echo ""
echo "📱 Access points:"
echo "   - Dashboard: http://localhost:3000"
echo "   - API Docs:  http://localhost:8000/admin"
echo "   - Grafana:   http://localhost:3001 (admin/admin)"
echo ""
echo "⏳ Services may take a few minutes to fully initialize"
echo "📝 Check logs: docker-compose logs -f"
echo ""
echo "🛑 To stop: docker-compose down"
