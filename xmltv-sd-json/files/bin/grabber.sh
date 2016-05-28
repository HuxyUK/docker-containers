#!/bin/sh
# variables used in script

if [ -z "$DAYS" ]; then
  echo "Using default number of days (1) for scan. This can be overriden with a DAYS variable."
  DAYS=1
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

# starting grab
case "$(pidof ${GRABBER} | wc -w)" in

0)  echo "\n"
    echo "Running grab:"
    if [ ! -f "/usr/local/bin/${GRABBER}" ]; then
      echo "Looking in /usr/bin for ${GRABBER}"
      if [ -f "/usr/bin/${GRABBER}" ]; then
        echo "/usr/bin/${GRABBER} --days ${DAYS} --output ${FILENAME} --offset ${OFFSET}"
        /usr/bin/${GRABBER} --days ${DAYS} --output /data/${FILENAME} --offset ${OFFSET}
      else
        echo "${GRABBER} not found. Exiting."
        exit 1;
      fi
    else
      echo "/usr/local/bin/${GRABBER} --days ${DAYS} --output ${FILENAME} --offset ${OFFSET}"
      /usr/local/bin/${GRABBER} --days ${DAYS} --output /data/${FILENAME} --offset ${OFFSET}
    fi
    ;;
1)  echo "Grabber already running"
    ;;
esac

rc=$?;
if [ $rc != 0 ]; then
  echo "... Failed!!!"
  exit $rc;
fi

echo "... Success"
