.PHONY: gen lint breaking clean install

# Генерация всех файлов
gen:
	protoc --proto_path=proto --go_out=gen/go --go_opt=paths=source_relative --go-grpc_out=gen/go --go-grpc_opt=paths=source_relative proto/auth/auth.proto

# Линтинг proto файлов
lint:
	buf lint

# Проверка breaking changes
breaking:
	buf breaking --against '.git#branch=main'

# Очистка сгенерированных файлов
clean:
	rm -rf gen/

# Установка зависимостей
install:
	go install github.com/bufbuild/buf/cmd/buf@latest
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Форматирование proto файлов
format:
	buf format -w

# Проверка и генерация
check: lint gen

# Все проверки
ci: lint breaking gen 