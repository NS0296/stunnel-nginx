# entrypoint.sh
#!/bin/bash
set -e

# 写入公钥到 authorized_keys（若提供）
if [ -n "$SSH_PUBLIC_KEY" ]; then
  mkdir -p /home/${SSH_USER}/.ssh
  echo "$SSH_PUBLIC_KEY" > /home/${SSH_USER}/.ssh/authorized_keys
  chmod 600 /home/${SSH_USER}/.ssh/authorized_keys
  chown -R ${SSH_USER}:${SSH_USER} /home/${SSH_USER}/.ssh
fi

# 启动 SSH
service ssh start

# 启动 stunnel（前台）
exec stunnel /etc/stunnel/stunnel.conf
