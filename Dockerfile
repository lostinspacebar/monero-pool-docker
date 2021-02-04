FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

RUN apt-get update && apt-get install build-essential cmake pkg-config libboost-all-dev libssl-dev libzmq3-dev libunbound-dev \
    libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev doxygen graphviz libpgm-dev qttools5-dev-tools \
    libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev git -y
RUN apt-get update && apt-get install liblmdb-dev libevent-dev libjson-c-dev uuid-dev xxd -y

WORKDIR /app

# Build Monero
RUN git clone --recursive https://github.com/monero-project/monero
WORKDIR /app/monero

RUN git checkout release-v0.17
RUN make

WORKDIR /app

# Build Monero Pool
ENV MONERO_ROOT=/app/monero
RUN git clone https://github.com/jtgrassie/monero-pool.git

WORKDIR /app/monero-pool
RUN make release

COPY pool.conf ./

ENTRYPOINT ["/app/monero-pool/build/release/monero-pool", "--config-file", "/app/monero-pool/pool.conf"]