# Rooms Booking

## Overview
* A small APIs for rooms booking application

## Instuctions
1. Setup Docker
	* Install Docker to your machine follow the [instructor](https://www.docker.com/community-edition)
2. Build your image
	* Go to docker folder and run the following command to build image
	
	```
	docker-compose build
	```
3. Run the api application
	* Run the following command to start the api container

	```
	docker-compose run --service-ports api bash
	```
	* In this terminal, run the following command to start gcloud emulators

	```
	/root/google-cloud-sdk/bin/gcloud beta emulators pubsub start
	```
	* Open orther terminal, get container ID of api

	```
	docker ps | grep api
	```
	* Login into api container. Let's assume container id is `4b82b903a658 `

	```
	docker exec -it 4b82b903a658 bash 
	```
	* Run the following command to connect to gcloud emulators pubsub
	
	```
	eval `/root/google-cloud-sdk/bin/gcloud beta emulators pubsub env-init`
	```
	* Run the following command to start api application

	```
	rails s -b 0
	```
	
	