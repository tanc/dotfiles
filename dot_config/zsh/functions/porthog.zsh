porthog() {
    # Authenticate sudo once at the beginning
    sudo -v

    printf "%-8s %-8s %s\n" "PORT" "PID" "PROCESS"
    printf "%-8s %-8s %s\n" "--------" "--------" "--------"
    for port in "$@"; do
        # Try using sudo lsof to find the process
        pids=($(sudo lsof -i :"$port" -sTCP:LISTEN -t 2>/dev/null))
        if [ ${#pids[@]} -gt 0 ]; then
            first=true
            for pid in "${pids[@]}"; do
                process=$(ps -p "$pid" -o comm= 2>/dev/null)
                if [ -z "$process" ]; then
                    process="-"
                fi
                if $first; then
                    printf "%-8s %-8s %s\n" "$port" "$pid" "$process"
                    first=false
                else
                    printf "%-8s %-8s %s\n" "" "$pid" "$process"
                fi
            done
            
            # Check if there is a Docker container using this port
            docker_container=$(docker ps --format "{{.Names}}" | xargs -I{} sh -c "docker port {} | grep -q \":$port\" && echo {}" | head -1)
            
            if [ -n "$docker_container" ]; then
                # Ask if user wants to stop the Docker container
                read -q "REPLY?Would you like to stop Docker container $docker_container using port $port? (y/N) "
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo "Stopping Docker container $docker_container"
                    docker stop "$docker_container"
                    echo "Docker container $docker_container has been stopped."
                fi
            else
                # Ask if user wants to kill the processes
                read -q "REPLY?Would you like to kill process(es) on port $port? (y/N) "
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    for pid in "${pids[@]}"; do
                        echo "Killing process $pid ($(ps -p "$pid" -o comm= 2>/dev/null))"
                        sudo kill -9 "$pid"
                    done
                    echo "All processes on port $port have been killed."
                fi
            fi
        else
            # Try using netstat to find the process
            netstat_pids=($(netstat -tuln | awk -v port="$port" '$4 ~ ":"port {print $7}' | cut -d'/' -f1 2>/dev/null))
            if [ ${#netstat_pids[@]} -gt 0 ]; then
                first=true
                for pid in "${netstat_pids[@]}"; do
                    process=$(ps -p "$pid" -o comm= 2>/dev/null)
                    if [ -z "$process" ]; then
                        process="-"
                    fi
                    if $first; then
                        printf "%-8s %-8s %s\n" "$port" "$pid" "$process"
                        first=false
                    else
                        printf "%-8s %-8s %s\n" "" "$pid" "$process"
                    fi
                done
                
                # Check if there is a Docker container using this port
                docker_container=$(docker ps --format "{{.Names}}" | xargs -I{} sh -c "docker port {} | grep -q \":$port\" && echo {}" | head -1)
                
                if [ -n "$docker_container" ]; then
                    # Ask if user wants to stop the Docker container
                    read -q "REPLY?Would you like to stop Docker container $docker_container using port $port? (y/N) "
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        echo "Stopping Docker container $docker_container"
                        docker stop "$docker_container"
                        echo "Docker container $docker_container has been stopped."
                    fi
                else
                    # Ask if user wants to kill the processes
                    read -q "REPLY?Would you like to kill process(es) on port $port? (y/N) "
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        for pid in "${netstat_pids[@]}"; do
                            echo "Killing process $pid ($(ps -p "$pid" -o comm= 2>/dev/null))"
                            sudo kill -9 "$pid"
                        done
                        echo "All processes on port $port have been killed."
                    fi
                fi
            else
                printf "%-8s %-8s %s\n" "$port" "-" "-"
            fi
        fi
    done
}