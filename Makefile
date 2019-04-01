build:
	docker build . -t adilsoncarvalho/php-docker

clean:
	docker rmi adilsoncarvalho/php-docker
