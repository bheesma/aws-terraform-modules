check_devops_container() {
    # Check if a container with the name "devops" is running
    if ! docker ps --format '{{.Names}}' | grep -q devops; then
        # Check if a container with the name "devops" is stopped
        if docker ps -a --filter "name=devops" --filter "status=exited" | grep -q devops; then
            # Start the stopped devops container
            docker start devops >/dev/null
        else
            # Start the devops container
            docker run -d -v "$HOME"/.aws:/root/.aws -v "$(pwd)":/app  --name devops devops:latest >/dev/null
        fi
    fi

    cmd="docker exec -it devops $@"
    eval $cmd
}

aws() { check_devops_container "$0 $*" }
terraform() { check_devops_container "$0 $*" }
cdk() { check_devops_container "$0 $*" }
ansible() { check_devops_container "$0 $*" }
node() { check_devops_container "$0 $*" }