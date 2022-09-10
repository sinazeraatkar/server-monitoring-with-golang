FROM golang:latest

COPY server-monitoring-main /server-monitoring-main
WORKDIR /server-monitoring-main
RUN go install github.com/swaggo/swag/cmd/swag@latest
RUN go mod tidy
RUN swag init main.go
RUN go build -o server-monitoring-main main.go
CMD ["/server-monitoring-main/server-monitoring-main"] 