using '../../bicep/assignment.bicep'

param location = 'westeurope'

param assignment = {
   assignmentName: 'Default policies'
   assignmentDisplayName: 'Default policies'
   assignmentDescription: 'Assiging default policies to jays subscription'
   // hard coding this for now refrence to a initiative should probably be an array
   assignmentPolicyID: '/subscriptions/a310ab4a-8043-4cb3-96b4-99546eee4dc3/providers/Microsoft.Authorization/policySetDefinitions/New Orbit Required'
   assignmentEnforcementMode: 'Default'
   assignmentMessage:  [
    {
      message: 'Require environment tag on resource group'
      policyDefinitionReferenceId: '6139001910949832924'
    }
    {
      message: 'Require a log cap on ApplicationInsights'
      policyDefinitionReferenceId: '2456455732842287332'
    }
   ]
   assignmentParameters: ''
}
