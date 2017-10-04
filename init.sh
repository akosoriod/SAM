sudo service docker start
docker-machine start rancher-server
sleep 2
docker-machine start rancher-node1
sleep 2
eval $(docker-machine env rancher-node1)
cd sam_api_gateway
docker-compose up -d
cd ../sam_sessions_ms
docker-compose up -d
cd ../sam_register_ms
docker-compose up -d
cd ../sam_notifications_ms
docker-compose up -d
cd ..
