eval $(docker-machine env rancher-node2)
docker-compose build
curl -X PUT http://192.168.99.101:5984/scheduledsending
docker-compose up
