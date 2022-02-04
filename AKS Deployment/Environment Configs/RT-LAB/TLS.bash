
# Build app
export ACRNAME=$(az acr list -g ABCDS-AKS-Dev --query [0].name -o tsv)
az acr build -r $ACRNAME -t openjdk-demo:0.0.1  --agent-pool private-pool https://github.com/khowling/e2e-tls-java-aks.git



# Create backend Certificate in KeyVault
export KVNAME=$(az keyvault list -g ABCDS-AKS-Dev --query [0].name -o tsv)
export COMMON_NAME=openjdk-demo
az keyvault certificate create --vault-name $KVNAME -n $COMMON_NAME -p "$(az keyvault certificate get-default-policy | sed -e s/CN=CLIGetDefaultPolicy/CN=${COMMON_NAME}/g )"


# Wait for Cert to be issued
sleep 1m

## Create Root Cert reference in AppGW (Required for Self-Signed Cert)
az network application-gateway root-cert create \
     --gateway-name $(az network application-gateway list -g ABCDS-AKS-Dev --query [0].name -o tsv)  \
     --resource-group ABCDS-AKS-Dev \
     --name $COMMON_NAME \
     --keyvault-secret $(az keyvault secret list-versions --vault-name $KVNAME -n $COMMON_NAME --query "[?attributes.enabled].id" -o tsv)

# Install
export APPNAME=openjdk-demo
az aks command invoke -g ABCDS-AKS-Dev -n aks-ABCDS-AKS-Dev  --command "
helm upgrade --install $APPNAME https://github.com/khowling/e2e-tls-java-aks/blob/main/openjdk-demo-3.1.0.tgz?raw=true  --set ingressType=appgw,letsEncrypt.issuer=letsencrypt-prod,image.repository=${ACRNAME}.azurecr.io/openjdk-demo,image.tag=0.0.1,csisecrets.vaultname=${KVNAME},csisecrets.tenantId=$(az account show --query tenantId -o tsv),csisecrets.clientId=$(az aks show -g ABCDS-AKS-Dev -n aks-ABCDS-AKS-Dev --query addonProfiles.azureKeyvaultSecretsProvider.identity.clientId -o tsv),dnsname=${APPNAME}.ABCDS.AKS
"
