
# --------------------
# Install external-dns
az aks command invoke -g ABCDS-AKS-Dev -n aks-ABCDS-AKS-Dev  --command "
kubectl create secret generic azure-config-file --from-file=azure.json=/dev/stdin<<EOF
{
  userAssignedIdentityID: $(az aks show -g ABCDS-AKS-Dev -n aks-ABCDS-AKS-Dev --query identityProfile.kubeletidentity.clientId -o tsv),
  tenantId: $(az account show --query tenantId -o tsv),
  useManagedIdentityExtension: true,
  subscriptionId: f184c401-f7a1-4670-a0ae-90e6565d0e29,
  resourceGroup: DNS
}
EOF
"
# Import Image to ACR
export ACRNAME=$(az acr list -g ABCDS-AKS-Dev --query [0].name -o tsv)
az acr import -n $ACRNAME --source k8s.gcr.io/external-dns/external-dns:v0.8.0 --image external-dns/external-dns:v0.8.0


# external-dns manifest (for clusters with RBAC)
curl https://raw.githubusercontent.com/Azure/Aks-Construction/main/helper/config/external-dns.yml | sed -e "s|{{image}}|$ACRNAME.azurecr.io/external-dns/external-dns:v0.8.0|g" -e "s|{{domain-filter}}|ABCDS.AKS|g" -e "s|{{provider}}|azure|g"  >/tmp/aks-ext-dns.yml
az aks command invoke -g ABCDS-AKS-Dev -n aks-ABCDS-AKS-Dev --command "kubectl apply -f ./aks-ext-dns.yml" --file  /tmp/aks-ext-dns.yml


# --------------------
# Install cert-manager
az aks command invoke -g ABCDS-AKS-Dev -n aks-ABCDS-AKS-Dev  --command "
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml
"
# Wait for cert-manager to install
sleep 30s

cat >/tmp/aks-issuer.yml<<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: matthew.fiallos@randstadusa.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: azure/application-gateway
EOF
az aks command invoke -g ABCDS-AKS-Dev -n aks-ABCDS-AKS-Dev --command "kubectl apply -f ./aks-issuer.yml" --file  /tmp/aks-issuer.yml
