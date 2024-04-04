using '../../bicep/initiative.bicep'

param location = 'westeurope'

param policySet = {
  initiativeName: 'New Orbit Required'
  displayName: 'Polcies containing neworbit requirments'
  category: 'compliance'
  version: '1.0.0'
  // polcies to include in the initiative policySet
  policyToInclude: [
    '/subscriptions/a310ab4a-8043-4cb3-96b4-99546eee4dc3/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Environment'
    '/subscriptions/a310ab4a-8043-4cb3-96b4-99546eee4dc3/providers/Microsoft.Authorization/policyDefinitions/Require A Cap On ApplicationInsights'
  ]
  description: 'Environment tag is required, Log analytics cap is required'
}
