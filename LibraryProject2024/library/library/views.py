from rest_framework import generics
from rest_framework.response import Response
from rest_framework import status
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from .models import Books, News, User, BooksInRelations
from .serializers import BooksSerializer, NewsSerializer, UserSerializer, BooksInRelationsSerializer, UserSerializerRequest
from django.utils import timezone
from datetime import timedelta

# 1. Ручка получения и создания книг
class BooksListCreate(generics.ListCreateAPIView):
    serializer_class = BooksSerializer
    queryset = Books.objects.filter(count__gt=0)  # Изменение на получение только доступных книг

    @swagger_auto_schema(
        operation_description="Создание новой книги",
        request_body=BooksSerializer,
        responses={201: BooksSerializer()}
    )
    def post(self, request, *args, **kwargs):
        return super().post(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Получение списка книг",
        manual_parameters=[
            openapi.Parameter('author', openapi.IN_QUERY, description="Имя автора", type=openapi.TYPE_STRING),
            openapi.Parameter('name', openapi.IN_QUERY, description="Название книги", type=openapi.TYPE_STRING)
        ],
        responses={200: BooksSerializer(many=True)}
    )
    def get(self, request, *args, **kwargs):
        author_name = request.query_params.get('author', None)
        book_name = request.query_params.get('name', None)

        queryset = self.get_queryset()  # Получаем все книги из queryset

        # Фильтрация книг по автору
        if author_name:
            queryset = queryset.filter(author__icontains=author_name)

        # Фильтрация книг по названию
        if book_name:
            queryset = queryset.filter(name__icontains=book_name)

        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class BooksAddedThisWeek(generics.ListAPIView):
    serializer_class = BooksSerializer

    @swagger_auto_schema(
        operation_description="Получение списка книг, добавленных за последнюю неделю",
        responses={200: BooksSerializer(many=True)}
    )
    def get(self, request, *args, **kwargs):
        # Вычисляем дату 7 дней назад
        last_week = timezone.now() - timedelta(days=7)
        queryset = Books.objects.filter(timestamp__gte=last_week, count__gt=0)

        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

# 2. Ручка аутентификации пользователей
class UserAuthenticate(generics.GenericAPIView):
    serializer_class = UserSerializerRequest

    @swagger_auto_schema(
        operation_description="Аутентификация пользователя",
        request_body=UserSerializerRequest,
        responses={
            200: openapi.Response('Успех', UserSerializer()),
            401: 'Неверный пароль',
            404: 'Пользователь не найден'
        }
    )
    def post(self, request, *args, **kwargs):
        pass_id = request.data.get('pass_id')
        password = request.data.get('password')

        try:
            user = User.objects.get(pass_id=pass_id)
            if user.password == password:  # В реальных условиях используйте хеширование паролей
                return Response({
                    'pass_id': user.pass_id,
                    'full_name': user.full_name
                }, status=status.HTTP_200_OK)
            else:
                return Response({'error': 'Неверный пароль.'}, status=status.HTTP_401_UNAUTHORIZED)
        except User.DoesNotExist:
            return Response({'error': 'Пользователь не найден.'}, status=status.HTTP_404_NOT_FOUND)


# 3. Ручка для получения новостей
class NewsList(generics.ListAPIView):
    queryset = News.objects.all()
    serializer_class = NewsSerializer

    @swagger_auto_schema(
        operation_description="Получение списка новостей",
        responses={200: NewsSerializer(many=True)}
    )
    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()  # Получите все новости
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


# 4. Ручка на добавление отношений пользователь-книга
class BooksInRelationsCreate(generics.CreateAPIView):
    queryset = BooksInRelations.objects.all()
    serializer_class = BooksInRelationsSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# 5. Ручка на вывод отношений пользватель-книга
class BooksInRelationsList(generics.ListAPIView):
    serializer_class = BooksInRelationsSerializer

    def get_queryset(self):
        pass_id = self.request.query_params.get('pass_id', None)
        if pass_id:
            return BooksInRelations.objects.filter(pass_id=pass_id)
        return BooksInRelations.objects.none()  # Возвращает пустой QuerySet, если pass_id не указан
 # Возвращает пустой QuerySet, если pass_id не указан

from rest_framework import generics, status
from rest_framework.response import Response
from .models import BooksInRelations  # Импортируйте вашу модель
from .serializers import BooksInRelationsSerializer  # Импортируйте ваш сериализатор
from django.shortcuts import get_object_or_404

class BooksInRelationsDelete(generics.DestroyAPIView):
    queryset = BooksInRelations.objects.all()

    def delete(self, request, pass_id, book_id, *args, **kwargs):
        # Находим все отношения для удаления
        relations = BooksInRelations.objects.filter(pass_id=pass_id, book_id=book_id)

        if relations.exists():
            # Удаляем все найденные отношения
            relations.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        return Response(status=status.HTTP_404_NOT_FOUND)


class BooksInRelationsListInfo(generics.GenericAPIView):
    def get(self, request, pass_id):
        # Получаем все записи по pass_id
        relations = BooksInRelations.objects.filter(pass_id=pass_id)

        # Подготовка результата
        results = []
        status_translation = {
            'on_hands': 'На руках',
            'reservation': 'Бронь',
            'favorite': 'Избранное',
        }

        for relation in relations:
            book = relation.book_id  # Достаем объект книги из отношения
            results.append({
                "id": relation.id,  # Используем id отношения
                "relation": status_translation.get(relation.relation, relation.relation),  # Перевод статуса
                "book_id": book.book_id,  # ID книги
                "name": book.name,  # Название книги
                "description": book.description,  # Описание книги
                "author": book.author,  # Автор книги
                "count": book.count,  # Количество книг
                "image": book.image.url if book.image else None,  # URL изображения книги
                "pass_id": relation.pass_id.pass_id  # ID пользователя
            })

        return Response(results, status=status.HTTP_200_OK)
