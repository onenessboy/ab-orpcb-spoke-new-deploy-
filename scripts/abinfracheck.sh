#!/bin/bash
echo "export ARM_SUBSCRIPTION_ID=${tfsubscriptionid}" >> $BASH_ENV
echo "export CLIENT_SUBSCRIPTION_ID=${subscriptionid}" >> $BASH_ENV
source $BASH_ENV
printenv
apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo make
apk add py3-pip
pip install azure-cli
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
#az account set -s $ARM_SUBSCRIPTION_ID
#az storage container create -n ${client_code} --account-name storpcbhub${envvar}iacwe --fail-on-exist
az account set --subscription $CLIENT_SUBSCRIPTION_ID
status=$(az group list --query "[?name.contains(@,'rg-orpcb-${client_code}')]")
if [[ "$status" == '[]' ]]
then
   echo "spoke resource group does not exist"
   az account set -s $ARM_SUBSCRIPTION_ID
   az group list --query "[?name.contains(@,'orpcb-ctrl-${envvar}-we-iac')  && managedBy == null ]" > /home/circleci/workingfiles/tfrgname.json
   tfrgname=$(jq -r '.[] | .name' /home/circleci/workingfiles/tfrgname.json)   
   echo $tfrgname  
   az storage account list --resource-group $tfrgname --query "[?name.contains(@,'storpcbhub${envvar}iacwe')]" > /home/circleci/workingfiles/tfstorage.json
   tfstaccname=$(jq -r '.[] | .name' /home/circleci/workingfiles/tfstorage.json)
   echo $tfstaccname
   az storage account network-rule add --resource-group $tfrgname --account-name $tfstaccname --ip-address $ip
   sleep 1m
   az storage account update --resource-group $tfrgname --name $tfstaccname --allow-blob-public-access true
   sleep 1m
   az storage container create -n ${client_code} --account-name storpcbhub${envvar}iacwe --fail-on-exist
   sleep 1m
   terraform -chdir=Terraform init -input=false -backend-config="resource_group_name=${TF_RESOURCE_GROUP_NAME}" \
   -backend-config="storage_account_name=${TF_STORAGE_ACCOUNT_NAME}" \
   -backend-config="container_name=${client_code}" \
   -backend-config="key=${envvar}/${TF_KEY_NAME}"             
   terraform -chdir=Terraform plan -lock=false -var="env=${envvar}" -var="client_code=${client_code}" -var-file=/home/circleci/workingfiles/terraformoutput.tfvars.json
   terraform -chdir=Terraform apply -lock=false -auto-approve -var="env=${envvar}" -var="client_code=${client_code}" -var-file=/home/circleci/workingfiles/terraformoutput.tfvars.json
   az account set --subscription $CLIENT_SUBSCRIPTION_ID
   az group list --query "[?name.contains(@,'rg-orpcb-${client_code}')  && managedBy == null ]" > /home/circleci/workingfiles/rg.json
   rgname=$(jq -r '.[] | .name' /home/circleci/workingfiles/rg.json)
   echo $rgname
   az storage account list --resource-group $rgname --query "[?name.contains(@,'stdl${client_code}')]" > /home/circleci/workingfiles/storage.json
   staccname=$(jq -r '.[] | .name' /home/circleci/workingfiles/storage.json)
   az storage account update --resource-group $rgname --name $staccname --default-action Deny
   sleep 1m
   az storage account update --resource-group $rgname --name $staccname --allow-blob-public-access false
   sleep 1m
   az synapse workspace list --resource-group $rgname --query "[?name.contains(@,'syn-orpcb-ws${client_code}')]" > /home/circleci/workingfiles/workspace.json
   synapsews=$(jq -r '.[] | .name' /home/circleci/workingfiles/workspace.json)
   echo $synapsews
   az synapse workspace firewall-rule create --name circleciip --workspace-name $synapsews --resource-group $rgname --start-ip-address $ip --end-ip-address $ip
   az account set -s $ARM_SUBSCRIPTION_ID
   az storage account update --resource-group $tfrgname --name $tfstaccname --default-action Deny
   sleep 1m
   az storage account update --resource-group $tfrgname --name $tfstaccname --allow-blob-public-access false
   sleep 1m
   #az resource update --ids /subscriptions/$CLIENT_SUBSCRIPTION_ID/resourceGroups/$rgname/providers/Microsoft.Synapse/workspaces/$synapsews --set properties.publicNetworkAccess=Disabled
   #terraform -chdir=Terraform destroy -lock=false -auto-approve -var="env=${envvar}" -var="client_code=${client_code}" -var-file=/home/circleci/workingfiles/terraformoutput.tfvars.json
