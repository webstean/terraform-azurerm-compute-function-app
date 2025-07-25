#!/bin/bash
set -e

echo "Getting GitHub OIDC token..."
TOKEN=$(curl -s -H "Authorization: bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" \
  "$ACTIONS_ID_TOKEN_REQUEST_URL&audience=api://AzureADTokenExchange" | jq -r .value)

echo "Logging in to Azure CLI..."
az login --federated-token "$TOKEN" --service-principal --username $ARM_CLIENT_ID --tenant $ARM_TENANT_ID
