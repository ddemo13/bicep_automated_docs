using '../main.bicep'

param addressSpace =  '10.0.0.0/16'

param vnetName = 'dev-vnet'
param location = 'eastus'
param subnet1Name = 'subnet1'
param subnet1Prefix = '10.0.1.0/24'
param subnet2Name = 'subnet2'
param subnet2Prefix = '10.0.2.0/24'
