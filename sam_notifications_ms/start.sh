eval $(docker-machine env rancher-node2)
docker-compose build
docker-compose run --rm sam_notifications_ms rails db:create
docker-compose run --rm sam_notifications_ms rails db:migrate
docker-compose run --rm sam_notifications_ms yes | bundle exec rpush init
docker-compose up
