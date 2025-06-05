import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '1m', target: 10 },    // Ramp-up to 10 users over 1 minute
        { duration: '1m', target: 50 },    // Spike to 50 users in 1 minute
        { duration: '1m', target: 150 },    // Spike to 50 users in 1 minute
        { duration: '5m', target: 250 },    // Stay at 50 users for 5 minutes
    ],
};

export default function () {

    let data_add = {"id": "68FAE9B1D86B794F0AE0ADD35A437428", "email": "customer@example.com", "products": [{"id": 1, "quantity": 2, "name": "Ball", "photoURL": "https://raw.githubusercontent.com/chtrembl/staticcontent/master/dog-toys/ball.jpg?raw=true"}], "status": "placed", "complete": false}

    let data_odd = {"id": "68FAE9B1D86B794F0AE0ADD35A437428", "email": "customer@example.com", "products": [{"id": 1, "quantity": -2, "name": "Ball", "photoURL": "https://raw.githubusercontent.com/chtrembl/staticcontent/master/dog-toys/ball.jpg?raw=true"}], "status": "placed", "complete": false}

    http.post('https://ps-awa-petstoreorderservice-bsa0d6dbbsh8exeg.eastus-01.azurewebsites.net/petstoreorderservice/v2/store/order', data_add,
        { headers: { 'accept': 'application/json', 'Content-Type': 'application/json' } });
    http.post('https://ps-awa-petstoreorderservice-bsa0d6dbbsh8exeg.eastus-01.azurewebsites.net/petstoreorderservice/v2/store/order', data_odd,
        { headers: { 'accept': 'application/json', 'Content-Type': 'application/json' } });

    http.get('https://ps-awa-petstoreorderservice-bsa0d6dbbsh8exeg.eastus-01.azurewebsites.net/petstoreorderservice/v2/store/order/705E9BBE85D863BD7502ED0F362AA4BF');
    sleep(1);
}
