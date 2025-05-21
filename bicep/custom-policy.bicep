targetScope = 'subscription'

@description('List of allowed locations for resource deployment.')
param listofAllowedLocations array = [
  'eastus'
  'eastus2'
]

@allowed([
  'Audit'
  'Deny'
])
@description('Effect of the policy.')
param policyEffect string = 'Deny'

@description('Scope at which the policy should be assigned.')
param assignmentScope string

resource policyDef 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'custom-allowed-location'
  properties: {
    displayName: 'Allowed Locations for Resource Deployment'
    policyType: 'Custom'
    mode: 'All'
    description: 'Restrict resource deployments to specific Azure regions.'
    metadata: {
      category: 'General'
    }
    parameters: {
      allowedLocations: {
        type: 'Array'
        metadata: {
          description: 'The list of allowed locations.'
        }
      }
      effect: {
        type: 'String'
        metadata: {
          description: 'Audit or Deny non-compliant resources.'
        }
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'location'
            notIn: '[parameters(\'allowedLocations\')]'
          }
          {
            field: 'location'
            notEquals: 'global'
          }
          {
            field: 'type'
            notEquals: 'Microsoft.AzureActiveDirectory/b2cDirectories'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}

resource policyAssign
