#Multi-stage build
# Stage 1: Build the app in image 'builder'
FROM golang:1.14-alpine AS builder
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/github.com/gotechworld/golang/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Stage 2: Copy the app from 'builder' image to 'app' image
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/gotechworld/golang/app .
CMD ["./app"]
