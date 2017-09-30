#!/bin/bash

# Exit on any error
set -e

apt-get install kubectl

# Config and authentication google cloud
echo $GOOGLE_AUTH | base64 --decode -i > ${HOME}/gcloud-service-key.json

gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
gcloud --quiet config set project $GOOGLE_PROJECT_ID
gcloud --quiet config set container/cluster $GOOGLE_CLUSTER_NAME

# Reading the zone from the env var is not working so we set it here
gcloud --quiet config set compute/zone ${GOOGLE_COMPUTE_ZONE}
gcloud --quiet container clusters get-credentials $GOOGLE_CLUSTER_NAME

# Push image to google cloud
gcloud docker -- push asia.gcr.io/${GOOGLE_PROJECT_ID}/rooms-booking-api:$CIRCLE_SHA1
chown -R ubuntu:ubuntu /home/ubuntu/.kube
kubectl patch -f deploy/staging/09-api.yml -p '{"spec":{"template":{"spec":{"containers":[{"name":"api","image":"asia.gcr.io/'"$GOOGLE_PROJECT_ID"'/rooms-booking-api:'"$CIRCLE_SHA1"'"}]}}}}'
