# --- Stage 1: Сборка бинарника ---
FROM golang:1.22-alpine AS builder

WORKDIR /build

COPY main.go .

# Отключаем CGO для статической линковки (чтобы бинарник работал в scratch/alpine)
# и собираем под Linux
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o backend main.go

# --- Stage 2: Финальный минимальный образ ---
FROM alpine:3.19

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Копируем только скомпилированный файл из предыдущего шага
COPY --from=builder /build/backend .

EXPOSE 8080

CMD ["./backend"]