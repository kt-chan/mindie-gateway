docker build -f ./docker/dockerfile -t mindie-gateway . 
docker rm -f mindie-gateway
docker run -d -p 80:80  --name mindie-gateway mindie-gateway
docker logs -f mindie-gateway
