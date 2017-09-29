#!/bin/bash

# Exit on any error
set -e

PATH=/google-cloud-sdk/bin:$PATH

apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    curl \
    openjdk-7-jre
curl https://sdk.cloud.google.com | bash
cat /root/google-cloud-sdk/path.bash.inc | bash
cat /root/google-cloud-sdk/completion.bash.inc | bash

# Confirguration Google Cloud
/root/google-cloud-sdk/bin/gcloud --quiet components update
/root/google-cloud-sdk/bin/gcloud --quiet components update kubectl
echo $GOOGLE_AUTH | base64 --decode -i > ${HOME}/gcloud-service-key.json

/root/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
/root/google-cloud-sdk/bin/gcloud --quiet config set project $GOOGLE_PROJECT_ID
/root/google-cloud-sdk/bin/gcloud --quiet config set container/cluster $GOOGLE_CLUSTER_NAME

# Reading the zone from the env var is not working so we set it here
/root/google-cloud-sdk/bin/gcloud --quiet config set compute/zone ${GOOGLE_COMPUTE_ZONE}
/root/google-cloud-sdk/bin/gcloud --quiet container clusters get-credentials $GOOGLE_CLUSTER_NAME
