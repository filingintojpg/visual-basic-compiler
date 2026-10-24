FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        cmake \
        make \
        flex \
        bison \
        libfl-dev \
        g++ \
        python3 \
        graphviz \
        fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENTRYPOINT ["/app/build.sh"]
