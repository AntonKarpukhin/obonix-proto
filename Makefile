.PHONY: gen lint breaking clean install

# Генерация всех файлов
gen:
	export PATH="$$(go env GOPATH)/bin:$$PATH" && \
	protoc --proto_path=proto \
		--go_out=. --go_opt=module=github.com/AntonKarpukhin/obonix-proto \
		--go-grpc_out=. --go-grpc_opt=module=github.com/AntonKarpukhin/obonix-proto \
		proto/auth/auth.proto

# Линтинг proto файлов
lint:
	buf lint

# Проверка breaking changes
breaking:
	buf breaking --against '.git#branch=main'

# Очистка сгенерированных файлов
clean:
	rm -rf obonix/

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