import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '1m', target: 10 },
    ],
};

export default function () {
    http.get('https://ps-aca-pspets-452.thankfulfield-cc96ff4e.eastus.azurecontainerapps.io/petstorepetservice/v2/pet/all');
    sleep(1);
}
