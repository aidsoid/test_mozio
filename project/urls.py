"""project URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include, re_path
from rest_framework import routers
from app import views

router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet)
router.register(r'groups', views.GroupViewSet)
router.register(r'providers', views.ProviderViewSet)
router.register(r'service_areas', views.ServiceAreaViewSet)

urlpatterns = [
    path('', include(router.urls)),
    # # List all providers, or create a new provider
    # path('providers/', views.ProviderList.as_view()),
    # # Retrieve, update or delete a providers instance
    # re_path('^providers/(?P<pk>[0-9]+)/$', views.ProviderDetail.as_view()),
    # # List all ServiceArea, or create a new provider
    # path('service_area/', views.ServiceAreaList.as_view()),
    # # Retrieve, update or delete a ServiceArea instance
    # re_path('^service_area/(?P<pk>[0-9]+)/$', views.ServiceAreaDetail.as_view()),
    # Admin
    path('admin/', admin.site.urls),
]
