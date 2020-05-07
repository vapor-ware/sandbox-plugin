#
# Builder Image
#
FROM vaporio/foundation:bionic as builder

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates

#
# Final Image
#
FROM scratch

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="vaporio/sandbox-plugin" \
      org.label-schema.vcs-url="https://github.com/vapor-ware/sandbox-plugin" \
      org.label-schema.vendor="Vapor IO"

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Build the device configurations directly into the image. This is not
# generally advised, but is acceptable here since the plugin is merely
# an example for sandboxing and its config is not tied to anything real.
COPY config/device/devices.yml /etc/synse/plugin/config/device/devices.yml
COPY config/plugin/config.yml  /etc/synse/plugin/config/config.yml

# Copy the executable.
COPY sandbox-plugin ./plugin

EXPOSE 5001
ENTRYPOINT ["./plugin"]
