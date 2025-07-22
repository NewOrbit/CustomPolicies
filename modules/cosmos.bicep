targetScope = 'subscription'

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

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Cosmos-Partition-Full-Alert'
  properties: {
    policyDefinitionId: partitionAlertPolicyDefinition.id
  }
}
