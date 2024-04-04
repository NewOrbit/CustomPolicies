#!/bin/bash
SUBSCRIPTION_ID=$1
TENANT_ID=$2

echo 'bicep upgrade'
az bicep upgrade
echo 'logging in to tenant'
az account get-access-token -t "$TENANT_ID" -o none || az login -t "$TENANT_ID"
az account set --subscription "$SUBSCRIPTION_ID"

echo 'Deploying custom-policy.bicep'
deploymentName="$SUBSCRIPTION_ID-Custom-Policies"
export DETACHED_RESOURCES=$(az stack sub create --name $deploymentName -f bicep/custom-policy.bicep -l 'westeurope' --deny-settings-mode none --yes --query detachedResources)
