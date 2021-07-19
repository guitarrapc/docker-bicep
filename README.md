## docker-bicep

docker image for [bicep](https://github.com/Azure/bicep)

```shell
docker run --rm guitarrapc/docker-bicep:latest --help
```

# Images

There are 2 images.

1. `guitarrapc/docker-bicep:devcontainers-latest` : Image for [VS Code Dev Dev Remote-Container](https://code.visualstudio.com/docs/remote/containers#_getting-started) image
    ```
    docker pull guitarrapc/docker-bicep:devcontainers-latest
    ```
1. `guitarrapc/docker-bicep:latest` : Image for Standalone execution
    ```
    docker pull guitarrapc/docker-bicep:latest
    ```

# Samples

## docker-bicep:devcontainers with VS Code

You can launch bicep on VS Code Remote Container.

Launch VS Code, Ipen Command Pallete, Select `Remote-Container: Reopen in Container`.

Now you are working in the bicep container.

```shell
$ bicep --help
$ bicep build ./sample/main.bicep
```

To work with your environment, create `.devcontainer` folder and put `.devcontainer/devcontainer.json` and `.devcontainer/Dockerfile`.

> see [.devcontainer](https://github.com/guitarrapc/docker-bicep/tree/main/.devcontainer) for sample .devcontainer structure.

## docker-bicep with docker run

Working dir is `/bicep`, you can mount your files to and run command.
Here's sample to build bicep to ARM template json.

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

## docker-bicep with docker-compose

To run bicep on docker-compose, prepare compose first.
This Compose will persistent your azure credentials even if compose down.

```yaml
services:
  bicep:
    image: guitarrapc/docker-bicep:0.4.63
    entrypoint: /bin/sh
    tty: true
    stdin_open: true
    volumes:
      - .:/bicep
      - azure:/root/.azure

volumes:
  azure:
    driver: local
```

Run compose.

```
$ docker-compose up -d
```

login to container and create credentials.

```
$ docker-compose exec bicep /bin/bash
# inside container, login to azure.
# az login
```

Now you can run bicep.

```
# bicep build
```

# TIPS

## Build Image (local)

```shell
docker build -t bicep -f Dockerfile .
docker run -it --rm bicep:latest --help
```

## Opening on Remote-Container and open bicep shows failed to install dotnet

Failed dotnet install stop bicep intellisence.
`rebuild container image` will fix this issue.
