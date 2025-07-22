targetScope = 'subscription' 

@description('Apply - Require Tags on resource groups')
param applyRequireResourceGroupTags bool = true
@description('Apply - should not have multiple write locations enabled on cosmos db')
param applyMultiWriteLocations bool = true
@description('Apply - should have a cap applied to application-insights')
param applyApplicationInsightsCap bool = true
@description('Apply - cosmos db partition near full alert')
param applyCosmosDbPartitionNearFullAlert bool = true

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

// create custom policy set ( Tag Initiative )
var tagInitName = 'Require Tags'
resource policySetDef 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = if(applyRequireResourceGroupTags) {
    name: tagInitName
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

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = if(applyRequireResourceGroupTags) {
location: deployment().location
  name: 'Tag Policies'
  properties: {
    description: 'Require tags to exist on resource groups and resources'
    displayName: 'New Orbit recommended tag policies'
    enforcementMode: 'Default'
    nonComplianceMessages: []
    policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/${tagInitName}'
  }
   identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [policySetDef]
}

var roleIds = {
  tagContributor: '4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
}

resource policyAssignmentContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = if(applyRequireResourceGroupTags) {
  name: guid(policyAssignment.id, subscription().subscriptionId, roleIds.tagContributor)
  properties: {
    principalId: policyAssignment.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleIds.tagContributor)
    principalType: 'ServicePrincipal'
  }
}

// create custom policy set ( Cosmos Initiative )
var cosmosInitName = 'Cosmos Multiple Write Locations to be disabled'
resource policySetDefCosmos 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = if(applyMultiWriteLocations) {
    name: cosmosInitName
    properties: {
      description: 'Require Multiple Write Locations to be disabled as it has a cost implication'
      displayName: 'Cosmos Multi Write Policy'
      metadata: {
        category: 'compliance'
        version: '1.0.0'
      }
      parameters: {}
      policyDefinitions: [{
            parameters: {}
            policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Multiple Write Locations'
      }]
      policyType: 'Custom'
    }
    dependsOn: [customPolicies]
}

resource policyAssignmentCosmos 'Microsoft.Authorization/policyAssignments@2021-06-01' = if(applyMultiWriteLocations) {
location: deployment().location
  name: 'Cosmos Multi Write Policy'
  properties: {
    description: 'Require Multiple Write Locations to be disabled as it has a cost implication'
    displayName: 'Require Multiple Write Locations to be disabled'
    enforcementMode: 'Default'
    nonComplianceMessages: []
    policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/${cosmosInitName}'
  }
   identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [policySetDefCosmos]
}

// create custom policy set ( App Insights Initiative )
var appInsightsInitName = 'Cap Required on App Insights'
resource policySetDefAppInsights 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = if(applyApplicationInsightsCap) {
    name: appInsightsInitName
    properties: {
      description: 'Require a cap on application-insights'
      displayName: 'Require A Cap On ApplicationInsights'
      metadata: {
        category: 'compliance'
        version: '1.0.0'
      }
      parameters: {}
      policyDefinitions: [{
            parameters: {}
            policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require A Cap On ApplicationInsights'
      }]
      policyType: 'Custom'
    }
    dependsOn: [customPolicies]
}

resource policyAssignmentAppInsights 'Microsoft.Authorization/policyAssignments@2021-06-01' = if(applyApplicationInsightsCap) {
    location: deployment().location
      name: 'Require Cap On App Insights'
      properties: {
        description: 'Require a cap on application-insights'
        displayName: 'Require A Cap On ApplicationInsights'
        enforcementMode: 'Default'
        nonComplianceMessages: []
        policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/${appInsightsInitName}'
      }
       identity: {
        type: 'SystemAssigned'
      }
      dependsOn: [policySetDefAppInsights]
}

module cosmosPartitionAlert './modules/cosmos.bicep' = if(applyCosmosDbPartitionNearFullAlert) {
  name: 'CosmosPartitionAlertPolicies'
  scope: subscription()
}
