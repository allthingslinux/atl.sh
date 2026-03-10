FROM debian:trixie

# Install systemd, SSH, and Python for Ansible
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    openssh-server \
    python3 \
    python3-apt \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Copy dev SSH key
COPY .ssh/dev_key.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Enable SSH service
RUN systemctl enable ssh

VOLUME ["/sys/fs/cgroup"]

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]
