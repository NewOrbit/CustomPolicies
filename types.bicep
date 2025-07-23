@description('Type of enforcement mode for the policies. DefinitionsOnly is the default and does not enforce the policies allowing you to assign the policy yourself, AuditOnly will assign the policies to everything but not enforce them, and Enforced will assign the policies and enable enforcement where the policies support it.')
@export()
type EnforcementMode = 'DefinitionsOnly' | 'AuditOnly' | 'Enforced'
