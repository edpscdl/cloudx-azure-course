@ECHO OFF

docker build -t petstoreapp ./petstoreapp
docker build -t petstoreorderservice ./petstoreorderservice
docker build -t petstorepetservice ./petstorepetservice
docker build -t petstoreproductservice ./petstoreproductservice

az login

az acr login --name psacr452

docker tag petstoreapp:latest psacr452.azurecr.io/petstoreapp:latest
docker tag petstoreorderservice:latest psacr452.azurecr.io/petstoreorderservice:latest
docker tag petstorepetservice:latest psacr452.azurecr.io/petstorepetservice:latest
docker tag petstoreproductservice:latest psacr452.azurecr.io/petstoreproductservice:latest

docker tag petstoreapp:latest psacr452.azurecr.io/petstoreapp:v1
docker tag petstoreorderservice:latest psacr452.azurecr.io/petstoreorderservice:v1
docker tag petstorepetservice:latest psacr452.azurecr.io/petstorepetservice:v1
docker tag petstoreproductservice:latest psacr452.azurecr.io/petstoreproductservice:v1

docker push psacr452.azurecr.io/petstoreapp:latest
docker push psacr452.azurecr.io/petstoreorderservice:latest
docker push psacr452.azurecr.io/petstorepetservice:latest
docker push psacr452.azurecr.io/petstoreproductservice:latest

docker push psacr452.azurecr.io/petstoreapp:v1
docker push psacr452.azurecr.io/petstoreorderservice:v1
docker push psacr452.azurecr.io/petstorepetservice:v1
docker push psacr452.azurecr.io/petstoreproductservice:v1

docker build -t petstoreapp ./petstoreapp
docker build -t petstoreorderservice ./petstoreorderservice
docker build -t petstorepetservice ./petstorepetservice
docker build -t petstoreproductservice ./petstoreproductservice

docker tag petstoreapp:latest psacr452.azurecr.io/petstoreapp:latest
docker tag petstoreorderservice:latest psacr452.azurecr.io/petstoreorderservice:latest
docker tag petstorepetservice:latest psacr452.azurecr.io/petstorepetservice:latest
docker tag petstoreproductservice:latest psacr452.azurecr.io/petstoreproductservice:latest

docker tag petstoreapp:latest psacr452.azurecr.io/petstoreapp:v2
docker tag petstoreorderservice:latest psacr452.azurecr.io/petstoreorderservice:v2
docker tag petstorepetservice:latest psacr452.azurecr.io/petstorepetservice:v2
docker tag petstoreproductservice:latest psacr452.azurecr.io/petstoreproductservice:v2

docker push psacr452.azurecr.io/petstoreapp:latest
docker push psacr452.azurecr.io/petstoreorderservice:latest
docker push psacr452.azurecr.io/petstorepetservice:latest
docker push psacr452.azurecr.io/petstoreproductservice:latest

docker push psacr452.azurecr.io/petstoreapp:v2
docker push psacr452.azurecr.io/petstoreorderservice:v2
docker push psacr452.azurecr.io/petstorepetservice:v2
docker push psacr452.azurecr.io/petstoreproductservice:v2

k6 run constant-load-app.js
k6 run constant-load-order-service.js
k6 run constant-load-pet-service.js
k6 run constant-load-product-service.js