else
   echo "spoke resource group exists"
   az account set -s $ARM_SUBSCRIPTION_ID
   az group list --query "[?name.contains(@,'orpcb-ctrl-${envvar}-we-iac')  && managedBy == null ]" > /home/circleci/workingfiles/tfrgname.json
   tfrgname=$(jq -r '.[] | .name' /home/circleci/workingfiles/tfrgname.json)   
   echo $tfrgname  
   az storage account list --resource-group $tfrgname --query "[?name.contains(@,'storpcbhub${envvar}iacwe')]" > /home/circleci/workingfiles/tfstorage.json
   tfstaccname=$(jq -r '.[] | .name' /home/circleci/workingfiles/tfstorage.json)
   echo $tfstaccname
   az storage account network-rule add --resource-group $tfrgname --account-name $tfstaccname --ip-address $ip
   sleep 1m
   az storage account update --resource-group $tfrgname --name $tfstaccname --allow-blob-public-access true
   sleep 1m
   az account set --subscription $CLIENT_SUBSCRIPTION_ID
   az group list --query "[?name.contains(@,'rg-orpcb-${client_code}') && managedBy == null]" > /home/circleci/workingfiles/rg.json
   rgname=$(jq -r '.[] | .name' /home/circleci/workingfiles/rg.json)   
   echo $rgname  
   az storage account list --resource-group $rgname --query "[?name.contains(@,'stdl${client_code}')]" > /home/circleci/workingfiles/storage.json
   staccname=$(jq -r '.[] | .name' /home/circleci/workingfiles/storage.json)
   echo $staccname
   az storage account network-rule add --resource-group $rgname --account-name $staccname --ip-address $ip
   az synapse workspace list --resource-group $rgname --query "[?name.contains(@,'syn-orpcb-ws${client_code}')]" > /home/circleci/workingfiles/workspace.json
   synapsews=$(jq -r '.[] | .name' /home/circleci/workingfiles/workspace.json)
   echo $synapsews
   az resource update --ids /subscriptions/$CLIENT_SUBSCRIPTION_ID/resourceGroups/$rgname/providers/Microsoft.Synapse/workspaces/$synapsews --set properties.publicNetworkAccess=Enabled
   az synapse workspace firewall-rule create --name circleciip --workspace-name $synapsews --resource-group $rgname --start-ip-address $ip --end-ip-address $ip
   terraform -chdir=Terraform init -input=false -backend-config="resource_group_name=${TF_RESOURCE_GROUP_NAME}" \
   -backend-config="storage_account_name=${TF_STORAGE_ACCOUNT_NAME}" \
   -backend-config="container_name=${client_code}" \
   -backend-config="key=${envvar}/${TF_KEY_NAME}"
   terraform -chdir=Terraform import -lock=false -var="env=${envvar}" -var="client_code=${client_code}" -var-file=/home/circleci/workingfiles/terraformoutput.tfvars.json module.synapse_workspace_pe.azurerm_private_endpoint.syn_ws_pe_dev "/subscriptions/${hub_subscription_id}/resourceGroups/hub/providers/Microsoft.Network/privateEndpoints/pe-syn-orpcb-${client_code}-${envvar}-we-dev"
   terraform -chdir=Terraform import -lock=false -var="env=${envvar}" -var="client_code=${client_code}" -var-file=/home/circleci/workingfiles/terraformoutput.tfvars.json module.synapse_workspace_pe.azurerm_private_endpoint.syn_ws_pe_sql "/subscriptions/${hub_subscription_id}/resourceGroups/hub/providers/Microsoft.Network/privateEndpoints/pe-syn-orpcb-${client_code}-${envvar}-we-sql"
   terraform -chdir=Terraform import -lock=false -var="env=${envvar}" -var="client_code=${client_code}" -var-file=/home/circleci/workingfiles/terraformoutput.tfvars.json module.synapse_workspace_pe.azurerm_private_endpoint.syn_ws_pe_sqlondemand "/subscriptions/${hub_subscription_id}/resourceGroups/hub/providers/Microsoft.Network/privateEndpoints/pe-syn-orpcb-${client_code}-${envvar}-we-sqlondemand"
   #terraform -chdir=Terraform plan -lock=false -var="env=${envvar}" -var="client_code=${client_code}" -var-file=/home/circleci/workingfiles/terraformoutput.tfvars.json
   #terraform -chdir=Terraform apply -lock=false  -auto-approve -var="env=${envvar}" -var="client_code=${client_code}" -var-file=/home/circleci/workingfiles/terraformoutput.tfvars.json
   terraform -chdir=Terraform destroy -lock=false -auto-approve -var="env=${envvar}" -var="client_code=${client_code}" -var-file=/home/circleci/workingfiles/terraformoutput.tfvars.json
   az storage account update --resource-group $rgname --name $staccname --default-action deny
   az storage account update --resource-group $rgname --name $staccname --allow-blob-public-access false
   az resource update --ids /subscriptions/$CLIENT_SUBSCRIPTION_ID/resourceGroups/$rgname/providers/Microsoft.Synapse/workspaces/$synapsews --set properties.publicNetworkAccess=Disabled
   az account set -s $ARM_SUBSCRIPTION_ID
   az storage account update --resource-group $tfrgname --name $tfstaccname --default-action deny
   az storage account update --resource-group $tfrgname --name $tfstaccname --allow-blob-public-access false
fi
