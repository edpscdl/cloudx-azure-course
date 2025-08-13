# Instruction for install, build, upload and configure Pet store enviroment

1. Configure your Azure subscription:
    - ```az login```
      _Follow the authorization path and select the required subscription._
    - ```az extension add --name containerapp --upgrade```
    - ```az provider register --namespace Microsoft.App```
    - ```az provider register --namespace Microsoft.OperationalInsights```
    - ```az provider register --namespace Microsoft.AzureTerraform```
    - ```az extension add --name serviceconnector-passwordless --upgrade```
    - ```az extension add --name microsoft-entra-admin```

2. Create Azure Active Directory B2C at new tenant and create users flows with names:
   - B2C_1_SIGNUP_OR_SIGNIN
   - B2C_1_PASSWORD_RESET
   - B2C_1_PROFILE_EDITING

3. Run ```main.ft```

4. Run command for view sensitive output:
    - ```cd ./terraform```
    - ```terraform output secrets```

5. Create service principal for github actions and save response:
   - ```az ad sp create-for-rbac --name "heorhi_utseuski_github_actions" --json-auth```
   
   _response should be view like this:_ 
    ```json5
    {
        "clientId":"<client_id>",
        "clientSecret":"<client_secret>",
        "subscriptionId":"<subscription_id>",
        "tenantId":"<tenant_id>"
    }
```

5. Add roles to resources:
    - ```az role assignment create --assignee <client_id> --role "Container Apps Contributor" --scope /subscriptions/<subscription_id>/resourceGroups/<resource_group_name>```
    - ```az role assignment create --assignee <client_id> --role "Web Plan Contributor" --scope /subscriptions/<subscription_id>/resourceGroups/<resource_group_name>```
    - ```az role assignment create --assignee <client_id> --role "Website Contributor" --scope /subscriptions/<subscription_id>/resourceGroups/<resource_group_name>```
    - ```az role assignment create --assignee <client_id> --role "AcrPush" --scope /subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.ContainerRegistry/registries/<acr_name>```
    - ```az role assignment create --assignee <client_id> --role "Contributor" --scope /subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.ContainerRegistry/registries/<acr_name>```

6. In GitHub, create the following environment variables:
   - ```AZURE_ACR_REGISTRY_NAME```
   - ```AZURE_RESOURCE_GROUP```
   - ```FUNCTION_APP_NAME```

7. In GitHub, create the following secret values:
   - ```AZURE_ACR_REGISTRY_PASSWORD```
   - ```AZURE_ACR_REGISTRY_USERNAME```
   - ```AZURE_CREDENTIALS```

8. In GitHub, run the "Build and Deploy Selected Module" workflow with the current branch and all modules selected.