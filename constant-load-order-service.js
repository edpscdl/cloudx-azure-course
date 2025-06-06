import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '1m', target: 10 },
    ],
};

export default function () {
    http.get('https://ps-aca-psos-452.thankfulfield-cc96ff4e.eastus.azurecontainerapps.io/petstoreorderservice/v2/store/info');
    sleep(1);
}
