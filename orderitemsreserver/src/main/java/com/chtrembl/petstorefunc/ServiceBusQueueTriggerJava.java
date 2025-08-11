package com.chtrembl.petstorefunc;

import com.chtrembl.petstorefunc.model.Order;
import com.chtrembl.petstorefunc.model.Product;
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
                    name = "order",
                    queueName = "%SERVICEBUS_QUEUE_NAME%",
                    connection = "AzureWebJobsServiceBus"
            ) Order order,
            @BlobInput(name = "source", path = "archivemq/{id}.json") Optional<Order> source,
            @BlobOutput(name = "target", path = "archivemq/{id}.json") OutputBinding<Order> target,
            final ExecutionContext context) {
        context.getLogger().info("Java HTTP trigger processed a request.");

        int countBefore = source.map(sourceOrder -> sourceOrder.getProducts().size()).orElse(0);
        int countAfter = order.getProducts() != null ? order.getProducts().size() : 0;

        context.getLogger().info("Order id[" + order.getId() + "] old count[" + countBefore + "] new count[" + countAfter + "]");

        //It is only required to check for a message processing error.
        //If there are 3 items in the order, then we throw an error.
        if (order.getProducts() != null && order.getProducts().size() > 0) {
            order.getProducts().stream().map(Product::getQuantity).reduce(Integer::sum).filter(count -> count != 3).orElseThrow();
        }

        target.setValue(order);
    }
}
