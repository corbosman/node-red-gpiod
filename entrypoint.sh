#!/bin/sh

set -e

echo "Starting PigPiod..."

# gpiod sometimes leaves pid files around, just clean them
rm -f /var/run/pigpio.pid 

exec /usr/local/bin/pigpiod -g $@
