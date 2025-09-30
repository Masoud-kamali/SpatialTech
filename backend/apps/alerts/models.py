from django.db import models
from apps.monitoring.models import Site, Zone, Worker
from apps.detection.models import Detection


class Alert(models.Model):
    """Safety alert model"""
    ALERT_TYPES = [
        ('ppe_violation', 'PPE Violation'),
        ('unauthorized_access', 'Unauthorized Access'),
        ('safety_hazard', 'Safety Hazard'),
        ('equipment_malfunction', 'Equipment Malfunction'),
        ('emergency', 'Emergency Situation'),
        ('zone_overcrowding', 'Zone Overcrowding'),
    ]
    
    SEVERITY_LEVELS = [
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High'),
        ('critical', 'Critical'),
    ]
    
    STATUS_CHOICES = [
        ('active', 'Active'),
        ('acknowledged', 'Acknowledged'),
        ('resolved', 'Resolved'),
        ('false_positive', 'False Positive'),
    ]
    
    site = models.ForeignKey(Site, on_delete=models.CASCADE, related_name='alerts')
    alert_type = models.CharField(max_length=30, choices=ALERT_TYPES)
    severity = models.CharField(max_length=20, choices=SEVERITY_LEVELS)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='active')
    
    title = models.CharField(max_length=200)
    description = models.TextField()
    
    # Related entities
    detection = models.ForeignKey(Detection, on_delete=models.SET_NULL, null=True, blank=True)
    zone = models.ForeignKey(Zone, on_delete=models.SET_NULL, null=True, blank=True)
    worker = models.ForeignKey(Worker, on_delete=models.SET_NULL, null=True, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    acknowledged_at = models.DateTimeField(null=True, blank=True)
    resolved_at = models.DateTimeField(null=True, blank=True)
    
    # Response tracking
    response_time = models.DurationField(null=True, blank=True)
    resolution_notes = models.TextField(blank=True)
    
    class Meta:
        db_table = 'alerts_alert'
        indexes = [
            models.Index(fields=['created_at', 'severity']),
            models.Index(fields=['site', 'status']),
        ]
        ordering = ['-created_at']
        
    def __str__(self):
        return f"{self.title} - {self.severity} ({self.status})"


class AlertRule(models.Model):
    """Configurable alert rules"""
    name = models.CharField(max_length=100)
    description = models.TextField()
    site = models.ForeignKey(Site, on_delete=models.CASCADE, related_name='alert_rules')
    
    # Rule conditions
    conditions = models.JSONField()  # Complex rule conditions
    alert_type = models.CharField(max_length=30, choices=Alert.ALERT_TYPES)
    severity = models.CharField(max_length=20, choices=Alert.SEVERITY_LEVELS)
    
    # Thresholds
    threshold_value = models.FloatField(null=True, blank=True)
    time_window = models.DurationField(null=True, blank=True)  # e.g., 5 minutes
    
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'alerts_rule'
        
    def __str__(self):
        return f"{self.name} - {self.site.name}"


class Notification(models.Model):
    """Notification delivery tracking"""
    CHANNEL_TYPES = [
        ('email', 'Email'),
        ('sms', 'SMS'),
        ('push', 'Push Notification'),
        ('webhook', 'Webhook'),
        ('dashboard', 'Dashboard'),
    ]
    
    alert = models.ForeignKey(Alert, on_delete=models.CASCADE, related_name='notifications')
    channel = models.CharField(max_length=20, choices=CHANNEL_TYPES)
    recipient = models.CharField(max_length=200)  # email, phone, etc.
    
    sent_at = models.DateTimeField(auto_now_add=True)
    delivered = models.BooleanField(default=False)
    delivery_attempts = models.IntegerField(default=1)
    error_message = models.TextField(blank=True)
    
    class Meta:
        db_table = 'alerts_notification'
        
    def __str__(self):
        return f"{self.channel} to {self.recipient} for {self.alert.title}"
