from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import Books
from .models import User
from .models import News
from .models import BooksInRelations

admin.site.register(Books)
admin.site.register(User)
admin.site.register(News)
admin.site.register(BooksInRelations)
