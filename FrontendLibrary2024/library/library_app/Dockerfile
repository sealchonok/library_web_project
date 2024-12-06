# Используем официальный образ Flutter
FROM cirrusci/flutter:latest

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем pubspec.yaml и pubspec.lock
COPY pubspec.* ./

# Устанавливаем зависимости
RUN flutter pub get

# Копируем остальные файлы проекта
COPY . .

# Собираем проект
RUN flutter build web

# Указываем команду для запуска приложения
CMD ["flutter", "run", "--web-server", "--web-port=8080"]
