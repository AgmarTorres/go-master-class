
docker pull postgres:12-alpine
docker run --name postgres12 -p 5431:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=docker -d postgres:12-alpine

docker exec -it postgres12 psql -U root
docker logs postgres12