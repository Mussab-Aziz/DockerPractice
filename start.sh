#!/bin/bash

# AI Quiz Generator - Quick Start Script for Linux/macOS

echo ""
echo "===================================="
echo "AI Quiz Generator - Quick Start"
echo "===================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker is not installed"
    echo "Please install Docker: https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "[✓] Docker is installed"

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "[ERROR] Docker Compose is not available"
    exit 1
fi

echo "[✓] Docker Compose is available"
echo ""

# Menu function
show_menu() {
    echo "What would you like to do?"
    echo ""
    echo "1. Start development environment (docker-compose)"
    echo "2. Build production Docker image"
    echo "3. Run production container"
    echo "4. Open documentation"
    echo "5. View logs from development environment"
    echo "6. Clean up (remove containers/images)"
    echo "7. Exit"
    echo ""
}

# Loop for menu
while true; do
    show_menu
    read -p "Enter your choice (1-7): " choice

    case $choice in
        1)
            echo ""
            echo "Starting development environment..."
            echo ""
            docker-compose up
            ;;
        2)
            echo ""
            echo "Building production Docker image..."
            echo ""
            docker build -t ai-quiz-generator:latest --target production .
            echo ""
            echo "[✓] Image built successfully!"
            echo "Run 'docker run -p 3000:3000 ai-quiz-generator:latest' to start it"
            echo ""
            ;;
        3)
            echo ""
            echo "Starting production container..."
            echo "Port: 3000"
            echo ""
            if [ -f .env.local ]; then
                docker run -p 3000:3000 --env-file .env.local ai-quiz-generator:latest
            else
                echo "[WARNING] .env.local not found. Running without environment variables."
                docker run -p 3000:3000 ai-quiz-generator:latest
            fi
            ;;
        4)
            echo ""
            echo "Opening documentation..."
            if command -v xdg-open &> /dev/null; then
                xdg-open DOCKER_CICD_GUIDE.md
            elif command -v open &> /dev/null; then
                open DOCKER_CICD_GUIDE.md
            else
                echo "Please open DOCKER_CICD_GUIDE.md manually"
            fi
            echo ""
            ;;
        5)
            echo ""
            echo "Showing logs from development containers..."
            echo ""
            docker-compose logs -f
            ;;
        6)
            echo ""
            echo "Stopping all containers..."
            docker-compose down
            echo "Removing ai-quiz-generator images..."
            docker rmi ai-quiz-generator:latest 2>/dev/null
            docker rmi ai-quiz-generator:dev 2>/dev/null
            echo "[✓] Cleanup complete"
            echo ""
            ;;
        7)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
