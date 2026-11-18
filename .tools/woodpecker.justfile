set working-directory := '..'

check:
    woodpecker-cli lint --strict .woodpecker/*.yml
