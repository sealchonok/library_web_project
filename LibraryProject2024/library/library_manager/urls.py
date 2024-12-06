from django.contrib import admin
from django.urls import include, path
from django.conf import settings
from django.conf.urls.static import static
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

schema_view = get_schema_view(
    openapi.Info(
        title="Web приложение библиотеки. Ремизова АА2107",
        default_version='v1',
        description="Лабораторные работы по WEB приложениям 2024",
        contact=openapi.Contact(email="iremizova@gmail.com"),  # Добавьте, если хотите
        license=openapi.License(name="BSD License"),
    ),
    public=True,
)


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('library.urls')),
    path('api/swagger-ui/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),  # Измените путь
    path('api/swagger.json/', schema_view.without_ui(cache_timeout=0), name='schema-json'),  # Измените путь
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)