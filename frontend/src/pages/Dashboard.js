import React, { useState, useEffect } from 'react';
import {
  Grid,
  Card,
  CardContent,
  Typography,
  Box,
  LinearProgress,
  Chip,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  Paper,
} from '@mui/material';
import {
  Warning,
  CheckCircle,
  Person,
  Camera,
  TrendingUp,
  Security,
} from '@mui/icons-material';
import { PieChart, Pie, Cell, ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';

const Dashboard = () => {
  const [dashboardData, setDashboardData] = useState({
    totalSites: 5,
    activeCameras: 24,
    workersOnSite: 127,
    activeAlerts: 3,
    complianceScore: 94,
    todayIncidents: 2,
  });

  const complianceData = [
    { name: 'Compliant', value: 94, color: '#4caf50' },
    { name: 'Violations', value: 6, color: '#f44336' },
  ];

  const weeklyData = [
    { day: 'Mon', incidents: 2, compliance: 96 },
    { day: 'Tue', incidents: 1, compliance: 98 },
    { day: 'Wed', incidents: 3, compliance: 92 },
    { day: 'Thu', incidents: 1, compliance: 97 },
    { day: 'Fri', incidents: 2, compliance: 94 },
    { day: 'Sat', incidents: 0, compliance: 100 },
    { day: 'Sun', incidents: 1, compliance: 95 },
  ];

  const recentAlerts = [
    {
      id: 1,
      type: 'Fall Detection',
      description: 'Worker detected near unprotected edge - Zone 3',
      severity: 'critical',
      time: '2 minutes ago',
    },
    {
      id: 2,
      type: 'Fence Breach',
      description: 'Safety barrier damaged in perimeter section A',
      severity: 'high',
      time: '15 minutes ago',
    },
    {
      id: 3,
      type: 'Workforce Safety',
      description: 'Multiple workers without safety harnesses',
      severity: 'high',
      time: '1 hour ago',
    },
  ];

  const getSeverityColor = (severity) => {
    switch (severity) {
      case 'critical': return 'error';
      case 'high': return 'warning';
      case 'medium': return 'info';
      default: return 'default';
    }
  };

  const StatCard = ({ title, value, icon, color = 'primary', trend = null }) => (
    <Card>
      <CardContent>
        <Box display="flex" alignItems="center" justifyContent="space-between">
          <Box>
            <Typography color="textSecondary" gutterBottom variant="h6">
              {title}
            </Typography>
            <Typography variant="h4" component="h2">
              {value}
            </Typography>
            {trend && (
              <Box display="flex" alignItems="center" mt={1}>
                <TrendingUp fontSize="small" color="success" />
                <Typography variant="caption" color="success.main" ml={0.5}>
                  {trend}
                </Typography>
              </Box>
            )}
          </Box>
          <Box color={`${color}.main`}>
            {icon}
          </Box>
        </Box>
      </CardContent>
    </Card>
  );

  return (
    <Box sx={{ flexGrow: 1, p: 3 }}>
      <Typography variant="h4" gutterBottom>
        Safety Dashboard
      </Typography>
      
      <Grid container spacing={3}>
        {/* Stats Cards */}
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Active Sites"
            value={dashboardData.totalSites}
            icon={<Camera fontSize="large" />}
            color="primary"
            trend="+2 this month"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Workers On-Site"
            value={dashboardData.workersOnSite}
            icon={<Person fontSize="large" />}
            color="info"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Active Alerts"
            value={dashboardData.activeAlerts}
            icon={<Warning fontSize="large" />}
            color="warning"
          />
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <StatCard
            title="Compliance Score"
            value={`${dashboardData.complianceScore}%`}
            icon={<Security fontSize="large" />}
            color="success"
            trend="+2% this week"
          />
        </Grid>

        {/* Compliance Overview */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Safety Compliance Overview
              </Typography>
              <Box display="flex" alignItems="center" mb={2}>
                <Box flexGrow={1}>
                  <Typography variant="body2" color="textSecondary">
                    Overall Compliance
                  </Typography>
                  <LinearProgress
                    variant="determinate"
                    value={dashboardData.complianceScore}
                    sx={{ height: 8, borderRadius: 4 }}
                  />
                </Box>
                <Typography variant="h6" ml={2}>
                  {dashboardData.complianceScore}%
                </Typography>
              </Box>
              <ResponsiveContainer width="100%" height={200}>
                <PieChart>
                  <Pie
                    data={complianceData}
                    cx="50%"
                    cy="50%"
                    innerRadius={60}
                    outerRadius={80}
                    paddingAngle={5}
                    dataKey="value"
                  >
                    {complianceData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Recent Alerts */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Recent Alerts
              </Typography>
              <List>
                {recentAlerts.map((alert) => (
                  <ListItem key={alert.id}>
                    <ListItemIcon>
                      <Warning color={getSeverityColor(alert.severity)} />
                    </ListItemIcon>
                    <ListItemText
                      primary={
                        <Box display="flex" alignItems="center" gap={1}>
                          <Typography variant="subtitle2">
                            {alert.type}
                          </Typography>
                          <Chip
                            label={alert.severity}
                            size="small"
                            color={getSeverityColor(alert.severity)}
                          />
                        </Box>
                      }
                      secondary={
                        <Box>
                          <Typography variant="body2">
                            {alert.description}
                          </Typography>
                          <Typography variant="caption" color="textSecondary">
                            {alert.time}
                          </Typography>
                        </Box>
                      }
                    />
                  </ListItem>
                ))}
              </List>
            </CardContent>
          </Card>
        </Grid>

        {/* Weekly Trends */}
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Weekly Safety Trends
              </Typography>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={weeklyData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="day" />
                  <YAxis yAxisId="left" />
                  <YAxis yAxisId="right" orientation="right" />
                  <Tooltip />
                  <Legend />
                  <Bar yAxisId="left" dataKey="incidents" fill="#f44336" name="Incidents" />
                  <Bar yAxisId="right" dataKey="compliance" fill="#4caf50" name="Compliance %" />
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Dashboard;
