# Build in a stock Go builder container
FROM golang:1.11-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-abassian

RUN apk add --no-cache git

RUN cd /go-abassian \
    && git clone https://github.com/abassian/go-abassian \
    && cd go-abassian \
    && make all

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-abassian/go-abassian/build/bin/bootnode /usr/local/bin/

# Copy bootkey
RUN mkdir /root/.abassian
COPY --from=builder /go-abassian/bootnode.key /root/.abassian/boot.key
# COPY ${BOOTKEY_PATH} /root/.abassian/boot.key


EXPOSE 30313 30313/udp
ENTRYPOINT ["bootnode"]

CMD ["-nodekey", "/root/.abassian/boot.key", "-verbosity", "9"]
