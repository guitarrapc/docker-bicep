## docker-bicep

docker image for [bicep](https://github.com/Azure/bicep)

```shell
docker run --rm guitarrapc/docker-bicep:latest --help
```

## Sample

Working dir is `/bicep`, you can mount your files to and run command.
Here's sample to build your bicep to ARM template json.

> ./sample/main.bicep
```bicep
param location string = resourceGroup().location
param namePrefix string = 'storage'

var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'
var storageAccountSku = 'Standard_RAGRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageAccountSku
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountId string = storageAccount.id
```

build bicep.

```shell
docker run --rm -v "PATH_TO_BICEP:/bicep" guitarrapc/docker-bicep:latest build ./main.bicep
```

bicep generate ARM template json.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "metadata": {
    "_generator": {
      "name": "bicep",
      "version": "0.4.63.48766",
      "templateHash": "7575291982801713110"
    }
  },
  "parameters": {
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]"
    },
    "namePrefix": {
      "type": "string",
      "defaultValue": "storage"
    }
  },
  "functions": [],
  "variables": {
    "storageAccountName": "[format('{0}{1}', parameters('namePrefix'), uniqueString(resourceGroup().id))]",
    "storageAccountSku": "Standard_RAGRS"
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2019-06-01",
      "name": "[variables('storageAccountName')]",
      "location": "[parameters('location')]",
      "kind": "StorageV2",
      "sku": {
        "name": "[variables('storageAccountSku')]"
      },
      "properties": {
        "accessTier": "Hot",
        "supportsHttpsTrafficOnly": true
      }
    }
  ],
  "outputs": {
    "storageAccountId": {
      "type": "string",
      "value": "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]"
    }
  }
}
```

## Build Image (local)

```shell
docker build -t bicep -f Dockerfile .
docker run -it --rm bicep:latest --help
```
