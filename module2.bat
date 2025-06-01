@ECHO OFF

:: ===================================================
:: === Subtask 2: Resource Groups
:: ===================================================

SET /A RANDOM_NUMBER=%RANDOM% % 900 + 100

:: 1. Set four variables
SET PERMANENT_RG=permanent-rg-%RANDOM_NUMBER%
SET TEMPORARY_RG=temporary-rg-%RANDOM_NUMBER%
SET LOCATION_EAST=eastus
SET LOCATION_WEST=westeurope

echo %PERMANENT_RG%
echo %TEMPORARY_RG%
echo %LOCATION_EAST%
echo %LOCATION_WEST%

:: 2. Use the az group create command along with the variables to create a permanent and a temporary resource groups.
az group create --resource-group %PERMANENT_RG% --location %LOCATION_EAST%
az group create --resource-group %TEMPORARY_RG% --location %LOCATION_WEST%

:: 3. Use the az group list command to list all available resource groups in your subscription
az group list
:: 4. Change the previous command to get a table.
az group list --output table

:: 5. Use the az group show command to output detailed information about the permanent resource group
az group show --resource-group %PERMANENT_RG%

:: 6. Use the az group list command to list as a table and filter resource groups, using the variable in which you stored the location of the permanent resource group.
az group list --query "[?contains(location,'%LOCATION_EAST%')]" --output table

:: 7. Use the az group show command to save the permanent resource group ID to a variable and output it
FOR /F "usebackq tokens=* delims=" %A IN (`az group show --resource-group %PERMANENT_RG% --query "id" --output tsv`) DO ( SET RESOURCE_RG_ID=%A )
echo %RESOURCE_RG_ID%

:: 8. Use the az group delete command along with the variable containing the name of the temporary resource group to delete it. Use a necessary option to do it without being prompted for additional confirmation.
az group delete --resource-group %TEMPORARY_RG% --no-wait --yes

:: 9. Check if the temporary resource group has been deleted. List all available resource groups in your subscription again as a table. Make sure the temporary resource group is no longer listed among the available resource groups. The permanent resource group should still be present
az group list --output table

:: ===================================================
:: === Subtask 3: Azure Container Registry (ACR)
:: ===================================================

:: 1. Set a variable for the Azure Container Registry name (use alphanumeric characters only)
SET MODULE2_ACR=module2acr%RANDOM_NUMBER%
SET TEMPORARY_SP=temporary-sp-%RANDOM_NUMBER%
SET TEMPORARY_WA=temporary-wa-%RANDOM_NUMBER%
set TEMPORARY_IMAGE=%MODULE2_ACR%.azurecr.io/webapp:latest

echo %MODULE2_ACR%
echo %TEMPORARY_SP%
echo %TEMPORARY_WA%
echo %TEMPORARY_IMAGE%

:: 2. Use the az acr create command to create an Azure Container Registry in the permanent resource group with the Basic service tier (SKU - Stock-Keeping Unit) and enabling the admin user authentication feature.
az acr create --name %MODULE2_ACR% --resource-group %PERMANENT_RG% --sku Basic --admin-enabled --output json

:: 3. Use the az resource list command to list the resources in the permanent resource group. Use the proper option to get a table
az resource list --resource-group %PERMANENT_RG% --output table

:: 4. Use the az acr credential show command to retrieve the username and password. Use --output yaml option. This will display the credentials in a YAML format. Please make sure to save them for the next subtask
az acr credential show --name %MODULE2_ACR% --resource-group %PERMANENT_RG% --output yaml

:: ===================================================
:: === Subtask 4: Creating a GitHub repository and setting a secret
:: ===================================================

