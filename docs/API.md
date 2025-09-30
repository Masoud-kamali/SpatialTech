# SitEye API Documentation

## Authentication
All API endpoints require authentication using JWT tokens.

## Endpoints

### Safety Monitoring
- `GET /api/v1/sites/` - List all monitored sites
- `GET /api/v1/sites/{id}/metrics/` - Real-time safety metrics
- `POST /api/v1/detection/analyze/` - AI safety analysis
- `GET /api/v1/fall-detection/risks/` - Fall risk assessments

### Real-time Alerts
- `GET /api/v1/alerts/active/` - Active safety alerts
- `WebSocket: /ws/alerts/` - Live alert stream

### Analytics
- `GET /api/v1/analytics/safety-trends/` - Safety trend analysis
- `GET /api/v1/reports/compliance/` - Compliance reports
