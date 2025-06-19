package com.chtrembl.petstore.product.config;

import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.security.keyvault.secrets.SecretClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class KeyVaultSecretService {
    private final SecretClientBuilder secretClientBuilder;

    public KeyVaultSecretService(@Value("${secret.keyvault-endpoint}") String keyVaultEndpoint,
                                 @Value("${secret.client-id}") String clientId) {
        this.secretClientBuilder = new SecretClientBuilder()
                .vaultUrl(keyVaultEndpoint)
                .credential(new DefaultAzureCredentialBuilder().managedIdentityClientId(clientId).build());
    }

    public String getSecretByUrl(String secretUrl) {
        return secretClientBuilder.buildClient()
                .getSecret(secretUrl)
                .getValue();
    }
}
