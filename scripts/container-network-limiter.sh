#!/bin/sh
# DOWN_SPEED in kilobits / second
DOWN_SPEED=1000
# UP_SPEED in kilobits / second
UP_SPEED=1000

if [[ "${INTERFACE}" == veth* ]]; then
  if [[ "${ACTION}" == "add" ]]; then
    logger "runnable: limiting ${INTERFACE} network usage"
    sudo /sbin/wondershaper
  fi
fi