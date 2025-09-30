# SitEye - Real-Time Construction Site Safety Monitoring

🏗️ **AI-Powered Construction Safety Monitoring System**

SitEye is an intelligent real-time monitoring system designed to enhance construction site safety through advanced AI technologies including object detection, compliance rule interpretation, and live safety dashboard.

![Tech Stack](https://github.com/user-attachments/assets/your-tech-stack-image)

## 🚀 Features

### 🎯 Core Capabilities
- **Real-Time Object Detection**: Identifies safety equipment, personnel, and hazards using computer vision
- **AI Compliance Checker**: LLM-powered interpretation of construction safety regulations
- **Live Safety Dashboard**: Real-time monitoring interface with alerts and analytics
- **Multi-Platform Support**: Web dashboard and mobile Flutter app
- **Intelligent Alerts**: Automated safety violation detection and notification system

### 🔍 Detection Capabilities
- Personal Protective Equipment (PPE) compliance
- Fall detection and prevention
- Workforce safety monitoring
- Safety fence integrity and compliance
- Equipment safety status monitoring

## 🏗️ Architecture

### Data Layer
- **PostgreSQL**: Primary database for safety records and analytics
- **PostGIS**: Spatial data management for site mapping
- **Pinecone**: Vector database for RAG-based compliance rules

### AI & Analytics
- **LLaMA**: Large Language Model for compliance interpretation
- **Grounding DINO**: Advanced object detection model
- **LangChain**: AI workflow orchestration

### Service Layer
- **Django**: Python-based backend API
- **Kafka**: Real-time data streaming
- **NGINX**: Load balancing and reverse proxy

### Frontend
- **React**: Web dashboard platform
- **Flutter**: Mobile application

### Observability
- **Grafana**: Metrics and monitoring dashboards
- **Prometheus**: Time-series metrics collection

### Containerization
- **Docker**: Application containerization
- **Kubernetes**: Container orchestration

## 📱 Dashboard Features

### Real-Time Monitoring
- Live camera feeds with AI overlay
- Safety compliance score tracking
- Active alerts and violations
- Worker location tracking
- Equipment status monitoring

### Analytics & Reporting
- Daily/weekly safety reports
- Compliance trend analysis
- Incident pattern recognition
- Performance metrics dashboard
- Regulatory compliance tracking

### Alert System
- Immediate safety violation alerts
- Escalation workflows
- Mobile push notifications
- Email/SMS integration
- Historical alert tracking

## 🚦 Safety Compliance Rules

The system includes pre-configured safety rules for:
- OSHA construction safety standards
- PPE requirements and compliance
- Equipment operation safety protocols
- Site access control policies
- Emergency response procedures

## 🎮 Demo Scenarios

### Scenario 1: PPE Compliance Check
```
✅ Worker detected with hard hat and safety vest
❌ Worker without safety harness in elevated area
🚨 ALERT: PPE violation detected - Zone 3
```

### Scenario 2: Fall Detection
```
✅ Workers properly secured with harnesses
❌ Worker detected near unprotected edge
🚨 ALERT: Fall risk detected - Immediate action required
```

### Scenario 3: Safety Fence Monitoring
```
✅ Perimeter fencing intact and secure
❌ Damaged section detected in safety barrier
🚨 ALERT: Fence integrity breach - Zone compromised
```

## 🛠️ Quick Start

### Prerequisites
- Docker & Docker Compose
- Python 3.9+
- Node.js 18+
- PostgreSQL with PostGIS

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Masoud-kamali/SpatialTech.git
   cd SpatialTech
   ```

2. **Environment Setup**
   ```bash
   cp .env.example .env
   # Configure your environment variables
   ```

3. **Start with Docker**
   ```bash
   docker-compose up -d
   ```

4. **Access the Dashboard**
   - Web Dashboard: http://localhost:3000
   - API Documentation: http://localhost:8000/docs
   - Grafana Monitoring: http://localhost:3001

### Development Setup

1. **Backend Setup**
   ```bash
   cd backend
   pip install -r requirements.txt
   python manage.py migrate
   python manage.py runserver
   ```

2. **Frontend Setup**
   ```bash
   cd frontend
   npm install
   npm start
   ```

## 📊 API Endpoints

### Safety Monitoring
```
GET  /api/v1/sites/              # List all monitored sites
GET  /api/v1/sites/{id}/alerts/  # Get site alerts
POST /api/v1/detection/analyze/  # Analyze uploaded image/video
GET  /api/v1/compliance/rules/   # Get compliance rules
```

### Real-Time Data
```
WebSocket: /ws/site/{site_id}/   # Real-time site updates
WebSocket: /ws/alerts/           # Live alert stream
```

## 🔧 Configuration

### Environment Variables
```env
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/siteye
POSTGIS_VERSION=3.1

# AI Services
OPENAI_API_KEY=your_openai_key
PINECONE_API_KEY=your_pinecone_key
PINECONE_ENVIRONMENT=your_env

# Monitoring
GRAFANA_ADMIN_PASSWORD=admin
PROMETHEUS_URL=http://localhost:9090
```

### Safety Rule Configuration
```python
SAFETY_RULES = {
    'ppe_required_zones': ['construction', 'machinery', 'elevated'],
    'restricted_areas': ['crane_operation', 'excavation'],
    'max_workers_per_zone': 10,
    'emergency_contact': '+1-555-SAFETY'
}
```

## 📈 Monitoring & Analytics

### Key Metrics Tracked
- Safety compliance percentage
- Incident response time
- PPE compliance rates
- Equipment utilization
- Worker productivity vs. safety

### Dashboard Views
- **Site Overview**: Real-time safety status
- **Compliance Tracking**: Historical compliance data
- **Incident Management**: Alert handling and resolution
- **Analytics**: Trends and predictive insights

## 🔮 Future Enhancements

### Phase 2 Features
- [ ] Predictive safety analytics using ML
- [ ] Integration with IoT sensors
- [ ] Voice-activated safety commands
- [ ] AR safety overlay for mobile devices
- [ ] Automated safety report generation

### Phase 3 Features
- [ ] Multi-site management dashboard
- [ ] Advanced AI safety recommendations
- [ ] Integration with project management tools
- [ ] Blockchain-based compliance certificates
- [ ] Advanced weather integration

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests and documentation
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: [Wiki](../../wiki)
- **Issues**: [GitHub Issues](../../issues)
- **Discussions**: [GitHub Discussions](../../discussions)
- **Email**: support@siteye.construction

## 🏆 Hackathon Demo

This project was created during a construction safety hackathon to demonstrate:
- Real-time AI-powered safety monitoring
- Scalable architecture for construction sites
- Integration of multiple AI technologies
- Practical safety compliance automation

**Demo Video**: [Construction Safety Demo](demo-link)

---

<div align="center">
  <strong>🏗️ Building Safer Construction Sites with AI 🏗️</strong>
</div>
