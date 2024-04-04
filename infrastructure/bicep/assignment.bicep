// we need to seprate sub and resource group assignments in dif modules
targetScope = 'subscription'

import { PolicyAssignment } from '../types/types.bicep'

param location string
param assignment PolicyAssignment

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: assignment.assignmentName
  properties: {
    description: assignment.assignmentDescription
    displayName: assignment.assignmentDisplayName
    enforcementMode: assignment.assignmentEnforcementMode
    nonComplianceMessages: assignment.assignmentMessage
    // parameters: assignment.assignmentParameters
    policyDefinitionId: assignment.assignmentPolicyID
  }
}
