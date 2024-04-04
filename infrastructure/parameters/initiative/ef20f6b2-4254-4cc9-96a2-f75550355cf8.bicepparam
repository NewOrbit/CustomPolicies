using '../../bicep/initiative.bicep'

param location = 'westeurope'

param policySet = {
  initiativeName: 'New Orbit Default policySet'
  displayName: 'New Orbit''s recommended policies'
  category: 'compliance'
  version: '1.0.0'
  // polcies to include in the initiative policySet
  policyToInclude: [
    '/subscriptions/ef20f6b2-4254-4cc9-96a2-f75550355cf8/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Environment'
    '/subscriptions/ef20f6b2-4254-4cc9-96a2-f75550355cf8/providers/Microsoft.Authorization/policyDefinitions/Require A Cap On ApplicationInsights'
  ]
  description: 'Environment tag is required, Log analytics cap is required'
}
