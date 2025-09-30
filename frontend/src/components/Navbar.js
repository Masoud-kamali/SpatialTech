import React, { useState } from 'react';
import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  IconButton,
  Badge,
  Menu,
  MenuItem,
  Box,
} from '@mui/material';
import {
  Notifications,
  Dashboard,
  LocationOn,
  Warning,
  Analytics,
  LiveTv,
} from '@mui/icons-material';
import { useNavigate, useLocation } from 'react-router-dom';

const Navbar = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const [notificationAnchor, setNotificationAnchor] = useState(null);

  const handleNotificationClick = (event) => {
    setNotificationAnchor(event.currentTarget);
  };

  const handleNotificationClose = () => {
    setNotificationAnchor(null);
  };

  const navigationItems = [
    { path: '/', label: 'Dashboard', icon: <Dashboard /> },
    { path: '/sites', label: 'Sites', icon: <LocationOn /> },
    { path: '/alerts', label: 'Alerts', icon: <Warning /> },
    { path: '/analytics', label: 'Analytics', icon: <Analytics /> },
  ];

  return (
    <AppBar position="static" elevation={1}>
      <Toolbar>
        <Typography variant="h6" component="div" sx={{ flexGrow: 0, mr: 4 }}>
          🏗️ SitEye
        </Typography>
        
        <Box sx={{ flexGrow: 1, display: 'flex', gap: 1 }}>
          {navigationItems.map((item) => (
            <Button
              key={item.path}
              color="inherit"
              startIcon={item.icon}
              onClick={() => navigate(item.path)}
              sx={{
                backgroundColor: location.pathname === item.path ? 'rgba(255,255,255,0.1)' : 'transparent',
                '&:hover': {
                  backgroundColor: 'rgba(255,255,255,0.2)',
                },
              }}
            >
              {item.label}
            </Button>
          ))}
        </Box>

        <IconButton color="inherit" onClick={handleNotificationClick}>
          <Badge badgeContent={3} color="error">
            <Notifications />
          </Badge>
        </IconButton>

        <Menu
          anchorEl={notificationAnchor}
          open={Boolean(notificationAnchor)}
          onClose={handleNotificationClose}
        >
          <MenuItem onClick={handleNotificationClose}>
            <Box>
              <Typography variant="subtitle2">Fall Risk Detected</Typography>
              <Typography variant="caption" color="textSecondary">
                Zone 3 - Worker near unprotected edge
              </Typography>
            </Box>
          </MenuItem>
          <MenuItem onClick={handleNotificationClose}>
            <Box>
              <Typography variant="subtitle2">Fence Breach Alert</Typography>
              <Typography variant="caption" color="textSecondary">
                Safety barrier damaged in section A
              </Typography>
            </Box>
          </MenuItem>
          <MenuItem onClick={handleNotificationClose}>
            <Box>
              <Typography variant="subtitle2">Workforce Safety</Typography>
              <Typography variant="caption" color="textSecondary">
                Multiple workers without harnesses
              </Typography>
            </Box>
          </MenuItem>
        </Menu>

        <Button
          color="inherit"
          startIcon={<LiveTv />}
          onClick={() => navigate('/live/1')}
          sx={{ ml: 2 }}
        >
          Live Monitor
        </Button>
      </Toolbar>
    </AppBar>
  );
};

export default Navbar;
