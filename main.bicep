targetScope = 'subscription' 

import { EnforcementMode } from './types.bicep'

@description('Apply resource tag policies')
param applyTagPolicies EnforcementMode = 'DefinitionsOnly'
@description('Apply CosmosDb policies')
param applyCosmosDbPolicies EnforcementMode = 'DefinitionsOnly'
@description('Apply - should have a cap applied to application-insights')
param applyApplicationInsightsCapPolicy EnforcementMode = 'DefinitionsOnly'

// create custom policies
var policies = json(loadTextContent('./policies.json'))
resource customPolicies 'Microsoft.Authorization/policyDefinitions@2021-06-01' = [for policy in policies.definitions: {
    name: policy.properties.displayName
    properties: {
      displayName: policy.properties.displayName
      description: policy.properties.description
      policyType: 'Custom'
      mode: policy.properties.mode
      metadata: policy.properties.metadata
      parameters: policy.parameters
      policyRule: policy.rules
    }
}]

resource policySetDef 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
    name: 'Require Tags'
    properties: {
      description: 'Require tags to exist on resource groups and resources'
      displayName: 'New Orbit recommended tag policies'
      metadata: {
        category: 'compliance'
        version: '1.0.0'
      }
      parameters: {}
      policyDefinitions: [{
            parameters: {}
            policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Environment'
      },{
            parameters: {}
            policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Scale'
      },{
            parameters: {}
            policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Owner'
      },{
            parameters: {}
            policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Inherit Owner Tag From Resource Group'
      }]
      policyType: 'Custom'
    }
    dependsOn: [customPolicies]
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = if(applyTagPolicies != 'DefinitionsOnly') {
  name: 'Tag Policies'
  location: deployment().location
  properties: {
    description: 'Require tags to exist on resource groups and resources'
    displayName: 'New Orbit recommended tag policies'
    enforcementMode: applyTagPolicies == 'Enforced' ? 'Default' : 'DoNotEnforce'
    nonComplianceMessages: []
    policyDefinitionId: policySetDef.id
  }
  identity: {
    type: 'SystemAssigned'
  }
}

var roleIds = {
  tagContributor: '4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
}

resource policyAssignmentContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = if(applyTagPolicies != 'DefinitionsOnly') {
  name: guid(policyAssignment.id, subscription().subscriptionId, roleIds.tagContributor)
  properties: {
    principalId: policyAssignment.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleIds.tagContributor)
    principalType: 'ServicePrincipal'
  }
}

resource policyAssignmentRequireAppInsightsCap 'Microsoft.Authorization/policyAssignments@2021-06-01' = if(applyApplicationInsightsCapPolicy != 'DefinitionsOnly') {
    location: deployment().location
      name: 'Require Cap On App Insights'
      properties: {
        description: 'Require a cap on application-insights'
        enforcementMode: applyApplicationInsightsCapPolicy == 'Enforced' ? 'Default' : 'DoNotEnforce'
        nonComplianceMessages: []
        policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require A Cap On ApplicationInsights'
      }
       identity: {
        type: 'SystemAssigned'
      }
      dependsOn: [cosmosPolicies]
}

module cosmosPolicies './modules/cosmos.bicep' = {
  name: 'cosmosPolicies'
  scope: subscription()
  params: {
    applyPolicies: applyCosmosDbPolicies
  }
}
