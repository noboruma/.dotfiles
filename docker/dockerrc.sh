function rmi-docker() {
    docker images -q --filter 'dangling=true' | xargs docker rmi
}
