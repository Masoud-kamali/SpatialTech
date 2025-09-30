"""
ASGI config for siteye_backend project.
"""

import os
from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.auth import AuthMiddlewareStack
import apps.monitoring.routing

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'siteye_backend.settings')

application = ProtocolTypeRouter({
    "http": get_asgi_application(),
    "websocket": AuthMiddlewareStack(
        URLRouter(
            apps.monitoring.routing.websocket_urlpatterns
        )
    ),
})
