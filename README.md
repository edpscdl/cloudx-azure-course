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

2. Create Azure Active Directory B2C at new tenant.
    - Copy from new tenant and AAD B2C to ```terraform.tfvars``` next values:
      - main_resource_group_name
      - b2c_application_name
      - b2c_client_id
      - b2c_client_secret
      - b2c_user_flow_signup_or_signin_name
      - b2c_user_flow_password_reset_name

3. Run ```main.ft```

4. Run command for view sensitive output:
    - ```cd ./terraform```
    - ```terraform output secrets```

6. In GitHub, create the following environment variables:
   - ```AZURE_ACR_REGISTRY_NAME```
   - ```AZURE_RESOURCE_GROUP```
   - ```FUNCTION_APP_NAME```

7. In GitHub, create the following secret values:
   - ```AZURE_ACR_REGISTRY_PASSWORD```
   - ```AZURE_ACR_REGISTRY_USERNAME```
   - ```AZURE_CREDENTIALS```

8. In GitHub, run the "Build and Deploy Selected Module" workflow with the current branch and all modules selected.