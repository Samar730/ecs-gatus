FROM golang:1.25.5 AS builder

WORKDIR /app

COPY app/gatus/go.mod app/gatus/go.sum ./

RUN go mod download 

COPY app/gatus/ .

RUN CGO_ENABLED=0 GOOS=linux go build -o /gatus

# Stage 2 - Running Phase

FROM alpine:3.21

WORKDIR /app

COPY --from=builder /gatus /app/gatus 

COPY app/gatus/config/config.yaml /config/config.yaml

RUN adduser --disabled-password --no-create-home appuser

USER appuser

EXPOSE 8080

CMD ["/app/gatus"]
