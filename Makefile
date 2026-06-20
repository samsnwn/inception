NAME		= inception
COMPOSE		= ./srcs/docker-compose.yml
HOST_URL	= samcasti.42.fr
DATA_DIR	= ~/data
SECRETS_DIR = /secrets

all: up

up:
	@mkdir -p $(DATA_DIR)/database
	@mkdir -p $(DATA_DIR)/wordpress_files
	@sudo hostsed add 127.0.0.1 $(HOST_URL) > /dev/null 2>&1 || true
	@docker compose -p $(NAME) -f $(COMPOSE) up --build

down:
	@docker compose -p $(NAME) -f $(COMPOSE) down

clean:
	@docker compose -p $(NAME) -f $(COMPOSE) down -v --rmi all

fclean: clean
	@sudo rm -rf $(DATA_DIR)
	@sudo rm -rf secrets srcs/.env
	@sudo hostsed rm 127.0.0.1 $(HOST_URL) > /dev/null 2>&1 || true
	@docker system prune -a --volumes -f

prepare:
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all up down clean fclean prepare re