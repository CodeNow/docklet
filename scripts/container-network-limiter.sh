#!/bin/sh
# DOWN_SPEED in kilobits / second
DOWN_SPEED=40960
# UP_SPEED in kilobits / second
UP_SPEED=40960

if [[ "${INTERFACE}" == veth* ]]; then
  if [[ "${ACTION}" == "add" ]]; then
    logger "runnable: limiting ${INTERFACE} network usage"
    sudo /sbin/wondershaper ${INTERFACE} $DOWN_SPEED $UP_SPEED
  fi
fi