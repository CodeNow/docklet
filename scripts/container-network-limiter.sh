#!/bin/bash
# DOWN_SPEED in kilobits / second
DOWN_SPEED=10000
# UP_SPEED in kilobits / second
UP_SPEED=10000

if [[ "${INTERFACE}" == veth* ]]; then
  if [[ "${ACTION}" == "add" ]]; then
    logger "runnable: limiting ${INTERFACE} network usage"
    sudo /sbin/wondershaper ${INTERFACE} $DOWN_SPEED $UP_SPEED
  fi
fi

sudo renice -n 20 -p $(pgrep -P `pgrep -f /usr/bin/docker`) >> /var/log/docker_limit