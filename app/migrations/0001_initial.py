# Generated by Django 2.1 on 2018-08-29 09:53
from django.contrib.postgres.operations import CreateExtension
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        CreateExtension('postgis'),
    ]
