import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '1m', target: 10 },
    ],
};

export default function () {
    http.get('https://ps-aca-psprods-452.thankfulfield-cc96ff4e.eastus.azurecontainerapps.io/petstoreproductservice/v2/product/all');
    sleep(1);
}
