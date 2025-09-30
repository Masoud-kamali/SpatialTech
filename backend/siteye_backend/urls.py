"""
URL configuration for siteye_backend project.
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.routers import DefaultRouter
from apps.monitoring.views import SiteViewSet, CameraViewSet
from apps.detection.views import DetectionViewSet
from apps.compliance.views import ComplianceRuleViewSet
from apps.alerts.views import AlertViewSet

# API Router
router = DefaultRouter()
router.register(r'sites', SiteViewSet)
router.register(r'cameras', CameraViewSet)
router.register(r'detections', DetectionViewSet)
router.register(r'compliance-rules', ComplianceRuleViewSet)
router.register(r'alerts', AlertViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/', include(router.urls)),
    path('api/v1/monitoring/', include('apps.monitoring.urls')),
    path('api/v1/detection/', include('apps.detection.urls')),
    path('api/v1/compliance/', include('apps.compliance.urls')),
    path('api/v1/alerts/', include('apps.alerts.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
