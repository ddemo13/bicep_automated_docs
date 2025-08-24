# Infrastructure as Code - Bicep Repository

[![Build Status](https://github.com/ddemo13/bicep_automated_docs/workflows/Generate%20Repository%20README/badge.svg)](https://github.com/ddemo13/bicep_automated_docs/actions)
[![Last Updated](https://img.shields.io/github/last-commit/ddemo13/bicep_automated_docs)](https://github.com/ddemo13/bicep_automated_docs/commits)

> **Auto-generated README** - Last updated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")

## 📋 Overview

This repository contains Azure Infrastructure as Code (IaC) templates written in Bicep. These templates help automate the deployment and management of Azure resources with best practices and consistent configurations.

## 🏗️ Repository Structure

```
$(tree -I '.git|node_modules|.readme-temp' -a)
```

## 🚀 Quick Start

### Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured
- [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) installed
- An active Azure subscription

### Basic Deployment

```bash
# Login to Azure
az login

# Set your subscription
az account set --subscription "your-subscription-id"

# Create a resource group
az group create --name "rg-your-project" --location "East US"

# Deploy the main template
az deployment group create \
  --resource-group "rg-your-project" \
  --template-file main.bicep \
  --parameters @parameters/dev.json
```

## 📁 Bicep Files

## 📁 Bicep Files Analysis

### code/virtualNetwork/main.bicep

## Error analyzing code/virtualNetwork/main.bicep

Unable to generate AI analysis: 429 You exceeded your current quota, please check your plan and billing details. For more information on this error, read the docs: https://platform.openai.com/docs/guides/error-codes/api-errors.

---


## 📝 Parameter Examples

### Development Environment (`parameters/dev.json`)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": {
      "value": "dev"
    },
    "location": {
      "value": "eastus"
    },
    "appName": {
      "value": "myapp"
    },
    "skuName": {
      "value": "B1"
    },
    "skuCapacity": {
      "value": 1
    },
    "tags": {
      "value": {
        "Environment": "Development",
        "Project": "Sample Project",
        "CostCenter": "IT"
      }
    }
  }
}
```

### Production Environment (`parameters/prod.json`)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": {
      "value": "prod"
    },
    "location": {
      "value": "eastus"
    },
    "appName": {
      "value": "myapp"
    },
    "skuName": {
      "value": "P1v2"
    },
    "skuCapacity": {
      "value": 3
    },
    "tags": {
      "value": {
        "Environment": "Production",
        "Project": "Sample Project",
        "CostCenter": "IT"
      }
    }
  }
}
```

## 💻 Bicep Code Examples

### Basic Web App with App Service Plan

```bicep
// Parameters
@description('The name of the application')
param appName string

@description('The Azure region where resources will be deployed')
param location string = resourceGroup().location

@description('Environment name (dev, test, prod)')
@allowed(['dev', 'test', 'prod'])
param environment string

@description('App Service Plan SKU')
@allowed(['B1', 'B2', 'B3', 'S1', 'S2', 'S3', 'P1v2', 'P2v2', 'P3v2'])
param skuName string = 'B1'

@description('App Service Plan capacity')
@minValue(1)
@maxValue(10)
param skuCapacity int = 1

@description('Resource tags')
param tags object = {}

// Variables
var appServicePlanName = 'asp-${appName}-${environment}'
var webAppName = 'app-${appName}-${environment}'

// Resources
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  kind: 'app'
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  tags: tags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      http20Enabled: true
      appSettings: [
        {
          name: 'ENVIRONMENT'
          value: environment
        }
      ]
    }
  }
}

// Outputs
@description('The URL of the deployed web application')
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'

@description('The resource ID of the App Service Plan')
output appServicePlanId string = appServicePlan.id

@description('The resource ID of the Web App')
output webAppId string = webApp.id
```

### Storage Account with Container

```bicep
@description('Storage account name')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Location for the storage account')
param location string = resourceGroup().location

@description('Storage account SKU')
@allowed(['Standard_LRS', 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'])
param sku string = 'Standard_LRS'

@description('Container name')
param containerName string = 'data'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: sku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: containerName
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}

output storageAccountId string = storageAccount.id
output primaryEndpoints object = storageAccount.properties.primaryEndpoints
```

## 🔧 Deployment Scripts

### PowerShell Deployment Script

```powershell
# deploy.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$Environment,
    
    [string]$Location = "East US",
    [string]$TemplateFile = "main.bicep"
)

# Login and set context
Connect-AzAccount
Set-AzContext -SubscriptionId "your-subscription-id"

# Create resource group if it doesn't exist
if (-not (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location
    Write-Host "Created resource group: $ResourceGroupName"
}

# Deploy template
$parametersFile = "parameters/$Environment.json"

if (Test-Path $parametersFile) {
    New-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile $TemplateFile `
        -TemplateParameterFile $parametersFile `
        -Verbose
} else {
    Write-Error "Parameters file not found: $parametersFile"
}
```

### Bash Deployment Script

```bash
#!/bin/bash
# deploy.sh

set -e

RESOURCE_GROUP_NAME=""
ENVIRONMENT=""
LOCATION="eastus"
TEMPLATE_FILE="main.bicep"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -g|--resource-group)
      RESOURCE_GROUP_NAME="$2"
      shift 2
      ;;
    -e|--environment)
      ENVIRONMENT="$2"
      shift 2
      ;;
    -l|--location)
      LOCATION="$2"
      shift 2
      ;;
    *)
      echo "Unknown parameter: $1"
      exit 1
      ;;
  esac
done

# Validate required parameters
if [ -z "$RESOURCE_GROUP_NAME" ] || [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 -g <resource-group-name> -e <environment> [-l <location>]"
    exit 1
fi

# Create resource group if it doesn't exist
az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION"

# Deploy template
PARAMETERS_FILE="parameters/${ENVIRONMENT}.json"

if [ -f "$PARAMETERS_FILE" ]; then
    az deployment group create \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --template-file "$TEMPLATE_FILE" \
        --parameters "@$PARAMETERS_FILE"
else
    echo "Error: Parameters file not found: $PARAMETERS_FILE"
    exit 1
fi
```

## 🏷️ Best Practices

### Naming Conventions

- **Resource Groups**: `rg-{project}-{environment}-{region}`
- **Storage Accounts**: `st{project}{environment}{random}`
- **App Service Plans**: `asp-{project}-{environment}`
- **Web Apps**: `app-{project}-{environment}`
- **Key Vaults**: `kv-{project}-{environment}`

### Parameter Guidelines

1. Always provide descriptions for parameters
2. Use appropriate constraints (`@allowed`, `@minValue`, `@maxValue`)
3. Provide default values where sensible
4. Group related parameters logically
5. Use consistent naming patterns

### Security Best Practices

- Enable HTTPS only for web applications
- Use minimum TLS version 1.2
- Disable public access where not required
- Implement proper RBAC
- Use managed identities where possible

## 🧪 Testing

### Validate Bicep Templates

```bash
# Install Bicep CLI
curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64
chmod +x ./bicep
sudo mv ./bicep /usr/local/bin/bicep

# Or install via Azure CLI
az bicep install

# Lint all Bicep files
find . -name "*.bicep" -exec bicep build {} \;

# Validate deployment (what-if)
az deployment group what-if \
  --resource-group "rg-test" \
  --template-file main.bicep \
  --parameters @parameters/dev.json
```

## 📚 Additional Resources

- [Azure Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Bicep Best Practices](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/best-practices)
- [Azure Resource Manager Templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Note**: This README was automatically generated by the GitHub Actions workflow. Manual changes will be overwritten on the next workflow run.
