import { PolicySet } from '../types/types.bicep'

targetScope = 'subscription' 

param policySet PolicySet
param location string

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
}
