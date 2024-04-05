// Jays subscription
using '../../bicep/initiative.bicep'

param location = 'westeurope'

param policySet = {
  initiativeName: 'New Orbit Required'
  displayName: 'Policies containing New Orbit recommended defaults'
  category: 'compliance'
  version: '1.0.0'
  // Policies to include in the initiative policySet
  policyToInclude: [
    '/subscriptions/a310ab4a-8043-4cb3-96b4-99546eee4dc3/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Environment'
    '/subscriptions/a310ab4a-8043-4cb3-96b4-99546eee4dc3/providers/Microsoft.Authorization/policyDefinitions/Require A Cap On ApplicationInsights'
    '/subscriptions/a310ab4a-8043-4cb3-96b4-99546eee4dc3/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Scale'
    '/subscriptions/a310ab4a-8043-4cb3-96b4-99546eee4dc3/providers/Microsoft.Authorization/policyDefinitions/Multiple Write Locations'
    '/subscriptions/a310ab4a-8043-4cb3-96b4-99546eee4dc3/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Owner'
    '/subscriptions/a310ab4a-8043-4cb3-96b4-99546eee4dc3/providers/Microsoft.Authorization/policyDefinitions/Inherit Owner Tag From Resource Group'
  ]
  description: 'Environment tag is required, Log analytics cap is required, Requires that scalable resources have a scale tag ,Multiple Write Locations'
}
