#!/bin/bash

# Exit on any error
set -e

export API_IMAGE=asia.gcr.io/$GOOGLE_PROJECT_ID/${GOOGLE_PROJECT_NAME}-api:$CIRCLE_SHA1
JOB_IMAGE=asia.gcr.io/$GOOGLE_PROJECT_ID/${GOOGLE_PROJECT_NAME}-job:$CIRCLE_SHA1
echo "Deploying $API_IMAGE"

# Clean any old deploy-tasks jobs
kubectl delete job api-migration-job -n rb-staging 2> /dev/null || true

# Create new deploy-tasks jobs
cat deploy/staging/13-deploy-tasks-job.yml.tmpl | envsubst | kubectl apply -f -

while true; do
  phase=`kubectl get pods -n rb-staging -a --selector="name=api-migration-job" -o 'jsonpath={.items[0].status.phase}' || 'false'`
  if [[ "$phase" != 'Pending' ]] && [[ "$phase" != 'Running' ]] ; then
    break
  fi
done

echo '=========== deploying output ==========='
if [[ `kubectl get pods -n rb-staging -a --selector="name=api-migration-job" -o 'jsonpath={.items[0].status.phase}'` != 'Succeeded' ]]; then
  kubectl attach $(kubectl get pods -n rb-staging -a --selector="name=api-migration-job" -o 'jsonpath={.items[0].metadata.name}') -n rb-staging
fi

while true; do
  phase=`kubectl get pods -n rb-staging -a --selector="name=api-migration-job" -o 'jsonpath={.items[0].status.phase}'`
  echo "Deploy task job status: $phase"
  if [[ "$phase" == "Succeeded" ]]; then
    break
  elif [[ "$phase" == "Failed" ]]; then
    kubectl describe job api-migration-job -n rb-staging
    kubectl delete job api-migration-job -n rb-staging
    echo "Deploy canceled. Deploy tasks failed!!!"
    exit 1
  fi
done

# Deployment
kubectl patch -f deploy/staging/09-api.yml -p '{"spec":{"template":{"spec":{"containers":[{"name":"api","image":"'"$API_IMAGE"'"}]}}}}'

echo "Deploying $JOB_IMAGE"

kubectl patch -f deploy/staging/11-background-job.yml -p '{"spec":{"template":{"spec":{"containers":[{"name":"api","image":"'"$JOB_IMAGE"'"}]}}}}'
kubectl describe deployment api -n rb-staging
kubectl delete job api-migration-job  -n rb-staging || true
kubectl rollout status deployment/api -n rb-staging
kubectl rollout status deployment/background-job -n rb-staging

