#! /bin/sh

# Create overlay networks
docker network create --driver overlay backend
docker network create --driver overlay frontend

# Create frontend services
docker service create --name=vote --network=frontend --replicas=2 -p 80:80 bretfisher/examplevotingapp_vote
docker service create --name=redis --network=frontend redis:3.2

# Create backend services
docker service create --name=db --network=backend -e POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,source=db-data,target=/var/lib/postgresql/data postgres:9.4
docker service create --name=result --network=backend -p 5010:80 bretfisher/examplevotingapp_result

# Create worker service
docker service create --name=worker --network=frontend --network=backend bretfisher/examplevotingapp_worker
