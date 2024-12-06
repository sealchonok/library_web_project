# Generated by Django 5.1.2 on 2024-11-22 07:26

import django.utils.timezone
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('library', '0004_books_description_books_image'),
    ]

    operations = [
        migrations.AddField(
            model_name='books',
            name='timestamp',
            field=models.DateTimeField(auto_now_add=True, default=django.utils.timezone.now),
            preserve_default=False,
        ),
    ]