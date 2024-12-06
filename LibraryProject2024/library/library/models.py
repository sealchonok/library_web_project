from django.db import models

class Books(models.Model):  # Модель книги
    book_id = models.AutoField(primary_key=True, unique=True)  # Уникальный ID книги
    name = models.CharField(max_length=2000)  # Наименование книги
    description = models.CharField(max_length=20000)
    author = models.CharField(max_length=1000)  # Автор
    count = models.IntegerField()  # Кол-во книг в наличии
    image = models.ImageField(upload_to='book_images/', null=True, blank=True)  # Изображение книги
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class User(models.Model):  # Модель пользователя
    pass_id = models.IntegerField(primary_key=True, unique=True)  # Уникальный номер пропуска
    full_name = models.CharField(max_length=255)  # Полное имя пользователя
    password = models.CharField(max_length=128)  # Пароль

    def __str__(self):
        return self.full_name

class News(models.Model):  # Модель новости
    news_id = models.AutoField(primary_key=True)  # Уникальный ID новости
    title = models.CharField(max_length=255)  # Заголовок новости
    message = models.TextField()  # Текст новости
    jpg = models.ImageField(upload_to='news_images/')  # Изображение новости

    def __str__(self):
        return self.title

class BooksInRelations(models.Model):  # Модель книги-отношения
    RELATION_CHOICES = [
        ('on_hands', 'На руках'),
        ('reservation', 'Бронь'),
        ('favorite', 'Избранное'),
    ]

    book_id = models.ForeignKey(Books, on_delete=models.CASCADE)  # Связь с моделью Book
    pass_id = models.ForeignKey(User, on_delete=models.CASCADE)  # Связь с моделью User
    relation = models.CharField(max_length=20, choices=RELATION_CHOICES)  # Отношение

    def __str__(self):
        return (f"Книга ID: {self.book_id.book_id}, Пользователь ID: {self.pass_id.pass_id}, "
                f"Отношение: {self.relation}")
