from django.contrib.gis.db import models
from django.contrib.auth.models import User


class Site(models.Model):
    """Construction site model"""
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    location = models.PointField()
    boundary = models.PolygonField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'monitoring_site'
        
    def __str__(self):
        return self.name


class Camera(models.Model):
    """Camera monitoring model"""
    CAMERA_TYPES = [
        ('fixed', 'Fixed Position'),
        ('ptz', 'Pan-Tilt-Zoom'),
        ('mobile', 'Mobile Camera'),
    ]
    
    site = models.ForeignKey(Site, on_delete=models.CASCADE, related_name='cameras')
    name = models.CharField(max_length=100)
    camera_type = models.CharField(max_length=20, choices=CAMERA_TYPES, default='fixed')
    position = models.PointField()
    stream_url = models.URLField()
    is_active = models.BooleanField(default=True)
    field_of_view = models.PolygonField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'monitoring_camera'
        
    def __str__(self):
        return f"{self.site.name} - {self.name}"


class Zone(models.Model):
    """Safety zones within construction sites"""
    ZONE_TYPES = [
        ('construction', 'Construction Area'),
        ('machinery', 'Heavy Machinery Zone'),
        ('restricted', 'Restricted Access'),
        ('storage', 'Material Storage'),
        ('office', 'Office Area'),
    ]
    
    SAFETY_LEVELS = [
        ('low', 'Low Risk'),
        ('medium', 'Medium Risk'),
        ('high', 'High Risk'),
        ('critical', 'Critical Risk'),
    ]
    
    site = models.ForeignKey(Site, on_delete=models.CASCADE, related_name='zones')
    name = models.CharField(max_length=100)
    zone_type = models.CharField(max_length=20, choices=ZONE_TYPES)
    safety_level = models.CharField(max_length=20, choices=SAFETY_LEVELS)
    boundary = models.PolygonField()
    max_occupancy = models.IntegerField(default=10)
    ppe_required = models.JSONField(default=list)  # ['hard_hat', 'safety_vest', 'gloves']
    is_active = models.BooleanField(default=True)
    
    class Meta:
        db_table = 'monitoring_zone'
        
    def __str__(self):
        return f"{self.site.name} - {self.name}"


class Worker(models.Model):
    """Worker tracking model"""
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    employee_id = models.CharField(max_length=50, unique=True)
    site = models.ForeignKey(Site, on_delete=models.CASCADE, related_name='workers')
    role = models.CharField(max_length=100)
    certifications = models.JSONField(default=list)
    emergency_contact = models.CharField(max_length=200)
    is_on_site = models.BooleanField(default=False)
    last_seen = models.DateTimeField(null=True, blank=True)
    current_zone = models.ForeignKey(Zone, on_delete=models.SET_NULL, null=True, blank=True)
    
    class Meta:
        db_table = 'monitoring_worker'
        
    def __str__(self):
        return f"{self.user.get_full_name()} ({self.employee_id})"
