#!/bin/bash

# Exit on any error
set -e

SHA1=$1

gcloud docker -- push asia.gcr.io/${GOOGLE_PROJECT_NAME}/rooms-booking-api:$SHA1
# sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube
kubectl patch -f deploy/staging/09-api.yml -p '{"spec":{"template":{"spec":{"containers":[{"name":"api","image":"asia.gcr.io/rooms-booking-177603/rooms-booking-api:'"$SHA1"'"}]}}}}'
