targetScope = 'subscription' 
param subscriptionId string

var location = 'westeurope'
var policySet = {
  initiativeName: 'New Orbit Defaults'
  displayName: 'Policies containing New Orbit recommended defaults'
  category: 'compliance'
  version: '1.0.0'
  policyToInclude: [
    '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Environment'
    '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require A Cap On ApplicationInsights'
    '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Scale'
    '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Multiple Write Locations'
    '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Require Tag (Resource Group) - Owner'
    '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/policyDefinitions/Inherit Owner Tag From Resource Group'
  ]
  description: 'Environment tag is required, Log analytics cap is required, Requires that scalable resources have a scale tag ,Multiple Write Locations'
}

var assignment = {
       assignmentName: 'Default policies'
       assignmentDisplayName: 'Default policies'
       assignmentDescription: 'Assiging default policies to jays subscription'
       // hard coding this for now refrence to a initiative should probably be an array
       assignmentPolicyID: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/policySetDefinitions/New Orbit Defaults'
       assignmentEnforcementMode: 'Default'
       assignmentMessage:  [
    // todo: need to potentially grab these id's from the initiative above
    //     {
    //       message: 'Require environment tag on resource group'
    //       policyDefinitionReferenceId: '6139001910949832924'
    //     }
    //     {
    //       message: 'Require a log cap on ApplicationInsights'
    //       policyDefinitionReferenceId: '2456455732842287332'
    //     }
    //     {
    //         message: 'Require Scale tag on resource group'
    //         policyDefinitionReferenceId: '3059459123121418375'
    //     }
    //     {
    //         message: 'Require Owner tag on resource group'
    //         policyDefinitionReferenceId: '5073479656525508926'
    //      }
    //     {
    //         message: 'Multiple Write Locations should be disabled as it causes extra costing'
    //         policyDefinitionReferenceId: '17905769077904114754'
    //     }
    //     {
    //         message: 'Trying to apply a resource group tag to its child resource'
    //         policyDefinitionReferenceId: '11981946151258641763'
    //     }
       ]
       assignmentParameters: ''
    }

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

resource policySetDef 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
    name: policySet.initiativeName
    properties: {
      description: policySet.description
      displayName: policySet.displayName 
      metadata: {
        category: policySet.category
        version: policySet.version
      }
      parameters: {}
      policyDefinitions: [for Id in policySet.policyToInclude: {
          parameters: {}
          policyDefinitionId: Id
          policyDefinitionReferenceId: ''
      }]
      policyType: 'Custom'
    }
    dependsOn: [customPolicies]
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
location: location
  name: assignment.assignmentName
  properties: {
    description: assignment.assignmentDescription
    displayName: assignment.assignmentDisplayName
    enforcementMode: assignment.assignmentEnforcementMode
    nonComplianceMessages: assignment.assignmentMessage
    // parameters: assignment.assignmentParameters
    policyDefinitionId: assignment.assignmentPolicyID
  }
   identity: {
          type: 'SystemAssigned'
      }
      dependsOn: [policySetDef]
}

var roleIds = {
  tagContributer: '4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
}

resource policyAssignmentContributer 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(policyAssignment.id, subscription().id, roleIds.tagContributer)
  properties: {
    principalId: policyAssignment.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleIds.tagContributer)
    principalType: 'ServicePrincipal'
  }
}
