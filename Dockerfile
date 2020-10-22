# Docker image: Ubuntu 18.04 LTS (Bionic Beaver)
FROM ubuntu:18.04

ENV DEB_NI DEBIAN_FRONTEND=noninteractive

# Install packages for yocto build
RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
    xz-utils debianutils iputils-ping libsdl1.2-dev xterm curl \

# Install extra pacakges.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    locales apt-utils sudo

# For yocto build set locale to en_US.UTF-8
RUN dpkg-reconfigure locales && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# ubuntu used default shell as dash, changes to bash for yocto build
RUN rm /bin/sh && ln -s bash /bin/sh 

# Add user to sudoers.
ENV USER_NAME dev 
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME}

# Enable container to writes build artifacts outside the container (host)
# Default host uid and gid is 1000
ARG host_uid=1000
ARG host_gid=1000
RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

# run docker as $USER, switch to new user
USER $USER_NAME

WORKDIR /public/work


