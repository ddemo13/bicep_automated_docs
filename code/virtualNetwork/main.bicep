param vnetName string = 'myVnet'
param location string = resourceGroup().location
param addressSpace string
param subnet1Name string = 'subnet1'
param subnet1Prefix string = '10.0.1.0/24'
param subnet2Name string = 'subnet2'
param subnet2Prefix string = '10.0.2.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
    name: vnetName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                addressSpace
            ]
        }
        subnets: [
            {
                name: subnet1Name
                properties: {
                    addressPrefix: subnet1Prefix
                }
            }
            {
                name: subnet2Name
                properties: {
                    addressPrefix: subnet2Prefix
                }
            }
        ]
    }
}
