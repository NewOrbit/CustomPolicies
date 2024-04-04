@export()
type PolicySet = {
  initiativeName: string
  displayName: string
  category: string
  version: string
  policyToInclude: string[]
  description: string
}

@export()
type PolicyAssignment = {
  assignmentName: string
  assignmentDisplayName: string
  assignmentDescription: string
  assignmentEnforcementMode: string
  assignmentMessage: NonComplianceMessage[]
  assignmentParameters: string
  assignmentPolicyID: string
}

@export()
type NonComplianceMessage = {
  message: string
  policyDefinitionReferenceId: string
}
