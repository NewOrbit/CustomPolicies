targetScope = 'subscription' 
var location = 'westeurope'

@description('Apply - recommended tag policies')
param applyTagPolicies bool = true

// create custom policies
var policies = json(loadTextContent('../policies/policies.json'))
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

// create custom policy set ( Initiative )
var tagInitName = 'New Orbit Tag Policies'
resource policySetDef 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = if(applyTagPolicies) {
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
          policyDefinitionReferenceId: ''
      },{
          parameters: {}
          policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Scale'
          policyDefinitionReferenceId: ''
      },{
             parameters: {}
             policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Owner'
             policyDefinitionReferenceId: ''
      },{
            parameters: {}
            policyDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Inherit Owner Tag From Resource Group'
            policyDefinitionReferenceId: ''
      }]
      policyType: 'Custom'
    }
    dependsOn: [customPolicies]
}

// assign the custom policy set ( Initiative )
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = if(applyTagPolicies) {
location: location
  name: 'Tag Policies'
  properties: {
    description: 'Require tags to exist on resource groups and resources'
    displayName: 'New Orbit recommended tag policies'
    enforcementMode: 'Default'
    nonComplianceMessages: []
    policyDefinitionId: '/subscriptions/${subscription().id}/providers/Microsoft.Authorization/policySetDefinitions/${tagInitName}'
  }
   identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [policySetDef]
}

// Add a tag role assignment to the service principal for the policy set ( initiative )
var roleIds = {
  tagContributor: '4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
}

resource policyAssignmentContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = if(applyTagPolicies) {
  name: guid(policyAssignment.id, subscription().id, roleIds.tagContributor)
  properties: {
    principalId: policyAssignment.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleIds.tagContributor)
    principalType: 'ServicePrincipal'
  }
}
