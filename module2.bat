@ECHO OFF

SET /A RANDOM_NUMBER=%RANDOM% % 900 + 100

SET PERMANENT_RG=permanent-rg-%RANDOM_NUMBER%
SET TEMPORARY_RG=temporary-rg-%RANDOM_NUMBER%
SET LOCATION_EAST=eastus
SET LOCATION_WEST=westeurope

az group create --resource-group %PERMANENT_RG% --location %LOCATION_EAST%
az group create --resource-group %TEMPORARY_RG% --location %LOCATION_WEST%

az group list
az group list --output table

az group show --resource-group %PERMANENT_RG%

az group list --query "[?contains(name,'%PERMANENT_RG%')]" --output table

FOR /F "usebackq tokens=* delims=" %A IN (`az group show --resource-group %PERMANENT_RG% --query "id" -o tsv`) DO ( SET RESOURCE_RG_ID=%A )

az group delete --resource-group %TEMPORARY_RG% --no-wait --yes

az group list --output table

SET MODULE2_ACR=module2acr%RANDOM_NUMBER%

az acr create --name %MODULE2_ACR% --resource-group %PERMANENT_RG% --sku Basic --admin-enabled

az resource list --resource-group %PERMANENT_RG% --output table

az acr credential show --name %MODULE2_ACR% --resource-group %PERMANENT_RG% --output yaml