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

# 环境变量：公钥 & 证书内容
ENV SSH_PUBLIC_KEY=""
ENV STUNNEL_CERT=""

COPY stunnel.conf /etc/stunnel/stunnel.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 443
ENTRYPOINT ["/entrypoint.sh"]
