#!/bin/bash
#

HALT_URL="http://www.biblioteca.iq.unesp.br/~shutdown/ordinary/index.htm"
HALT_CMD=$(curl -L $HALT_URL 2> /dev/null)

if [ $HALT_CMD == "off" ]; then
  echo $(date) >> shutdown.log
  /sbin/poweroff
fi
