package com.chtrembl.petstorefunc;

import com.chtrembl.petstorefunc.model.Order;
import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.OutputBinding;
import com.microsoft.azure.functions.annotation.BlobInput;
import com.microsoft.azure.functions.annotation.BlobOutput;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.ServiceBusQueueTrigger;
import com.microsoft.azure.functions.annotation.StorageAccount;

import java.util.Optional;

public class ServiceBusQueueTriggerJava {
    @FunctionName("OrderHistorySaveServiceBus")
    @StorageAccount("AzureWebJobsStorage")
    public void orderHistory(
            @ServiceBusQueueTrigger(
                    name = "message",
                    queueName = "%SERVICEBUS_QUEUE_NAME%",
                    connection = "AzureWebJobsServiceBus"
            ) Order order,
            @BlobInput(name = "source", path = "archive/{id}.json") Optional<Order> source,
            @BlobOutput(name = "target", path = "archive/{id}.json") OutputBinding<Order> target,
            final ExecutionContext context) {
        context.getLogger().info("Java HTTP trigger processed a request.");

        target.setValue(order);
    }
}
