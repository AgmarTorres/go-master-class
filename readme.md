
docker pull postgres:12-alpine
docker run --name postgres12 -p 5431:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=docker -d postgres:12-alpine

docker exec -it postgres12 psql -U root
docker logs postgres12

instalar o migrate 

# Using migration
migrate create -ext sql -dir db/migration -seq init_schema

# Docker
  docker ps
  docker start postgres12
  docker stop postgres12

  docker exec -it postgres12 /bin/sh
    createdb --username=root --owner=root simple_bank
      psql simple_bank
      \q
    dropdb simple_bank
    exit
  
  history | grep "docker run"


# Migration

  migrate -path db/migration -database "postgresql://root:docker@localhost:5431/simple_bank?sslmode=disable" -verbose up  


# Snap

  sudo apt-get update && sudo apt-get install -yqq daemonize dbus-user-session fontconfig

  sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target

  exec sudo nsenter -t $(pidof systemd) -m -p su - $LOGNAME

  snap version