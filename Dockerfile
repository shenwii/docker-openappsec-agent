FROM docker.io/alpine AS builder

ENV AGENT_VERSION=1.1.36

RUN apk add --no-cache \
        build-base \
        boost-dev \
        openssl-dev \
        pcre2-dev \
        libxml2-dev \
        gtest-dev \
        curl-dev \
        hiredis-dev \
        libmaxminddb-dev \
        yq \
        brotli-dev \
        zlib-dev \
        unzip \
        cmake \
        python3 \
        curl \
    && curl -f -L -O https://github.com/openappsec/openappsec/archive/refs/tags/${AGENT_VERSION}.zip \
    && unzip ${AGENT_VERSION}.zip \
    && cd openappsec-${AGENT_VERSION} \
    && cmake -DCMAKE_INSTALL_PREFIX=build_out -DCMAKE_POLICY_VERSION_MINIMUM=3.5 . \
    && make -j$(nproc) install \
    && make package \
    && mv build_out /

FROM docker.io/alpine

ENV OPENAPPSEC_NANO_AGENT=TRUE

COPY --from=builder /build_out/self_managed_openappsec_manifest.json /tmp/self_managed_openappsec_manifest.json
COPY --from=builder /build_out/install*.sh /nano-service-installers/
COPY --from=builder /build_out/entry.sh /entry.sh

RUN apk add --no-cache -u busybox zlib brotli brotli-dev bash libstdc++ boost icu-libs curl libunwind gdb libxml2 pcre2 ca-certificates coreutils \
    && chmod +x entry.sh /nano-service-installers/* \
    && ln -s entry.sh cp-nano-agent

CMD [ "/cp-nano-agent" ]
