#!/bin/bash

set -e
cmd="$@"

until $(curl --output /dev/null --silent --head --fail "$RABBIT_ADMIN_HOST"); do
    echo 'RabbitMQ is unavailable - sleeping'
    sleep 5
done
echo 'RabbitMQ is up - executing command'

exec $cmd
