NAME		= inception
COMPOSE		= ./srcs/docker-compose.yml
HOST_URL	= samcasti.42.fr
DATA_DIR	= ~/data
SECRETS_DIR = secrets
ENV_DIR		= srcs/.env

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
	@sudo rm -rf $(SECRETS_DIR) $(ENV_DIR)
	@sudo hostsed rm 127.0.0.1 $(HOST_URL) > /dev/null 2>&1 || true
	@docker system prune -a --volumes -f

re: fclean all

.PHONY: all up down clean fclean re