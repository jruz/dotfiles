set working-directory := '..'

VERSION := '44.178.3'

check:
    docker run \
        --rm \
        --volume "$PWD:/repo:ro" \
        --workdir /repo \
        ghcr.io/renovatebot/renovate:{{ VERSION }} \
        renovate-config-validator \
        --strict \
        --no-global \
        renovate.json

dry-run:
    RENOVATE_GITHUB_COM_TOKEN="${GITHUB_TOKEN:?GITHUB_TOKEN is not set}" \
    docker run \
        --rm \
        --volume "$PWD:/repo:ro" \
        --workdir /repo \
        --env LOG_LEVEL=debug \
        --env RENOVATE_GITHUB_COM_TOKEN \
        ghcr.io/renovatebot/renovate:{{ VERSION }} \
        renovate \
        --platform=local \
        --dry-run=lookup \
        > tmp/renovate-dry-run.log 2>&1
