Assorted things to do after the initial deploy.sh has been run successfully:

+ Go to ACR via the portal, click connected regisitries, then click Enable registry endpoint to use connected registries

## Configure client firewall rules for MCR

If you need to access Microsoft Container Registry (MCR) from behind a firewall, see the guidance to configure [MCR client firewall rules](https://github.com/microsoft/containerregistry/blob/master/client-firewall-rules.md). MCR is the primary registry for all Microsoft-published docker images, such as Windows Server images.

+ Learn more about [security groups](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) in an Azure virtual network

+ Learn more about setting up [Private Link](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-private-link) for a container registry

## Restrict access to a container registry using a service endpoint in an Azure virtual network

+ Only an [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes) cluster or Azure [virtual machine](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/overview) can be used as a host to access a container registry using a service endpoint. *Other Azure services including Azure Container Instances aren't supported.*
+ Service endpoints for Azure Container Registry aren't supported in the Azure US Government cloud or Azure China cloud.

## Prerequisites

+ To use the Azure CLI steps in this article, Azure CLI version 2.0.58 or later is required. If you need to install or upgrade, see [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

+ If you don't already have a container registry, create one (Premium tier required) and push a sample image such as `hello-world` from Docker Hub. For example, use the [Azure portal](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal) or the [Azure CLI](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli) to create a registry.

+ If you want to restrict registry access using a service endpoint in a different Azure subscription, register the resource provider for Azure Container Registry in that subscription. For example:
  
  Azure CLICopy
  
  ```
  az account set --subscription <Name or ID of subscription of virtual network>
  
  az provider register --namespace Microsoft.ContainerRegistry
  ```

## [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#create-a-docker-enabled-virtual-machine)Create a Docker-enabled virtual machine





For test purposes, use a Docker-enabled Ubuntu VM to access an Azure container registry. To use Azure Active Directory authentication to the registry, also install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) on the VM. If you already have an Azure virtual machine, skip this creation step.

You may use the same resource group for your virtual machine and your container registry. This setup simplifies clean-up at the end but isn't required. If you choose to create a separate resource group for the virtual machine and virtual network, run [az group create](https://docs.microsoft.com/en-us/cli/azure/group). The following example assumes you've set environment variables for the resource group name and registry location:

Azure CLICopy

```
az group create --name $RESOURCE_GROUP --location $REGISTRY_LOCATION
```

Now deploy a default Ubuntu Azure virtual machine with [az vm create](https://docs.microsoft.com/en-us/cli/azure/vm#az_vm_create). The following example creates a VM named *myDockerVM*.

Azure CLICopy

```
VM_NAME=myDockerVM

az vm create \  --resource-group $RESOURCE_GROUP \  --name $VM_NAME \  --image UbuntuLTS \  --admin-username azureuser \  --generate-ssh-keys
```

It takes a few minutes for the VM to be created. When the command completes, take note of the `publicIpAddress` displayed by the Azure CLI. Use this address to make SSH connections to the VM.

### [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#install-docker-on-the-vm)Install Docker on the VM

After the VM is running, make an SSH connection to the VM. Replace *publicIpAddress* with the public IP address of your VM.

BashCopy

```
ssh azureuser@publicIpAddress
```

Run the following commands to install Docker on the Ubuntu VM:

BashCopy

```
sudo apt-get updatesudo apt install docker.io -y
```

After installation, run the following command to verify that Docker is running properly on the VM:

BashCopy

```
sudo docker run -it hello-world
```

Output:

Copy

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
[...]
```

### [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#install-the-azure-cli)Install the Azure CLI

Follow the steps in [Install Azure CLI with apt](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt) to install the Azure CLI on your Ubuntu virtual machine. For example:

BashCopy

```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

Exit the SSH connection.

## [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#configure-network-access-for-registry)Configure network access for registry

In this section, configure your container registry to allow access from a subnet in an Azure virtual network. Steps are provided using the Azure CLI.

### [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#add-a-service-endpoint-to-a-subnet)Add a service endpoint to a subnet

When you create a VM, Azure by default creates a virtual network in the same resource group. The name of the virtual network is based on the name of the virtual machine. For example, if you name your virtual machine *myDockerVM*, the default virtual network name is *myDockerVMVNET*, with a subnet named *myDockerVMSubnet*. Verify this by using the [az network vnet list](https://docs.microsoft.com/en-us/cli/azure/network/vnet/#az_network_vnet_list) command:

Azure CLICopy

```
az network vnet list \  --resource-group myResourceGroup \  --query "[].{Name: name, Subnet: subnets[0].name}"
```

Output:

ConsoleCopy

```
[  {    "Name": "myDockerVMVNET",    "Subnet": "myDockerVMSubnet"  }]
```

Use the [az network vnet subnet update](https://docs.microsoft.com/en-us/cli/azure/network/vnet/subnet/#az_network_vnet_subnet_update) command to add a **Microsoft.ContainerRegistry** service endpoint to your subnet. Substitute the names of your virtual network and subnet in the following command:

Azure CLICopy

```
az network vnet subnet update \  --name myDockerVMSubnet \  --vnet-name myDockerVMVNET \  --resource-group myResourceGroup \  --service-endpoints Microsoft.ContainerRegistry
```

Use the [az network vnet subnet show](https://docs.microsoft.com/en-us/cli/azure/network/vnet/subnet/#az_network_vnet_subnet_show) command to retrieve the resource ID of the subnet. You need this in a later step to configure a network access rule.

Azure CLICopy

```
az network vnet subnet show \  --name myDockerVMSubnet \  --vnet-name myDockerVMVNET \  --resource-group myResourceGroup \  --query "id"
  --output tsv
```

Output:

Copy

```
/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myDockerVMVNET/subnets/myDockerVMSubnet
```

### [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#change-default-network-access-to-registry)Change default network access to registry

By default, an Azure container registry allows connections from hosts on any network. To limit access to a selected network, change the default action to deny access. Substitute the name of your registry in the following [az acr update](https://docs.microsoft.com/en-us/cli/azure/acr#az_acr_update) command:

Azure CLICopy

```
az acr update --name myContainerRegistry --default-action Deny
```

### [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#add-network-rule-to-registry)Add network rule to registry

Use the [az acr network-rule add](https://docs.microsoft.com/en-us/cli/azure/acr/network-rule/#az_acr_network_rule_add) command to add a network rule to your registry that allows access from the VM's subnet. Substitute the container registry's name and the resource ID of the subnet in the following command:

Azure CLICopy

```
az acr network-rule add \  --name mycontainerregistry \  --subnet <subnet-resource-id>
```

## [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#verify-access-to-the-registry)Verify access to the registry

After waiting a few minutes for the configuration to update, verify that the VM can access the container registry. Make an SSH connection to your VM, and run the [az acr login](https://docs.microsoft.com/en-us/cli/azure/acr#az_acr_login) command to login to your registry.

BashCopy

```
az acr login --name mycontainerregistry
```

You can perform registry operations such as run `docker pull` to pull a sample image from the registry. Substitute an image and tag value appropriate for your registry, prefixed with the registry login server name (all lowercase):

BashCopy

```
docker pull mycontainerregistry.azurecr.io/hello-world:v1
```

Docker successfully pulls the image to the VM.

This example demonstrates that you can access the private container registry through the network access rule. However, the registry can't be accessed from a login host that doesn't have a network access rule configured. If you attempt to login from another host using the `az acr login` command or `docker login` command, output is similar to the following:

ConsoleCopy

```
Error response from daemon: login attempt to https://xxxxxxx.azurecr.io/v2/ failed with status: 403 Forbidden
```

## [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#restore-default-registry-access)Restore default registry access

To restore the registry to allow access by default, remove any network rules that are configured. Then set the default action to allow access.

### [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#remove-network-rules)Remove network rules

To see a list of network rules configured for your registry, run the following [az acr network-rule list](https://docs.microsoft.com/en-us/cli/azure/acr/network-rule/#az_acr_network_rule_list) command:

Azure CLICopy

```
az acr network-rule list --name mycontainerregistry 
```

For each rule that is configured, run the [az acr network-rule remove](https://docs.microsoft.com/en-us/cli/azure/acr/network-rule/#az_acr_network_rule_remove) command to remove it. For example:

Azure CLICopy

```
# Remove a rule that allows access for a subnet. Substitute the subnet resource ID.

az acr network-rule remove \  --name mycontainerregistry \  --subnet /subscriptions/ \  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myDockerVMVNET/subnets/myDockerVMSubnet
```

### [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#allow-access)Allow access

Substitute the name of your registry in the following [az acr update](https://docs.microsoft.com/en-us/cli/azure/acr#az_acr_update) command:

Azure CLICopy

```
az acr update --name myContainerRegistry --default-action Allow
```

## [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#clean-up-resources)Clean up resources

If you created all the Azure resources in the same resource group and no longer need them, you can optionally delete the resources by using a single [az group delete](https://docs.microsoft.com/en-us/cli/azure/group) command:

Azure CLICopy

```
az group delete --name myResourceGroup
```

## [](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-vnet#next-steps)Next steps

+ To restrict access to a registry using a private endpoint in a virtual network, see [Configure Azure Private Link for an Azure container registry](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-private-link).
+ If you need to set up registry access rules from behind a client firewall, see [Configure rules to access an Azure container registry behind a firewall](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-firewall-access-rules).
