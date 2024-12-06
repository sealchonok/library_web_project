from django.urls import path
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from .views import (
    BooksListCreate,
    UserAuthenticate,
    NewsList,
    BooksInRelationsCreate,
    BooksInRelationsList,
BooksInRelationsDelete,
BooksInRelationsListInfo,
BooksAddedThisWeek,
)
schema_view = get_schema_view(
    openapi.Info(
        title="Your API",
        default_version='v1',
        description="API description",
    ),
    public=True,
)

urlpatterns = [
    path('books/', BooksListCreate.as_view(), name='books-list-create'),
    path('users/authenticate/', UserAuthenticate.as_view(), name='user-authenticate'),
    path('news/', NewsList.as_view(), name='news-list'),
    path('books_in_relations/', BooksInRelationsCreate.as_view(), name='books-in-relations-create'),
    path('books_in_relations/<int:pass_id>/<int:book_id>/', BooksInRelationsDelete.as_view(), name='books-in-relations-delete'),
    path('books_in_relations/list/', BooksInRelationsList.as_view(), name='books-in-relations-list'),
    path('api/books_in_relations/list/info/<int:pass_id>/', BooksInRelationsListInfo.as_view(), name='books_in_relations_list_info'),
    path('new_books', BooksAddedThisWeek.as_view(), name='new_books'),

]


