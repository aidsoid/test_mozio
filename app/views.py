from django.contrib.auth.models import User, Group
from django.contrib.gis.geos import Point
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.views import APIView

from app.models import Provider, ServiceArea
from app.serializers import UserSerializer, GroupSerializer, ProviderSerializer, ServiceAreaSerializer


class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer


class GroupViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """
    queryset = Group.objects.all()
    serializer_class = GroupSerializer


class ProviderViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows providers to be viewed or edited.
    """
    queryset = Provider.objects.all()
    serializer_class = ProviderSerializer


class ServiceAreaViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows service areas to be viewed or edited.
    """
    queryset = ServiceArea.objects.all()
    serializer_class = ServiceAreaSerializer


class FindServiceAreas(APIView):
    """
    API endpoint that allows to find service areas by coords.
    """
    def get(self, request, latitude, longitude, format=None):
        latitude = float(latitude)
        longitude = float(longitude)
        point = Point(latitude, longitude)
        service_areas = ServiceArea.objects.filter(poly__intersects=point)
        serializer = ServiceAreaSerializer(service_areas, many=True)
        return Response(serializer.data)
