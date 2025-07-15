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
├── obonix/auth/v1/
└── obonix/payment/v1/  # будущие сервисы
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

1. Создайте папку `proto/payment/` (или другой сервис)
2. Добавьте proto файлы с пакетом `obonix.payment.v1`
3. Обновите Makefile команду gen для нового файла
4. Запустите `make gen`

### Пример нового сервиса payment:

```protobuf
// proto/payment/payment.proto
syntax = "proto3";
package obonix.payment.v1;
option go_package = "github.com/AntonKarpukhin/obonix-proto/obonix/payment/v1;paymentv1";

service PaymentService {
  rpc ProcessPayment(PaymentRequest) returns (PaymentResponse);
}
```

## Использование в Go проектах (Google Pattern)

**Преимущества Google паттерна:**

- ✅ Один `go get` для всех сервисов
- ✅ Простое версионирование всего проекта
- ✅ Отсутствие конфликтов зависимостей
- ✅ Следует стандартам Google, Uber, других крупных компаний

```bash
# Один go get для всего проекта
go get github.com/AntonKarpukhin/obonix-proto
```

```go
import (
    authv1 "github.com/AntonKarpukhin/obonix-proto/obonix/auth/v1"
    paymentv1 "github.com/AntonKarpukhin/obonix-proto/obonix/payment/v1" // Будущие сервисы
)

// Пример использования
func main() {
    conn, _ := grpc.Dial("localhost:8080", grpc.WithInsecure())
    defer conn.Close()

    // Создание клиента
    client := authv1.NewAuthServiceClient(conn)

    // Вызов методов
    loginResp, err := client.Login(context.Background(), &authv1.LoginRequest{
        Email:    "user@obonix.com",
        Password: "password123",
        AppId:    1,
    })

    if err != nil {
        log.Fatal(err)
    }

    fmt.Printf("Login successful, token: %s\n", loginResp.Token)
}
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
