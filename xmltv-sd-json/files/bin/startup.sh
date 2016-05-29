#!/bin/sh
# start-cron.sh /usr/sbin/cron -f
# variables used in script
CRONTAB="/config/cronjobs.txt"

if [ -z "$STARTUPDAYS" ]; then
  echo "Using default number of days (1) for scan. This can be overriden with a STARTUPDAYS variable."
  STARTUPDAYS=1
fi

if [ -z "$FILENAME" ]; then
  echo "Using default filename (epg.xml) for scan. This can be overriden with a FILENAME variable."
  FILENAME="epg.xml"
fi

if [ -z "$GRABBER" ]; then
  echo "Using default grabber (tv_grab_sd_json) for scan. This can be overriden with a GRABBER variable."
  GRABBER="tv_grab_sd_json"
fi

if [ -z "$OFFSET" ]; then
  echo "Using default offset duration (0) for scan. This can be overriden with a OFFSET variable."
  OFFSET="0"
fi

# starting weekly grab
case "$(pidof ${GRABBER} | wc -w)" in

0)  echo "\n"
    echo "Running startup grab:"
    if [ ! -f "/usr/local/bin/${GRABBER}" ]; then
      echo "Looking in /usr/bin for ${GRABBER}"
      if [ -f "/usr/bin/${GRABBER}" ]; then
        echo "/usr/bin/${GRABBER} --days ${STARTUPDAYS} --output ${FILENAME} --offset ${OFFSET}"
        /usr/bin/${GRABBER} --days ${STARTUPDAYS} --output /data/${FILENAME} --offset ${OFFSET}
      else
        echo "${GRABBER} not found. Exiting."
        exit 1;
      fi
    else
      echo "/usr/local/bin/${GRABBER} --days ${STARTUPDAYS} --output ${FILENAME} --offset ${OFFSET}"
      /usr/local/bin/${GRABBER} --days ${STARTUPDAYS} --output /data/${FILENAME} --offset ${OFFSET}
    fi
    ;;
1)  echo "Grabber already running"
    ;;
esac

rc=$?;
if [ $rc != 0 ]; then
  echo "\n"
  echo "Grabber failed to run. Check configuration file... /data/${GRABBER}.conf"
exit $rc;
fi

#importing custom cron tab if file exists
echo "Checking for crontab"
if [ -s $CRONTAB ]; then
  echo "\n"
  echo "Located custom crontab..."
  echo "      Installing crontab..."
  echo $CRONTAB

  crontab ${CRONTAB}

  rc=$?;
  if [ $rc != 0 ]; then
    echo "Failed!!! Check your crontab configuration."
    exit $rc;
  fi
else
  echo "Creating default crontab..."
cat <<'EOF' > ${CRONTAB}
30 */12 * * * /usr/local/bin/grabber >> /var/log/cron.log 2>&1
# LEAVE THIS LINE BLANK
EOF
  chown -R nobody:users ${CRONTAB}
  chmod +rw ${CRONTAB}
  crontab ${CRONTAB}
  echo "Done"
fi

#echo "... Success"
#touch /var/log/cron.log
#tail -F /var/log/cron.log
echo "\n"
