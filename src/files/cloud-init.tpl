#cloud-config
package_update: true
packages:
  - nginx
  - curl
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - apt-get install -y cron
  - |
    echo "*/10 * * * * root \
    curl -s https://${storage_account_name}.blob.core.windows.net/${storage_container_name}/index.html \
      -o /var/www/html/index.html" > /etc/cron.d/sync-web
  - chmod 0644 /etc/cron.d/sync-web
