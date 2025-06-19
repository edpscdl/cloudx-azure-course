package com.chtrembl.petstore.product.config;

import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.security.keyvault.secrets.SecretClient;
import com.azure.security.keyvault.secrets.SecretClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class KeyVaultService {
    private final SecretClient secretClient;

    public KeyVaultService(@Value("${secret.keyvault-endpoint}") String keyVaultEndpoint) {
        this.secretClient = new SecretClientBuilder()
                .vaultUrl(keyVaultEndpoint)
                .credential(new DefaultAzureCredentialBuilder().build())
                .buildClient();
    }

    public String getSecretByUrl(String secretUrl) {
        return secretClient.getSecret(secretUrl).getValue();
    }
}
