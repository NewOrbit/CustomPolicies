# NewOrbit Custom Policies

A repository containing a number of Custom [Policies](https://learn.microsoft.com/en-us/azure/governance/policy/overview) for Azure recommended by NewOrbit.

You can use the button below to apply custom policies to your azure subscription. This will deploy the policies to the subscription you select on the Azure Page.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FNewOrbit%2FCustomPolicies%2Frefs%2Fheads%2Fchore%2Ftidy-custom-policies%2Fmain.json)

**_This project Currently contains Minimal azure custom Policies with the idea of expanding existing and adding new Policy Sets_**

## Updating Policies

The File `main.json` is used when clicking on the `Deploy to azure` button.
This button will load an MS Azure custom deployment page where you can select the subscription and the policies you wish to apply.

All policy definitions were historically defined in the policies.json file with policy assignments defined in the main.bicep file. Going forward we'd like to create both policy definitions and assignments in bicep.
This file is generated so when you want to add new selectable policies within the MS Deployment page, simple modify the `main.bicep` and build the bicep file (`az bicep build --file main.bicep`) to generate the new `main.json` file and commit them together. Alternativly simple push the changes to bicep files to github, raise a PR and GitHub Actions will do the rest.

## Policies included

### Tag Policies

These policies will enforce tagging on resource group creation, and also supply a remediation to apply resource groups tags to children resources.  

- Require Scale tag on resource group
- Require Environment tag on resource group
- Require Owner tag on resource group
- Copying Owner tag from resource groups

### Cosmos Policies

These policies will enforce and alert on known "bad" configurations for CosmosDb.

- Enforce that Multi region write is disabled on a cosmos resources
- Auditing that you have an alert configured that will monitor your partition key sizes.

### Application Insight Policies

These policies will enforce that application insights has a data cap set.

## Removing Policy sets

To remove any policy sets that have been created via this solution you can click [here](https://portal.azure.com/#view/Microsoft_Azure_Policy/PolicyMenuBlade/~/Definitions),
making sure you are in the correct tenant where the policies where applied. You can then remove the definitions and assignments that are no longer required.
