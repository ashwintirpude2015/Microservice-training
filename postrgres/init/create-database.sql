CREATE DATABASE account_db;

\connect customer_db

GRANT ALL PRIVILEGES ON DATABASE customer_db TO banking;
GRANT ALL PRIVILEGES ON SCHEMA public TO banking;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO banking;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO banking;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO banking;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO banking;

\connect account_db

GRANT ALL PRIVILEGES ON DATABASE account_db TO banking;
GRANT ALL PRIVILEGES ON SCHEMA public TO banking;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO banking;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO banking;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO banking;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO banking;


      docker run -d \
--name postgres \
--network banking-network \
-p 5432:5432 \
-v postgres-data:/var/lib/postgresql/data \
-e POSTGRES_DB=customer_db \
-e POSTGRES_USER=banking \
-e POSTGRES_PASSWORD=banking \
postgres:16



docker run -d \
--name account-service16 \
--network banking-network \
-p 8082:8082 \
-e DB_URL=jdbc:postgresql://postgres:5432/account_db \
-e DB_USERNAME=banking \
-e DB_PASSWORD=banking \
-e CUSTOMER_SERVICE_URL=http://customer-service16:8081 \
account-service16

docker run -d \
--name client-ui \
--network banking-network \
-p 5172:80 \
client-ui