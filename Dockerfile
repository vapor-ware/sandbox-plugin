# Builder Image
FROM vaporio/golang:1.13 as builder
WORKDIR /go/src/github.com/vapor-ware/sandbox-plugin
COPY . .

# If the vendored dependencies are not present in the docker build context,
# we'll need to do the vendoring prior to building the binary.
RUN go mod download
RUN make build CGO_ENABLED=0


# Plugin Image
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /go/src/github.com/vapor-ware/sandbox-plugin/build/plugin ./plugin

# Build the device configurations directly into the image. This is not
# generally advised, but is acceptable here since the plugin is merely
# an example for sandboxing and its config is not tied to anything real.
COPY config/device/devices.yml /etc/synse/plugin/config/device/devices.yml
COPY config/plugin/config.yml  /etc/synse/plugin/config/config.yml

EXPOSE 5002
ENTRYPOINT ["./plugin"]
