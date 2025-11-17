#!/bin/bash
set -e

# 写入公钥到 authorized_keys
if [ -n "$SSH_PUBLIC_KEY" ]; then
  mkdir -p /home/${SSH_USER}/.ssh
  echo "$SSH_PUBLIC_KEY" > /home/${SSH_USER}/.ssh/authorized_keys
  chmod 600 /home/${SSH_USER}/.ssh/authorized_keys
  chown -R ${SSH_USER}:${SSH_USER} /home/${SSH_USER}/.ssh
fi

# 写入证书内容到 stunnel.pem
if [ -n "$STUNNEL_CERT" ]; then
  echo "$STUNNEL_CERT" > /etc/stunnel/stunnel.pem
fi

# 启动 SSH
service ssh start

# 启动 stunnel
exec stunnel /etc/stunnel/stunnel.conf
