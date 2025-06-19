package com.chtrembl.petstore.product.config;

import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.security.keyvault.secrets.SecretClient;
import com.azure.security.keyvault.secrets.SecretClientBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class KeyVaultSecretService {
    @Autowired
    private final SecretClientBuilder secretClientBuilder;

    public KeyVaultSecretService(@Value("${secret.keyvault-endpoint}") String keyVaultEndpoint) {
        this.secretClientBuilder = new SecretClientBuilder()
                .vaultUrl(keyVaultEndpoint)
                .credential(new DefaultAzureCredentialBuilder().build());
    }

    public String getSecretByUrl(String secretUrl) {
        return secretClientBuilder.buildClient()
                .getSecret(secretUrl)
                .getValue();
    }
}
