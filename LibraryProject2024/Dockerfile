# Используйте официальный образ Python
FROM python
# Установим переменную окружения для кодировки
ENV PYTHONIOENCODING=utf-8

# Устанавливаем рабочую директорию
WORKDIR /library

# Копируем файл зависимостей в контейнер
COPY ../requirements.txt ./

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь код приложения в контейнер
COPY . .

# Экспортируем порт, на котором будет работать приложение
EXPOSE 8000

# # Указываем команду для запуска приложения
ENTRYPOINT ["python", "library/manage.py"]
CMD ["runserver", "0.0.0.0:8000"]

