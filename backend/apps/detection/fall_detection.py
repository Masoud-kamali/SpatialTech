"""
Fall Detection Module for Construction Site Safety
Implements advanced fall detection algorithms and safety monitoring
"""

from django.db import models
from apps.monitoring.models import Site, Camera, Zone, Worker
from apps.detection.models import Detection
import json


class FallDetection(models.Model):
    """Specialized fall detection tracking"""
    FALL_RISK_LEVELS = [
        ('low', 'Low Risk'),
        ('medium', 'Medium Risk'),
        ('high', 'High Risk'),
        ('critical', 'Critical Risk'),
        ('fall_detected', 'Fall Detected'),
    ]
    
    EDGE_TYPES = [
        ('building_edge', 'Building Edge'),
        ('scaffold_edge', 'Scaffold Edge'),
        ('excavation_edge', 'Excavation Edge'),
        ('platform_edge', 'Platform Edge'),
        ('roof_edge', 'Roof Edge'),
    ]
    
    detection = models.OneToOneField(Detection, on_delete=models.CASCADE, related_name='fall_analysis')
    worker = models.ForeignKey(Worker, on_delete=models.CASCADE, related_name='fall_detections')
    
    # Fall risk assessment
    risk_level = models.CharField(max_length=20, choices=FALL_RISK_LEVELS)
    distance_to_edge = models.FloatField(help_text="Distance to nearest edge in meters")
    edge_type = models.CharField(max_length=20, choices=EDGE_TYPES)
    
    # Safety equipment detection
    has_harness = models.BooleanField(default=False)
    has_hardhat = models.BooleanField(default=False)
    harness_attached = models.BooleanField(default=False)
    
    # Position and movement analysis
    worker_position = models.JSONField(help_text="Worker coordinates")
    movement_velocity = models.FloatField(default=0.0, help_text="Movement speed m/s")
    movement_direction = models.JSONField(help_text="Movement vector")
    
    # Alert status
    alert_triggered = models.BooleanField(default=False)
    alert_level = models.CharField(max_length=20, choices=[
        ('none', 'No Alert'),
        ('warning', 'Warning'),
        ('urgent', 'Urgent'),
        ('emergency', 'Emergency'),
    ], default='none')
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'detection_fall'
        indexes = [
            models.Index(fields=['risk_level', 'created_at']),
            models.Index(fields=['worker', 'alert_triggered']),
        ]
        
    def __str__(self):
        return f"Fall Detection - {self.worker} - {self.risk_level}"
    
    def calculate_risk_score(self):
        """Calculate comprehensive fall risk score"""
        score = 0
        
        # Distance to edge scoring
        if self.distance_to_edge < 1.0:
            score += 40
        elif self.distance_to_edge < 2.0:
            score += 25
        elif self.distance_to_edge < 3.0:
            score += 10
        
        # Safety equipment scoring
        if not self.has_harness:
            score += 30
        elif not self.harness_attached:
            score += 20
        
        if not self.has_hardhat:
            score += 10
        
        # Movement analysis
        if self.movement_velocity > 2.0:  # Fast movement near edge
            score += 15
        
        # Edge type risk multiplier
        edge_multipliers = {
            'roof_edge': 1.5,
            'building_edge': 1.4,
            'scaffold_edge': 1.3,
            'excavation_edge': 1.2,
            'platform_edge': 1.1,
        }
        score *= edge_multipliers.get(self.edge_type, 1.0)
        
        return min(score, 100)  # Cap at 100
    
    def determine_alert_level(self):
        """Determine appropriate alert level based on risk factors"""
        risk_score = self.calculate_risk_score()
        
        if risk_score >= 80:
            return 'emergency'
        elif risk_score >= 60:
            return 'urgent'
        elif risk_score >= 40:
            return 'warning'
        else:
            return 'none'
    
    def save(self, *args, **kwargs):
        """Override save to auto-calculate risk and alerts"""
        self.alert_level = self.determine_alert_level()
        self.alert_triggered = self.alert_level in ['warning', 'urgent', 'emergency']
        super().save(*args, **kwargs)


class SafetyFence(models.Model):
    """Safety fence monitoring and integrity tracking"""
    FENCE_TYPES = [
        ('perimeter', 'Perimeter Fence'),
        ('safety_barrier', 'Safety Barrier'),
        ('scaffolding_guard', 'Scaffolding Guard Rail'),
        ('temporary_barrier', 'Temporary Barrier'),
        ('exclusion_zone', 'Exclusion Zone Fence'),
    ]
    
    FENCE_STATUS = [
        ('intact', 'Intact'),
        ('damaged', 'Damaged'),
        ('missing', 'Missing'),
        ('compromised', 'Compromised'),
    ]
    
    site = models.ForeignKey(Site, on_delete=models.CASCADE, related_name='safety_fences')
    zone = models.ForeignKey(Zone, on_delete=models.CASCADE, related_name='fences')
    
    fence_id = models.CharField(max_length=50, unique=True)
    fence_type = models.CharField(max_length=20, choices=FENCE_TYPES)
    status = models.CharField(max_length=20, choices=FENCE_STATUS, default='intact')
    
    # Physical properties
    height = models.FloatField(help_text="Fence height in meters")
    length = models.FloatField(help_text="Fence length in meters")
    material = models.CharField(max_length=50)
    
    # Location tracking
    start_position = models.PointField()
    end_position = models.PointField()
    fence_line = models.LineStringField()
    
    # Monitoring data
    last_inspection = models.DateTimeField()
    inspection_frequency_days = models.IntegerField(default=7)
    maintenance_required = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'monitoring_safety_fence'
        
    def __str__(self):
        return f"{self.fence_type} - {self.fence_id} ({self.status})"


class WorkforceSafetyMetrics(models.Model):
    """Aggregate workforce safety metrics and compliance tracking"""
    site = models.ForeignKey(Site, on_delete=models.CASCADE, related_name='workforce_metrics')
    date = models.DateField()
    
    # Worker counts
    total_workers = models.IntegerField(default=0)
    workers_with_ppe = models.IntegerField(default=0)
    workers_with_harness = models.IntegerField(default=0)
    workers_in_danger_zones = models.IntegerField(default=0)
    
    # Safety incidents
    fall_risks_detected = models.IntegerField(default=0)
    fence_breaches = models.IntegerField(default=0)
    ppe_violations = models.IntegerField(default=0)
    safety_alerts_generated = models.IntegerField(default=0)
    
    # Compliance scores
    overall_compliance_score = models.FloatField(default=100.0)
    ppe_compliance_score = models.FloatField(default=100.0)
    fall_safety_score = models.FloatField(default=100.0)
    fence_integrity_score = models.FloatField(default=100.0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'monitoring_workforce_metrics'
        unique_together = ['site', 'date']
        
    def __str__(self):
        return f"Workforce Safety - {self.site.name} - {self.date}"
    
    def calculate_compliance_scores(self):
        """Calculate various compliance scores"""
        if self.total_workers > 0:
            self.ppe_compliance_score = (self.workers_with_ppe / self.total_workers) * 100
            fall_safe_workers = self.total_workers - self.workers_in_danger_zones
            self.fall_safety_score = (fall_safe_workers / self.total_workers) * 100
        
        # Overall compliance is weighted average
        self.overall_compliance_score = (
            self.ppe_compliance_score * 0.4 +
            self.fall_safety_score * 0.4 +
            self.fence_integrity_score * 0.2
        )
    
    def save(self, *args, **kwargs):
        """Override save to auto-calculate scores"""
        self.calculate_compliance_scores()
        super().save(*args, **kwargs)
