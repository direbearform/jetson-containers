ARG VERSION_ID
FROM ubuntu:${VERSION_ID}


RUN apt-get update && apt-get install -y \
    apt-utils \
    bzip2 \
    curl \
    lbzip2 \
    libpython-stdlib \
    perl \
    python \
    python-minimal \
    python2.7 \
    python2.7-minimal \
    sudo \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG DRIVER_PACK_URL
ARG DRIVER_PACK
ARG DRIVER_PACK_SHA

RUN curl -sL ${DRIVER_PACK_URL}/${DRIVER_PACK} -o ${DRIVER_PACK} && \
    echo "${DRIVER_PACK_SHA} *./${DRIVER_PACK}" | sha1sum -c --strict - && \
    tar -xp --overwrite -f ./${DRIVER_PACK} && \
    rm /${DRIVER_PACK}

ARG ROOT_FS_URL
ARG ROOT_FS
ARG ROOT_FS_SHA

RUN curl -sL ${ROOT_FS_URL}/${ROOT_FS} -o ${ROOT_FS} && \
    echo "${ROOT_FS_SHA} *./${ROOT_FS}" | sha1sum -c --strict - && \
    cd /Linux_for_Tegra/rootfs && \
    tar -xp --overwrite -f /${ROOT_FS} && \
    rm /${ROOT_FS} && \
    cd .. && \
    ./apply_binaries.sh
 
WORKDIR /Linux_for_Tegra

ARG TARGET_BOARD
ARG ROOT_DEVICE
ENV TARGET_BOARD=$TARGET_BOARD
ENV ROOT_DEVICE=$ROOT_DEVICE
ENTRYPOINT ["sh", "-c", "sudo ./flash.sh $TARGET_BOARD $ROOT_DEVICE"]
