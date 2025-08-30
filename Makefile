all: build

build:
	@mkdir -p /home/nrabehar/data/mariadb
	@mkdir -p /home/nrabehar/data/wordpress
	@cd srcs && docker compose build

up: build
	@cd srcs && docker compose up -d

down:
	@cd srcs && docker compose down -v --rmi all

logs:
	@cd srcs && docker compose logs -f

status:
	@cd srcs && docker compose ps -a

clean: down

fclean: clean
	@sudo rm -rf /home/nrabehar/data/*

prune: fclean
	@docker system prune -a --volumes -f

re: fclean all

.PHONY: build up down logs status clean fclean
