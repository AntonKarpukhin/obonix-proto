# Proto Monorepo

Монорепозиторий с protobuf схемами для всех Go сервисов.

## Структура

```
proto/
├── auth/             # Сервис аутентификации
│   └── auth.proto
├── payment/          # Сервис платежей (будущее)
│   └── payment.proto
└── ...

gen/go/               # Сгенерированный Go код
├── auth/v1/
└── ...
```

## Использование

### Установка зависимостей

```bash
make install
```

### Генерация Go кода

```bash
make gen
```

### Линтинг

```bash
make lint
```

### Проверка breaking changes

```bash
make breaking
```

## Добавление нового сервиса

1. Создайте папку `proto/your-service/`
2. Добавьте proto файлы с пакетом `your-service.v1`
3. Запустите `make gen`

## Использование в Go проектах

```bash
go get github.com/AntonKarpukhin/obonix-proto/gen/go/auth/v1
```

```go
import authv1 "github.com/AntonKarpukhin/obonix-proto/gen/go/auth/v1"
```

## Версионирование

Используйте семантическое версионирование:

- patch: исправления без breaking changes
- minor: новые методы/поля без breaking changes
- major: breaking changes

## CI/CD

```bash
make ci  # Все проверки перед push
```
