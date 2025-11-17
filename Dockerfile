# Dockerfile (SSH + stunnel)
FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y openssh-server stunnel4 && \
    rm -rf /var/lib/apt/lists/*

# SSH
RUN mkdir -p /var/run/sshd && ssh-keygen -A

ARG SSH_USER=proxyuser
ARG SSH_PASS=proxyuser
RUN useradd -m -s /bin/bash ${SSH_USER} && \
    echo "${SSH_USER}:${SSH_PASS}" | chpasswd

# 可选：公钥认证（更安全）
ENV SSH_PUBLIC_KEY=""
COPY entrypoint.sh /entrypoint.sh
COPY stunnel.conf /etc/stunnel/stunnel.conf
COPY stunnel.pem /etc/stunnel/stunnel.pem
RUN chmod +x /entrypoint.sh

EXPOSE 22 443
ENTRYPOINT ["/entrypoint.sh"]
