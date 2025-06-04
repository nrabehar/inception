# Inception Project Makefile
# nrabehar@student.42antananarivo.mg

# Variables
COMPOSE_FILE = docker-compose.yml
DOMAIN = nrabehar.42.fr
DATA_PATH = /home/nrabehar/data

# Colors for output
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[1;33m
NC = \033[0m # No Color

.PHONY: all build up down clean fclean re logs status test help setup-data setup-hosts

# Default target
all: setup-data setup-hosts build up

# Setup data directories
setup-data:
	@echo "$(YELLOW)📁 Setting up data directories...$(NC)"
	@sudo mkdir -p $(DATA_PATH)/wordpress $(DATA_PATH)/mariadb
	@sudo chown -R $(USER):$(USER) $(DATA_PATH)
	@echo "$(GREEN)✅ Data directories created!$(NC)"

# Build all containers
build:
	@echo "$(YELLOW)🔨 Building Docker containers...$(NC)"
	sudo docker compose -f $(COMPOSE_FILE) build
	@echo "$(GREEN)✅ Build completed!$(NC)"

# Start all services
up: setup-data setup-hosts build
	@echo "$(YELLOW)🚀 Starting services...$(NC)"
	sudo docker compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)✅ Services started!$(NC)"
	@echo "$(GREEN)🌐 Website available at: https://$(DOMAIN)$(NC)"

# Stop all services
down:
	@echo "$(YELLOW)⏹️  Stopping services...$(NC)"
	sudo docker compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN)✅ Services stopped!$(NC)"

# Clean containers and networks
clean: down
	@echo "$(YELLOW)🧹 Cleaning containers and networks...$(NC)"
	sudo docker system prune -f
	@echo "$(GREEN)✅ Cleanup completed!$(NC)"

# Full clean including volumes and data
fclean: down
	@echo "$(RED)🗑️  Full cleanup (including volumes and data)...$(NC)"
	sudo docker compose -f $(COMPOSE_FILE) down -v
	sudo docker system prune -af
	sudo docker volume prune -f
	sudo rm -rf $(DATA_PATH)/wordpress/* $(DATA_PATH)/mariadb/*
	@echo "$(GREEN)✅ Full cleanup completed!$(NC)"

# Restart all services
re: fclean up

# Show logs
logs:
	@echo "$(YELLOW)📋 Showing logs...$(NC)"
	sudo docker compose -f $(COMPOSE_FILE) logs -f

# Show service status
status:
	@echo "$(YELLOW)📊 Service status:$(NC)"
	sudo docker compose -f $(COMPOSE_FILE) ps

# Test WordPress connection
test:
	@echo "$(YELLOW)🧪 Testing WordPress connection...$(NC)"
	@if curl -k -s https://$(DOMAIN) > /dev/null; then \
		echo "$(GREEN)✅ WordPress is accessible at https://$(DOMAIN)$(NC)"; \
	else \
		echo "$(RED)❌ WordPress is not accessible$(NC)"; \
	fi

# Add domain to /etc/hosts (requires sudo)
setup-hosts:
	@echo "$(YELLOW)🌐 Adding domain to /etc/hosts...$(NC)"
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts; \
		echo "$(GREEN)✅ Domain added to /etc/hosts$(NC)"; \
	else \
		echo "$(GREEN)✅ Domain already exists in /etc/hosts$(NC)"; \
	fi

# WordPress CLI access
wp-cli:
	@echo "$(YELLOW)🔧 Accessing WordPress CLI...$(NC)"
	sudo docker compose -f $(COMPOSE_FILE) exec wordpress wp --info --allow-root

# Database access
db:
	@echo "$(YELLOW)🗄️  Accessing MariaDB...$(NC)"
	sudo docker compose -f $(COMPOSE_FILE) exec mariadb mysql -u wpuser -p wordpress

# Show help
help:
	@echo "$(GREEN)Inception Project - Available commands:$(NC)"
	@echo ""
	@echo "$(YELLOW)  make build$(NC)     - Build Docker containers"
	@echo "$(YELLOW)  make up$(NC)        - Start all services"
	@echo "$(YELLOW)  make down$(NC)      - Stop all services"
	@echo "$(YELLOW)  make clean$(NC)     - Clean containers and networks"
	@echo "$(YELLOW)  make fclean$(NC)    - Full cleanup including volumes"
	@echo "$(YELLOW)  make re$(NC)        - Restart all services (fclean + up)"
	@echo "$(YELLOW)  make logs$(NC)      - Show service logs"
	@echo "$(YELLOW)  make status$(NC)    - Show service status"
	@echo "$(YELLOW)  make test$(NC)      - Test WordPress accessibility"
	@echo "$(YELLOW)  make hosts$(NC)     - Add domain to /etc/hosts"
	@echo "$(YELLOW)  make wp-cli$(NC)    - Access WordPress CLI"
	@echo "$(YELLOW)  make db$(NC)        - Access MariaDB"
	@echo "$(YELLOW)  make help$(NC)      - Show this help"
	@echo ""
	@echo "$(GREEN)Website: https://$(DOMAIN)$(NC)"
