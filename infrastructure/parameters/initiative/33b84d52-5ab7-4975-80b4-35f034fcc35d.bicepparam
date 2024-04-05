// Jays subscription
using '../../bicep/initiative.bicep'

param location = 'westeurope'

param policySet = {
  initiativeName: 'New Orbit Default policySet'
  displayName: 'NewOrbit Gold Benefit - New Orbits recommended policies'
  category: 'compliance'
  version: '1.0.0'
  // Policies to include in the initiative policySet
  policyToInclude: [
    '/subscriptions/33b84d52-5ab7-4975-80b4-35f034fcc35d/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Environment'
    '/subscriptions/33b84d52-5ab7-4975-80b4-35f034fcc35d/providers/Microsoft.Authorization/policyDefinitions/Require A Cap On ApplicationInsights'
    '/subscriptions/33b84d52-5ab7-4975-80b4-35f034fcc35d/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Scale'
    '/subscriptions/33b84d52-5ab7-4975-80b4-35f034fcc35d/providers/Microsoft.Authorization/policyDefinitions/Multiple Write Locations'
    '/subscriptions/33b84d52-5ab7-4975-80b4-35f034fcc35d/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Owner'
    '/subscriptions/33b84d52-5ab7-4975-80b4-35f034fcc35d/providers/Microsoft.Authorization/policyDefinitions/Inherit Owner Tag From Resource Group'
  ]
  description: 'Environment tag is required, Log analytics cap is required, Requires that scalable resources have a scale tag ,Multiple Write Locations'
}
