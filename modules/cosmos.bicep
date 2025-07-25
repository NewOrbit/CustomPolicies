targetScope = 'subscription'
import { EnforcementMode } from '../types.bicep'

param applyPolicies EnforcementMode

resource multipleWriteLocations 'Microsoft.Authorization/policyDefinitions@2025-03-01' = {
  name: 'Cosmos-Multiple-Write-Locations'
  properties: {
    displayName: 'Multiple Write Locations'
    description: 'Enabling multiple write locations can cause extra charges make sure a limit is set'
    mode: 'Indexed'
    metadata: {
      category: 'Cosmos'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.DocumentDB/databaseAccounts'
          }
          {
            field: 'Microsoft.DocumentDB/databaseAccounts/enableMultipleWriteLocations'
            exists: true
          }
          {
            field: 'Microsoft.DocumentDB/databaseAccounts/enableMultipleWriteLocations'
            notEquals: false
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource partitionAlertPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'Cosmos-Partition-Full-Alert'
  properties: {
    displayName: 'Partition Near Full Alert'
    description: 'Be alerted when a partition is near full to avoid data loss'
    mode: 'Indexed'
    metadata: {
      category: 'Cosmos'
    }
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.DocumentDB/databaseAccounts'
      }
      then: {
        effect: 'auditIfNotExists'
        details: {
          type: 'microsoft.insights/scheduledqueryrules'
          name: '[concat(field(\'name\'),\'-partition-near-full-alert\')]'
        }
      }
    }
    parameters: {}
  }
}

resource policySetDefCosmos 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
    name: 'NewOrbit CosmosDb Policies'
    properties: {
      description: 'Applies NewOrbit CosmosDb Policies'
      displayName: 'NewOrbit CosmosDb Policies'
      metadata: {
        category: 'compliance'
        version: '1.0.0'
      }
      parameters: {}
      policyDefinitions: [{
            policyDefinitionId: multipleWriteLocations.id
      },{
            policyDefinitionId: partitionAlertPolicyDefinition.id
      }]
      policyType: 'Custom'
    }
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = if(applyPolicies != 'DefinitionsOnly') {
  name: 'Cosmos Policies'
  location: deployment().location
  properties: {
    displayName: 'New Orbit recommended CosmosDb policies'
    enforcementMode: applyPolicies == 'Enforced' ? 'Default' : 'DoNotEnforce'
    nonComplianceMessages: []
    policyDefinitionId: policySetDefCosmos.id
  }
}
