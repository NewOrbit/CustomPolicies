targetScope = 'subscription' 

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
