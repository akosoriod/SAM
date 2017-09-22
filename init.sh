sudo service docker start
docker-machine start rancher-server
sleep 2
docker-machine start sam-services
sleep 2
eval $(docker-machine env sam-services)
cd sa_products_ms
docker-compose up -d
cd ../sa_users_ms
docker-compose up -d
cd ../sa_sales_ms
docker-compose up -d
cd ../sa_api_gateway
docker-compose up -d
cd ..
