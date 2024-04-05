// NewOrbit Gold Benefit subscription
using '../../bicep/assignment.bicep'

param location = 'westeurope'

param assignment = {
   assignmentName: 'Default policies'
   assignmentDisplayName: 'NewOrbit Gold Benefit - New Orbit Assignment Policies Set'
   assignmentDescription: 'Assigning default policies to NewOrbit Gold Benefit'
   // hard coding this for now refrence to a initiative should probably be an array
   assignmentPolicyID: '/subscriptions/ef20f6b2-4254-4cc9-96a2-f75550355cf8/providers/Microsoft.Authorization/policySetDefinitions/New Orbit Default policySet'
   assignmentEnforcementMode: 'Default'
   assignmentMessage:  [
    {
      message: 'Require environment tag on resource group'
      // hard coded for now get this id from the policy definition in azure
      policyDefinitionReferenceId: ''
    }
    {
      message: 'Require a log cap on ApplicationInsights'
      policyDefinitionReferenceId: ''
    }
    {
      message: 'Require Scale tag on resource group'
      policyDefinitionReferenceId: ''
    }
    {
      message: 'Require Owner tag on resource group'
      policyDefinitionReferenceId: ''
     }
    {
      message: 'Multiple Write Locations should be disabled as it causes extra costing'
      policyDefinitionReferenceId: ''
    }
   ]
   assignmentParameters: ''
}
