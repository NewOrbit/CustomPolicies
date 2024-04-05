targetScope = 'subscription'

import { PolicyAssignment } from '../types/types.bicep'

param location string
param assignment PolicyAssignment

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
}

var roleIds = {
  tagContributer: '4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
}

resource policyAssignmentContributer 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(policyAssignment.id, roleIds.tagContributer)
  properties: {
    principalId: policyAssignment.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleIds.tagContributer)
    principalType: 'ServicePrincipal'
  }
}