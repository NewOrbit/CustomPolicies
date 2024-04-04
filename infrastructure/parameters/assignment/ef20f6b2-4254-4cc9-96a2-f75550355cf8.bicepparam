using '../../bicep/assignment.bicep'

param location = 'westeurope'

param assignment = {
   assignmentName: 'Default policies'
   assignmentDisplayName: 'New Orbit Assignment Policies Set'
   assignmentDescription: 'Assigning default policies to Adeptive Systems Ltd'
   // hard coding this for now refrence to a initiative should probably be an array
   assignmentPolicyID: '/subscriptions/ef20f6b2-4254-4cc9-96a2-f75550355cf8/providers/Microsoft.Authorization/policySetDefinitions/New Orbit Required'
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
