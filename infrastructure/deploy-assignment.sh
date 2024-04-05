#!/bin/bash
SUBSCRIPTION_ID=$1
TENANT_ID=$2

LOCATION=$(az bicep build-params --file parameters/initiative/$SUBSCRIPTION_ID.bicepparam --stdout | jq -r .parametersJson | jq -r .parameters.location.value)

echo $TENANT_ID
echo $SUBSCRIPTION_ID
echo $LOCATION

echo 'bicep upgrade'
az bicep upgrade
echo 'logging in to tenant'
az account get-access-token -t "$TENANT_ID" -o none || az login -t "$TENANT_ID"
az account set --subscription "$SUBSCRIPTION_ID"

echo 'Deploying assignments.bicep'
deploymentName="$SUBSCRIPTION_ID-assignments"
export DETACHED_RESOURCES=$(az stack sub create --name $deploymentName -f bicep/assignment.bicep -l $LOCATION --deny-settings-mode none --parameters parameters/assignment/$SUBSCRIPTION_ID.bicepparam --yes --query detachedResources)
