FROM node:carbon-alpine

# Contains only needed libs from oracle instant client: 
# "*/libociei.so */libons.so */libnnz12.so */libclntshcore.so.12.1 */libclntsh.so.12.1"
ENV CLIENT_FILENAME instantclientlibs-linux.x64-12.1.0.1.0.tar.gz

COPY ${CLIENT_FILENAME} /usr/lib

# libaio and libnsl are necessary, the latter is only available as package in the edge repository
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --update libaio libnsl && \
    ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1 && \
    apk add --no-cache git && \
    cd /usr/lib && \
    tar xf ${CLIENT_FILENAME} && \
    ln -s /usr/lib/libclntsh.so.12.1 /usr/lib/libclntsh.so && \
    rm ${CLIENT_FILENAME}