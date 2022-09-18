FROM golang:latest

COPY app /app
WORKDIR /app
RUN go mod tidy
RUN go build -o app main.go
CMD ["/app/app"] 


# FROM golang:latest AS builder
# ADD ./app /app
# WORKDIR /app
# RUN go mod download
# RUN go build -o app main.go 

# FROM alpine:latest
# RUN apk --no-cache add ca-certificates
# COPY --from=builder /main ./
# RUN chmod +x ./main
# ENTRYPOINT ["./main"]
# EXPOSE 80
