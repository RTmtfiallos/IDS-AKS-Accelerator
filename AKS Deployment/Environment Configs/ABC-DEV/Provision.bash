dir
# Create Resource Group
az group create -l CentralUS -n ABCDS-AKS-Dev

# Deploy template with in-line parameters
az deployment group create -g ABCDS-AKS-Dev  --template-uri https://github.com/Azure/Aks-Construction/releases/download/0.4.0-preview/main.json --parameters \
	resourceName=ABCDS-AKS-Dev \
	agentCount=1 \
	AksPaidSkuForSLA=true \
	agentCountMax=3 \
	custom_vnet=true \
	bastion=true \
	enable_aad=true \
	AksDisableLocalAccounts=true \
	enableAzureRBAC=true \
	adminprincipleid=$(az ad signed-in-user show --query objectId --out tsv) \
	registries_sku=Premium \
	acrPushRolePrincipalId=$(az ad signed-in-user show --query objectId --out tsv) \
	azureFirewalls=true \
	certManagerFW=true \
	privateLinks=true \
	kvIPAllowlist="[\"174.211.234.138/32\"]" \
	omsagent=true \
	retentionInDays=30 \
	networkPolicy=calico \
	azurepolicy=audit \
	enablePrivateCluster=true \
	dnsZoneId=/subscriptions/f184c401-f7a1-4670-a0ae-90e6565d0e29/resourceGroups/DNS/providers/Microsoft.Network/dnszones/ABCDS.AKS \
	ingressApplicationGateway=true \
	appGWcount=1 \
	appGWsku=WAF_v2 \
	appGwFirewallMode=Detection \
	appGWmaxCount=2 \
	privateIpApplicationGateway=10.240.4.10 \
	appgwKVIntegration=true \
	azureKeyvaultSecretsProvider=true \
	createKV=true \
	kvOfficerRolePrincipalId=$(az ad signed-in-user show --query objectId --out tsv) \
	acrPrivatePool=true