DB_URL=postgresql://root:docker@localhost:5431/simple_bank?sslmode=disable

network:
	docker network create bank-network

postgreslocal:
	docker run --name postgres12 -p 5431:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=docker -d postgres:12-alpine

postgresprod:
	docker run --name postgres12 --network bank-network -p 5431:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=docker -d postgres:12-alpine

mysql:
	docker run --name mysql8 -p 3306:3306  -e MYSQL_ROOT_PASSWORD= -d mysql:8

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateuplocal:
	migrate -path db/migration -database "postgresql://root:docker@localhost:5431/simple_bank?sslmode=disable" -verbose up  

migratedownlocal:
	migrate -path db/migration -database "postgresql://root:docker@localhost:5431/simple_bank?sslmode=disable" -verbose down

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

db_docs:
	dbdocs build doc/db.dbml

db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/techschool/simplebank/db/sqlc Store

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
	--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_bank \
	proto/*.proto
	statik -src=./doc/swagger -dest=./doc

evans:
	evans --host localhost --port 9090 -r repl

.PHONY: network postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 db_docs db_schema sqlc test server mock proto evans