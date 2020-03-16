# Dockerfile to build docker-compose for aarch64
FROM multiarch/ubuntu-debootstrap:armhf-bionic as builder
# Add env
ENV LANG C.UTF-8

# Enable cross-build for aarch64
#EnableQEMU COPY qemu-arm-static /usr/bin
RUN apt-get update && apt-get install -y python3 gcc curl vim

# Set the versions
ARG DOCKER_COMPOSE_VER
# docker-compose requires pyinstaller 3.5 (check github.com/docker/compose/requirements-build.txt)
# If this changes, you may need to modify the version of "six" below
ENV PYINSTALLER_VER 3.6
# "six" is needed for PyInstaller. v1.11.0 is the latest as of PyInstaller 3.5
ENV SIX_VER 1.11.0
RUN apt-get install -y python3-distutils wget
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py 
RUN pip install altgraph 
# Install dependencies

# Compile the pyinstaller "bootloader"
# https://pyinstaller.readthedocs.io/en/stable/bootloader-building.html
WORKDIR /build/pyinstallerbootloader
RUN wget https://github.com/pyinstaller/pyinstaller/releases/download/v3.6/PyInstaller-3.6.tar.gz --no-check-certificate && tar xvf PyInstaller-3.6.tar.gz
RUN apt-get install  -y zlib1g-dev
RUN cd PyInstaller*/ \
    && python3 setup.py install \
    && cd /
# Clone docker-compose

# Copy out the generated binary
VOLUME /dist
