@ECHO OFF

docker build -t petstoreapp ./petstoreapp
docker build -t petstoreorderservice ./petstoreorderservice
docker build -t petstorepetservice ./petstorepetservice
docker build -t petstoreproductservice ./petstoreproductservice

az login

az acr login --name petstoreacr451

docker tag petstoreapp:latest petstoreacr451.azurecr.io/petstoreapp:latest
docker tag petstoreorderservice:latest petstoreacr451.azurecr.io/petstoreorderservice:latest
docker tag petstorepetservice:latest petstoreacr451.azurecr.io/petstorepetservice:latest
docker tag petstoreproductservice:latest petstoreacr451.azurecr.io/petstoreproductservice:latest

docker push petstoreacr451.azurecr.io/petstoreapp:latest
docker push petstoreacr451.azurecr.io/petstoreorderservice:latest
docker push petstoreacr451.azurecr.io/petstorepetservice:latest
docker push petstoreacr451.azurecr.io/petstoreproductservice:latest