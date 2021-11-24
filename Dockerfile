FROM golang:1.12.7 as builder
WORKDIR /go/src/github.com/AliyunContainerService/image-syncer
COPY ./ ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 make

FROM alpine:latest
WORKDIR /app/
COPY --from=builder /go/src/github.com/AliyunContainerService/image-syncer/image-syncer ./
COPY --from=builder /go/src/github.com/AliyunContainerService/image-syncer/etc ./etc
RUN chmod +x ./image-syncer
RUN apk add -U --no-cache ca-certificates && rm -rf /var/cache/apk/* && mkdir -p /etc/ssl/certs \
  && update-ca-certificates --fresh
#ENTRYPOINT ["/app/image-syncer"]
#CMD ["--auth", "/app/etc/auth.json", "--images", "/app/etc/images.json"]
