SHELL := powershell.exe
buildRun:
	docker-compose --build

RegistoryPush:
	docker login gullycricket.azurecr.io --username gullycricket --password  $(gullycricketCrpass)

	docker tag capstone-project-inventory:latest gullycricket.azurecr.io/microservices/inventory
	docker tag capstone-project-matches:latest gullycricket.azurecr.io/microservices/matches
	docker tag capstone-project-auth:latest gullycricket.azurecr.io/microservices/auth
	docker tag capstone-project-gateway:latest gullycricket.azurecr.io/microservices/gateway

	docker push gullycricket.azurecr.io/microservices/inventory
	docker push gullycricket.azurecr.io/microservices/matches
	docker push gullycricket.azurecr.io/microservices/auth
	docker push gullycricket.azurecr.io/microservices/gateway