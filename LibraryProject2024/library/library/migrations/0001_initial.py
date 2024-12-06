# Generated by Django 5.1.2 on 2024-10-21 20:45

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Books',
            fields=[
                ('book_id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=2000)),
                ('author', models.CharField(max_length=1000)),
                ('count', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='BooksInRelations',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('book_id', models.IntegerField()),
                ('pass_id', models.IntegerField()),
                ('relation', models.CharField(choices=[('on_hands', 'На руках'), ('reservation', 'Бронь'), ('favorite', 'Избранное')], max_length=20)),
            ],
        ),
        migrations.CreateModel(
            name='News',
            fields=[
                ('news_id', models.AutoField(primary_key=True, serialize=False)),
                ('title', models.CharField(max_length=255)),
                ('message', models.TextField()),
                ('jpg', models.ImageField(upload_to='news_images/')),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('pass_id', models.AutoField(primary_key=True, serialize=False)),
                ('full_name', models.CharField(max_length=255)),
                ('password', models.CharField(max_length=128)),
            ],
        ),
    ]