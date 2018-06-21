FROM iron/go:dev as builder
WORKDIR /go/src/github.com/vapor-ware/sandbox-plugin
COPY . .
RUN make build CGO_ENABLED=0


FROM scratch
LABEL maintainer="vapor@vapor.io"
COPY --from=builder /go/src/github.com/vapor-ware/sandbox-plugin/build/plugin ./plugin
COPY config/plugin/config.yml /etc/synse/plugin/config/config.yml
COPY config/device/devices.yml /etc/synse/plugin/config/device/devices.yml
EXPOSE 5002
ENTRYPOINT ["./plugin"]
