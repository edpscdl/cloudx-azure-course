import http from 'k6/http';
import { sleep } from 'k6';

export default function () {
    http.get('https://ps-awa-petstoreorderservice-bsa0d6dbbsh8exeg.eastus-01.azurewebsites.net/petstoreorderservice/v2/store/order/705E9BBE85D863BD7502ED0F362AA4BF');
    sleep(1); // Adjust the sleep time as needed
}
