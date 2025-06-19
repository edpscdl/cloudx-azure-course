package com.chtrembl.petstore.product.service;

import com.chtrembl.petstore.product.config.KeyVaultSecretService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class StertUpService {
    @Value("${secret.postgresql.host-url}")
    private String postgresqlHost;
    @Value("${secret.postgresql.port-url}")
    private String postgresqlPort;
    @Value("${secret.postgresql.username-url}")
    private String postgresqlUsername;
    @Value("${secret.postgresql.password-url}")
    private String postgresqlUserPassword;

    private final KeyVaultSecretService keyVaultSecretService;

    @EventListener
    public void handleAppReady(ApplicationReadyEvent event) {
        log.info("Application ready");

        log.info("Example to rertive secret by direct URL");

        log.info("secret URL [{}], and value [{}]", postgresqlHost, keyVaultSecretService.getSecretByUrl(postgresqlHost));
        log.info("secret URL [{}], and value [{}]", postgresqlPort, keyVaultSecretService.getSecretByUrl(postgresqlPort));
        log.info("secret URL [{}], and value [{}]", postgresqlUsername, keyVaultSecretService.getSecretByUrl(postgresqlUsername));
        log.info("secret URL [{}], and value [{}]", postgresqlUserPassword, keyVaultSecretService.getSecretByUrl(postgresqlUserPassword));
    }
}
