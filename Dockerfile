# Dockerfile to package Mendix project (build from mpr file to mda file)
ARG PACKAGE_BASE_IMAGE=ubuntu:noble
FROM ${PACKAGE_BASE_IMAGE} AS package

ARG SOURCE_PATH=./
ARG MXBUILD_URL=https://cdn.mendix.com/runtime/mxbuild-9.24.40.80973.tar.gz
ARG MXBUILD_PATH=/opt/mxbuild
ARG JAVA_JDK_PATH=.
ARG JAVA_JDK_BIN_DEB=jdk-21_linux-x64_bin.deb
ARG JAVA_HOME_PATH=/usr/lib/jvm/jdk-21.0.9-oracle-x64/
ARG USER_UID=1001

# Check variable
RUN echo "PACKAGE_BASE_IMAGE: ${PACKAGE_BASE_IMAGE}" && \
    echo "SOURCE_PATH: ${SOURCE_PATH}" && \
    echo "MXBUILD_URL: ${MXBUILD_URL}" && \
    echo "MXBUILD_PATH: ${MXBUILD_PATH}" && \
    echo "JAVA_JDK_PATH: ${JAVA_JDK_PATH}" && \
    echo "JAVA_JDK_BIN_DEB: ${JAVA_JDK_BIN_DEB}" && \
    echo "JAVA_HOME_PATH: ${JAVA_HOME_PATH}" && \
    echo "USER_UID: ${USER_UID}"

# Install JDK
WORKDIR /tmp
COPY ${JAVA_JDK_PATH}/${JAVA_JDK_BIN_DEB} ./
RUN dpkg -i ./${JAVA_JDK_BIN_DEB}
RUN ${JAVA_HOME_PATH}/bin/java --version

# Download mxbuild kit
RUN mkdir -p /opt/mxbuild && \
    cd /opt/mxbuild && \
    curl -LJO ${MXBUILD_URL} && \
    tar -zxvf mxbuild-9.24.40.80973.tar.gz


# Build source
RUN mkdir -p /opt/source && chown -R ${USER_UID}:0 /opt/source && chmod -R g=u /opt/source
WORKDIR /opt/source
COPY ${SOURCE_PATH} ./
RUN ls -la

ENTRYPOINT ["bash"]
