# CustomPolicies

You can use the button below to apply custom policies to your azure subscription. This will deploy the policies to the subscription you select on the Azure Page.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FNewOrbit%2FCustomPolicies%2Fmain%2FBicepToArmTemplate%2Finfrastructure%2Fbicep-json%2Fpolicy-assignments.json%3Ftoken%3DGHSAT0AAAAAACCW2DQ3PMD6QIRTQTWNCBEGZQYBOAA)

# Tag Policies

These policies will enforce tagging on resource group creation, and also supply a remediation to apply resource groups tags to children resources.  

- Require Scale tag on resource group
- Require Environment tag on resource group
- Require Owner tag on resource group

# Cosmos Policies

These policies will enforce Multi region write is disabled on a cosmos resource.

# Application Insight Policies

These policies will enforce that application insights has a data cap set.
