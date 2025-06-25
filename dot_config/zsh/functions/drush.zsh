function drush() {
  # Case 1: Try using ddev if available and applicable
  if command -v ddev >/dev/null 2>&1 && ddev describe >/dev/null 2>&1; then
    ddev drush "$@"
    return
  fi

  # Determine the path to docker-compose.yml
  if [ -f "./docker-compose.yml" ] || [ -f "./docker-compose.yaml" ]; then
    compose_file=$( [ -f "./docker-compose.yml" ] && echo "./docker-compose.yml" || echo "./docker-compose.yaml" )
  else
    echo "❌ No docker-compose.yml found in the current directory."
    return 1
  fi

  # Extract the PHP service name from docker-compose.yml using yq or awk
  # We'll use grep to find the service names
  php_service_name=$(grep -E '^[[:space:]]{2,}php:' "$compose_file" | sed 's/^\s*//;s/:$//')
  
  if [ -z "$php_service_name" ]; then
    echo "❌ Could not determine the PHP service name from docker-compose.yml."
    return 1
  fi

  # Try using docker ps to find the PHP container
  # Adjust the project name to match your container naming convention
  # Let's attempt to extract the project name from the running containers
  php_container=$(docker ps --filter "name=${php_service_name}" --format '{{.Names}}' | grep -E "${php_service_name}$" | head -n1)

  if [ -z "$php_container" ]; then
    # If not found, try finding containers with 'php' in their names
    php_container=$(docker ps --format '{{.Names}}' | grep -E 'php' | head -n1)
  fi

  if [ -z "$php_container" ]; then
    echo "❌ Could not find a running PHP container to execute drush."
    return 1
  fi

  # Execute drush in the found container
  docker exec -i "$php_container" drush "$@"
}

