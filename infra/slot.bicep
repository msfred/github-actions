param location string = resourceGroup().location
param planId string
param slotName string
param webAppName string

resource slot 'Microsoft.Web/sites/slots@2021-01-15' = {
  name: '${webAppName}/${slotName}'
  location: location
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${webAppName}-${slotName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${webAppName}-${slotName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: planId
    siteConfig: {
      alwaysOn: true
    }
  }
}
