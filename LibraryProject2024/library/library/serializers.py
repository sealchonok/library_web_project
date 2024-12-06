from rest_framework import serializers
from .models import Books, News, User, BooksInRelations

class BooksSerializer(serializers.ModelSerializer):
    class Meta:
        model = Books
        fields = '__all__'  # Укажите необходимые поля, если не все нужны

class NewsSerializer(serializers.ModelSerializer):
    class Meta:
        model = News
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'

class UserSerializerRequest(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['pass_id', 'password']

class UserSerializerResponse(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['pass_id', 'full_name']

class BooksInRelationsSerializer(serializers.ModelSerializer):
    class Meta:
        model = BooksInRelations
        fields = '__all__'
