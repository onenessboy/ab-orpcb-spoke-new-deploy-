#!/bin/bash
changeStrValue(){ JSON=$(jq ".$1 = \"$2\"" <<<"$JSON"); }
changeIntValue(){ JSON=$(jq ".$1 = $2" <<<"$JSON"); }
changeBoolValue(){ JSON=$(jq ".$1 = $2" <<<"$JSON"); }
INPUT_FILE="/home/circleci/workingfiles/terraforminput.tfvars.json"
OUTPUT_FILE="/home/circleci/workingfiles/terraformoutput.tfvars.json" 
JSON=$(jq -r . "$INPUT_FILE")
# change values (String)
changeStrValue ARM_CLIENT_ID "$ARM_CLIENT_ID"
changeStrValue ARM_CLIENT_SECRET "$ARM_CLIENT_SECRET"
changeStrValue ARM_TENANT_ID "$ARM_TENANT_ID"
changeStrValue TF_CONTAINER_NAME "$TF_CONTAINER_NAME"
changeStrValue TF_RESOURCE_GROUP_NAME "$TF_RESOURCE_GROUP_NAME"
changeStrValue TF_STORAGE_ACCOUNT_NAME "$TF_STORAGE_ACCOUNT_NAME"
changeStrValue TF_KEY_NAME "$TF_KEY_NAME"
changeStrValue hub_subscription_id "$hub_subscription_id"
changeStrValue hub_arm_client_id "$hub_arm_client_id"
changeStrValue hub_tenant_id "$hub_tenant_id"
changeStrValue hub_arm_client_secret "$hub_arm_client_secret"
changeStrValue synadmin_password "$synadmin_password"
changeStrValue synadmin_username "$synadmin_username"
jq . <<<"$JSON" > "$OUTPUT_FILE"
