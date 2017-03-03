FROM golang:1.8.0-alpine

ENV REV_NUM 1

RUN apk update && apk upgrade && \
    apk --no-cache --update add git && \
    go get -v github.com/uudashr/fibgo/... && \
    apk del git && rm -rf /var/cache/apk/*

WORKDIR /go

EXPOSE 8080

CMD fibgo-server -port 8080
