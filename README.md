# CustomPolicies

You can use the button below to apply custom policies to your azure subscription. This will deploy the policies to the subscription you select on the Azure Page.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FNewOrbit%2FCustomPolicies%2Fmain%2FBicepToArmTemplate%2Finfrastructure%2Fbicep-json%2Fpolicy-assignments.json)

**_This project Currently contains Minimal azure custom Policies with the idea of expanding existing and adding new Policy Sets_**

## Updating Policies

The File `BicepToArmTemplate/infrastructure/bicep-json/policy-assignments.json` is used when clicking on the `Deploy to azure` button.
This button will load an MS Azure custom deployment page where you can select the subscription and the policies you wish to apply.

This file is generated so when you want to add new selectable policies within the MS Deployment page,
simple modify the `policy-assignments.bicep` and build the project to generate the new `policy-assignments.json` file.  

## Tag Policies

These policies will enforce tagging on resource group creation, and also supply a remediation to apply resource groups tags to children resources.  

- Require Scale tag on resource group
- Require Environment tag on resource group
- Require Owner tag on resource group

## Cosmos Policies

These policies will enforce Multi region write is disabled on a cosmos resource.

## Application Insight Policies

These policies will enforce that application insights has a data cap set.

## Removing Policy sets

To remove any policy sets that have been created via this solution you can click [here](https://portal.azure.com/#view/Microsoft_Azure_Policy/PolicyMenuBlade/~/Definitions),
making sure you are in the correct tenant where the policies where applied. You can then remove the definitions and assignments that are no longer required.
