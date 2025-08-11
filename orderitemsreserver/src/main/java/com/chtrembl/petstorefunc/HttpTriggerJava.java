package com.chtrembl.petstorefunc;

import com.chtrembl.petstorefunc.model.Order;
import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.HttpResponseMessage;
import com.microsoft.azure.functions.HttpStatus;
import com.microsoft.azure.functions.OutputBinding;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.BindingName;
import com.microsoft.azure.functions.annotation.BlobInput;
import com.microsoft.azure.functions.annotation.BlobOutput;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;
import com.microsoft.azure.functions.annotation.StorageAccount;

import java.util.Optional;

public class HttpTriggerJava {

    @FunctionName("OrderHistorySave")
    @StorageAccount("AzureWebJobsStorage")
    public HttpResponseMessage orderHistory(
            @HttpTrigger(name = "req", methods = {HttpMethod.POST}, authLevel = AuthorizationLevel.ANONYMOUS, route = "{sessionId}") HttpRequestMessage<Optional<Order>> request,
            @BindingName("sessionId") String sessionId,
            @BlobInput(name = "source", path = "archivehttp/{sessionId}.json") Optional<Order> source,
            @BlobOutput(name = "target", path = "archivehttp/{sessionId}.json") OutputBinding<Order> target,
            final ExecutionContext context) {
        context.getLogger().info("Java HTTP trigger processed a request.");

        int countBefore = source.map(order -> order.getProducts().size()).orElse(0);
        int countAfter = request.getBody().map(order -> order.getProducts().size()).orElse(0);

        if (request.getBody().isPresent()) {
            target.setValue(request.getBody().get());
        }

        String resultTemplate = "Result for sessionId[%s]: count products before [%d] products after [%d]";
        return request.createResponseBuilder(HttpStatus.OK).body(resultTemplate.formatted(
                sessionId, countBefore, countAfter
        )).build();
    }
}
