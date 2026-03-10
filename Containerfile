FROM debian:trixie

# Install systemd and SSH for realistic testing
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    openssh-server \
    python3 \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN mkdir /var/run/sshd && \
    echo 'root:dev' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Enable systemd
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
