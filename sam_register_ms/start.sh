docker-compose build
docker-compose run --rm sam_register_ms rails db:create
docker-compose run --rm sam_register_ms rails db:migrate
docker-compose up
