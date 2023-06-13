#!/bin/bash

# Check the number of arguments provided
if [ $# -eq 0 ]; then
  echo "No arguments provided. Usage: cmds.sh <command>"
  exit 1
fi

# Extract the first argument
command="$1"

# Execute commands based on the provided argument
case "$command" in
  "port")
    echo "Executing command 1..."
    port="3306"

    # Check if the port is in use
    process_info=$(sudo lsof -i :$port)
    if [ -z "$process_info" ]; then
        echo "Port $port is not in use."
        exit 1
    fi

    # Extract the process ID (PID) from the process info
    pid=$(echo "$process_info" | awk 'NR==2{print $2}')

    # Kill the process
    sudo kill $pid

    echo "Process with PID $pid has been terminated."
    ;;

  "docker")
    echo "Executing command docker"
    sudo service docker start
    sudo docker-compose build
    ;;

  "server")
    echo "Executing command server"
    sudo docker-compose up --remove-orphans
    ;;

  "mobile")
    echo "Executing command mobile"
    ;;

  *)
    echo "Invalid command. Available commands: command1, command2, command3"
    exit 1
    ;;
esac
