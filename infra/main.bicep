// az deployment group create -f ./main.bicep -g rg-name
// az deployment sub create -f ./main.bicep -l location

targetScope = 'subscription'

@description('The environment that the resources are being deployed to.')
@allowed([
  'DEV'
  'QA'
  'PROD'
])
param environment string
param planName string
param rgName string
param webAppName string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: deployment().location
}

module appPlanDeploy 'appPlan.bicep' = {
  name: 'appPlanDeploy'
  scope: rg
  params: {
    environment: environment
    planName: planName    
  }
}

module webAppDeploy 'webApp.bicep' = {
  name: 'webAppDeploy'
  scope: rg
  params: {
    planId: appPlanDeploy.outputs.planId
    webAppName: webAppName
  }
}

module slotDeploy 'slot.bicep' = if (environment == 'PROD') {
  name: 'slotDeploy'
  scope: rg
  params: {
    planId: appPlanDeploy.outputs.planId
    slotName: 'stage'
    webAppName: webAppName
  }
}

output output1 string = environment
output webAppName string = webAppName