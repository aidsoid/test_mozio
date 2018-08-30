from django.contrib.auth.models import User, Group
from rest_framework import serializers

from app.models import Provider, ServiceArea


class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ('url', 'username', 'email', 'groups')


class GroupSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Group
        fields = ('url', 'name')


class ProviderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Provider
        fields = ('id', 'name', 'email', 'phone', 'language', 'currency', 'service_areas')


class ServiceAreaSerializer(serializers.ModelSerializer):
    providers = ProviderSerializer(read_only=True, many=True)

    class Meta:
        model = ServiceArea
        fields = ('id', 'name', 'price', 'currency', 'poly', 'providers')
