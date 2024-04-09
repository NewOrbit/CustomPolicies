# CustomPolicies

Moving https://github.com/NewOrbit/Azure.Policies into this new repo which is using bicep to deploy the policies.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FNewOrbit%2FCustomPolicies%2Fmain%2FBicepToArmTemplate%2Finfrastructure%2Fbicepjson%2Fdefualt-policy-assignments.json%3Ftoken%3DGHSAT0AAAAAACCW2DQ33FSXWTJVL4EQVDMAZQVK5DA)

## Defining a subscription
A subscription is linked to parameter file using the subscription id, make sure to create these files for the subscription you want to deploy to.


## Deploying Policies
For deploying custom policy instances to a subscription use the following [script](infrastructure/deploy-custom-policy.sh).
This will loop through the policies [here](infrastructure/policies) and deploy them to the policy section within a subscription.

## Deploying Initiatives
An initiative is a set of policies that are grouped together to achieve a singular overarching goal.

For deploying initiatives to a subscription use the following [script](infrastructure/deploy-initiative.sh).
This will loop through the policies [here](infrastructure/policies) and deploy them to the policy section within a subscription.

## Deploying Policy Definitions
A policy definition is a rule that you can enforce on your resources. Each policy definition has conditions under which it's enforced. You can also define the effect that takes place when the conditions are met.

For deploying policy definitions to a subscription use the following [script](infrastructure/deploy-policy-definition.sh).

## CSP Subscriptions
Currently to do this the service principal does not have the perms needed to perform the stack deployment ( needs doing ), 
so to run the deployments you need to have permissions under your own account and then run it against the CSP subscription.

To run the scripts against a CSP subscription you need to make sure that the lighthouse [Script](https://neworbit.sharepoint.com/sites/Process/SitePages/Setup-Lighthouse-to-give-NewOrbit-access-to-the-Azure-Subscription.aspx?OR=Teams-HL&CT=1712224095755&clickparams=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiI0OS8yNDAyMjkyNDUxNyIsIkhhc0ZlZGVyYXRlZFVzZXIiOmZhbHNlfQ%3D%3D)
has been run so that the service principal has been added to the CSP tenant. This will allow the scripts to run against the CSP subscription.