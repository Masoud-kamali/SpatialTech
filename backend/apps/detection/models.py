from django.db import models
from apps.monitoring.models import Site, Camera, Zone, Worker


class Detection(models.Model):
    """Object detection results"""
    DETECTION_TYPES = [
        ('person', 'Person'),
        ('vehicle', 'Vehicle'),
        ('equipment', 'Equipment'),
        ('ppe', 'Personal Protective Equipment'),
        ('fall_risk', 'Fall Risk'),
        ('fence', 'Safety Fence'),
        ('workforce', 'Workforce Safety'),
    ]
    
    camera = models.ForeignKey(Camera, on_delete=models.CASCADE, related_name='detections')
    detection_type = models.CharField(max_length=20, choices=DETECTION_TYPES)
    object_class = models.CharField(max_length=100)  # specific class like 'hard_hat', 'crane', etc.
    confidence = models.FloatField()
    bounding_box = models.JSONField()  # {x, y, width, height}
    image_url = models.URLField(blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    
    # Associated entities
    worker = models.ForeignKey(Worker, on_delete=models.SET_NULL, null=True, blank=True)
    zone = models.ForeignKey(Zone, on_delete=models.SET_NULL, null=True, blank=True)
    
    class Meta:
        db_table = 'detection_detection'
        indexes = [
            models.Index(fields=['timestamp', 'detection_type']),
            models.Index(fields=['camera', 'timestamp']),
        ]
        
    def __str__(self):
        return f"{self.object_class} at {self.timestamp}"


class PPEDetection(models.Model):
    """Specific PPE detection tracking"""
    PPE_TYPES = [
        ('hard_hat', 'Hard Hat'),
        ('safety_vest', 'Safety Vest'),
        ('safety_boots', 'Safety Boots'),
        ('gloves', 'Gloves'),
        ('safety_harness', 'Safety Harness'),
        ('ear_protection', 'Ear Protection'),
        ('eye_protection', 'Eye Protection'),
    ]
    
    detection = models.ForeignKey(Detection, on_delete=models.CASCADE, related_name='ppe_items')
    ppe_type = models.CharField(max_length=20, choices=PPE_TYPES)
    is_present = models.BooleanField()
    confidence = models.FloatField()
    
    class Meta:
        db_table = 'detection_ppe'
        
    def __str__(self):
        return f"{self.ppe_type}: {'Present' if self.is_present else 'Missing'}"


class AnalysisResult(models.Model):
    """AI analysis results for compliance checking"""
    detection = models.OneToOneField(Detection, on_delete=models.CASCADE, related_name='analysis')
    llm_analysis = models.TextField()  # LLM interpretation
    compliance_status = models.CharField(max_length=20, choices=[
        ('compliant', 'Compliant'),
        ('violation', 'Violation'),
        ('warning', 'Warning'),
        ('unknown', 'Unknown'),
    ])
    risk_score = models.FloatField(default=0.0)  # 0-1 scale
    recommended_actions = models.JSONField(default=list)
    processed_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'detection_analysis'
        
    def __str__(self):
        return f"Analysis for {self.detection} - {self.compliance_status}"
