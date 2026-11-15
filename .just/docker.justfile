clean:
    just docker::images-clean
    just docker::cache-clean
    just docker::networks-clean

images-clean:
    docker image prune --all --force

cache-clean:
    docker builder prune --all --force

networks-clean:
    docker network prune --force
