#!/bin/bash

# Exit on any error
set -e

export IMAGE=asia.gcr.io/$GOOGLE_PROJECT_ID/rooms-booking-api:$CIRCLE_SHA1

echo "Deploying $IMAGE"

# Clean any old deploy-tasks jobs
kubectl delete job api-migration-job 2> /dev/null || true

# Create new deploy-tasks jobs
cat deploy/staging/13-deploy-tasks-job.yml.tmpl | envsubst | kubectl apply -f -

while true; do
  phase=`kubectl get pods -n rb-staging -a --selector="name=api-migration-job" -o 'jsonpath={.items[0].status.phase}' || 'false'`
  if [[ "$phase" != 'Pending' ]]; then
    break
  fi
done

echo '=============== deploy_tasks output'
if [[ `kubectl get pods -n rb-staging -a --selector="name=api-migration-job" -o 'jsonpath={.items[0].status.phase}'` != 'Succeeded' ]]; then
  kubectl attach $(kubectl get pods -n rb-staging -a --selector="name=api-migration-job" -o 'jsonpath={.items[0].metadata.name}')
fi
echo '==============='

while true; do
  phase=`kubectl get pods -n rb-staging -a --selector="name=api-migration-job" -o 'jsonpath={.items[0].status.phase}'`
  echo "Deploy task job status: $phase"
  if [[ "$phase" == "Succeeded" ]]; then
    break
  elif [[ "$phase" == "Failed" ]]; then
    kubectl describe job api-migration-job
    kubectl delete job api-migration-job
    echo "Deploy canceled. Deploy tasks failed!!!"
    exit 1
  fi
done

# Deployment
kubectl patch -f deploy/staging/09-api.yml -p '{"spec":{"template":{"spec":{"containers":[{"name":"api","image":'"$IMAGE"'}]}}}}'
kubectl describe -f deploy/staging/09-api.yml
kubectl delete job api-migration-job || true
kubectl rollout status -f deploy/staging/09-api.yml
