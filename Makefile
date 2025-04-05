NAME = inception

DOCKER_COMPOSE		=	docker-compose -f
COMPOSE_FILE		=	./srcs/docker-compose.yml

all:
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@$(DOCKER_COMPOSE) $(COMPOSE_FILE) up -d

build:
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@$(DOCKER_COMPOSE) $(COMPOSE_FILE) build

up:
	@$(DOCKER_COMPOSE) $(COMPOSE_FILE) up -d

down:
	@$(DOCKER_COMPOSE) $(COMPOSE_FILE) down

re: down up

clean: down
	@$(DOCKER_COMPOSE) $(COMPOSE_FILE) rm -f -s -v

fclean:
	@$(DOCKER_COMPOSE) $(COMPOSE_FILE) down --rmi all -v --remove-orphans

.PHONY: all up build down re clean fclean