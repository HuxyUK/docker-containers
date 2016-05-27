#!/bin/bash
# create .xmltv dir if it doesn't already exist
if [ ! -d /root/.xmltv ]; then
  echo "Creating XMLTV dir..."
  ln -s /config /root/.xmltv
fi

# create data dir if it doesn't already exist
if [ ! -d /data ]; then
  echo "Creating data dir..."
  mkdir /data
fi

# create cronjob
if [ ! -s "/config/cronjobs.txt" ]; then
  echo "Creating default crontab..."

cat <<'EOF' > /etc/cronjobs.txt
30 */12 * * * /usr/local/bin/grabber >> /var/log/cron.log 2>&1
# LEAVE THIS LINE BLANK
EOF
fi
