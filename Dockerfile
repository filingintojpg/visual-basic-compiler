FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        flex \
        libfl-dev \
        g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENTRYPOINT ["/app/build.sh"]
