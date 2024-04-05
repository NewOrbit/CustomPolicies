// NewOrbit Gold Benefit subscription
using '../../bicep/assignment.bicep'

param location = 'westeurope'

param assignment = {
   assignmentName: 'Default policies'
   assignmentDisplayName: 'NewOrbit Gold Benefit - New Orbit Assignment Policies Set'
   assignmentDescription: 'Assigning default policies to NewOrbit Gold Benefit'
   // hard coding this for now refrence to a initiative should probably be an array
   assignmentPolicyID: '/subscriptions/33b84d52-5ab7-4975-80b4-35f034fcc35d/providers/Microsoft.Authorization/policySetDefinitions/New Orbit Default policySet'
   assignmentEnforcementMode: 'Default'
   assignmentMessage:  [
    {
      message: 'Require environment tag on resource group'
      // hard coded for now get this id from the policy definition in azure
      policyDefinitionReferenceId: '6607024119575222438'
    }
    {
      message: 'Require a log cap on ApplicationInsights'
      policyDefinitionReferenceId: '14965704575987657637'
    }
    {
      message: 'Require Scale tag on resource group'
      policyDefinitionReferenceId: '2524889508089388851'
    }
    {
      message: 'Require Owner tag on resource group'
      policyDefinitionReferenceId: '4054503176394529817'
     }
    {
      message: 'Multiple Write Locations should be disabled as it causes extra costing'
      policyDefinitionReferenceId: '17788964836455942337'
    }
    {
      message: 'Trying to apply a owner resource group tag to its child resource'
      policyDefinitionReferenceId: '14793846714976666149'
    }
   ]
   assignmentParameters: ''
}