:: 1. Go to https://github.com and sign in to your GitHub account.
:: 2. Create an empty public repository, set the repository name as "webapp." Please don't add README or .gitignore files.
:: 3. Please make sure to save the link to your repository (e.g., https://github.com/youraccount/webapp.git).
:: 4. Click on the "Settings" tab.
:: 5. In the left sidebar, under the "Security" section, click on "Secrets and variables" > "Actions."
:: 6. Click on the "New repository secret" button.
:: 7. Set the name of the secret as "WEBAPPSECRET", enter the value of your Azure Container Registry password (password 1) that you saved from Subtask 3, and click "Add secret."

:: ===================================================
:: === Subtask 5: CI/CD to Azure Container Registry with GitHub Actions
:: ===================================================

:: 1. Download and unpack the attachment/webapp.zip file.
:: 2. Navigate to the webapp folder.
:: 3. Inspect the provided Dockerfile which serves as a set of instructions for Docker on building an image for the web application:
:: 4. Go to the .github/workflows/ directory.
:: 5. Inspect the provided ci_cd.yml file which is a GitHub Actions workflow configuration file. It defines a CI/CD (Continuous Integration and Continuous Deployment) process that triggers on push events to the master branch.
:: 6. Update the environment variables with your values that you saved from Subtask 3
:: 7. Open a terminal and navigate to the root folder of the project.
:: 8. Initialize a new Git repository by running the command
:: 9. Add all the files in the directory to the Git repository by running the command:
:: 10. Commit the changes by running the command:
:: 11. Connect your local repository to the remote repository by running the command:
:: 12. Ensure that the current branch is named master before pushing it to the remote repository:
:: 13. Push the changes to the remote repository by running the command:
:: 14. Visit your GitHub repository and open the "Actions" tab to check the CI/CD process.

:: 15. Use the az acr repository list command to list the repositories in "yourcontainerregistry". Use the proper option to get a table.
az acr repository list --name %MODULE2_ACR% --output table

:: 16. Use the az acr repository show-tags command to display the Docker image tags for the "webapp" repository.
az acr repository show-tags --name %MODULE2_ACR% --repository webapp --output table

:: 17. Navigate to the webapp/src/main/resources/templates/ folder of the project and open the home.html file
:: 18. Edit the file and change the <h1> title to "Welcome to Web App with CI/CD!".
:: 19. Commit and push your changes.
:: 20. After the GitHub Actions workflow finishes executing, check your Azure Container Registry repository for the new Docker image with an updated tag corresponding to the new commit SHA.

:: 21. Use the az acr repository show-tags command with --orderby time_desc option to find the oldest image.
az acr repository show-tags --name %MODULE2_ACR% --repository webapp --orderby time_desc --output table

:: 22. Use the az acr repository delete command with the full SHA of the oldest image (in our case, a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0) and the -y option to delete it. The -y option is used to automatically confirm the deletion without waiting for interactive user input.
FOR /F "usebackq tokens=* delims=" %A IN (`az acr repository show-manifests --name %MODULE2_ACR% --repository webapp --orderby time_asc --query "[0].digest" --output tsv`) DO ( SET OLDEST_IMAGE_SHA=%A )
az acr repository delete --name %MODULE2_ACR% --image webapp@%OLDEST_IMAGE_SHA% --yes

:: 23. Recheck that the oldest image has been deleted.
az acr repository show-tags --name %MODULE2_ACR% --repository webapp --orderby time_desc --output table

:: ===================================================
:: === Subtask 6: Creating a Web App in Azure App Services
:: ===================================================

:: 1. Use the az group create command to create a temporary resource group in East US location.
az group create --resource-group %TEMPORARY_RG% --location %LOCATION_EAST%

:: 2. Use the az appservice plan create command to create an App Service plan in East US location.
az appservice plan create --name %TEMPORARY_SP% --resource-group %TEMPORARY_RG% --sku B1 --is-linux

:: 3. Use the az webapp create command to create the web app and deploy the container image.
az webapp create --name %TEMPORARY_WA% --plan %TEMPORARY_SP% --resource-group %TEMPORARY_RG% --deployment-container-image-name %TEMPORARY_IMAGE%

:: 4. Wait a few minutes for the web app to be deployed and accessible.
:: 5. Open your web browser and visit the web app at the following address:

:: 6. Once you have confirmed that the web app is running correctly, to save costs, delete the temporary resource group using the following command:
az group delete --name %TEMPORARY_RG% --yes --no-wait
az group delete --name %PERMANENT_RG% --yes --no-wait