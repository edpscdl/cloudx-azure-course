import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '1m', target: 10 },   // Ramp-up to 10 users over 1 minute
        { duration: '5m', target: 10 },   // Stay at 10 users for 5 minutes
    ],
};

export default function () {
    http.get('https://ps-awa-petstoreorderservice-bsa0d6dbbsh8exeg.eastus-01.azurewebsites.net/petstoreorderservice/v2/store/order/705E9BBE85D863BD7502ED0F362AA4BF');
    sleep(1);
}
