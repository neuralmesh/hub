#!/bin/bash

if ! command -v yq &> /dev/null
then
    echo "yq could not be found, installing it..."
    sudo wget -O /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod +x /usr/bin/yq
fi

name=$(yq e '.name' config.yml)
port_extern=$(yq e '.port_extern' config.yml)
port_intern=$(yq e '.port_intern' config.yml)
repo_url=$(yq e '.repo_url' config.yml)

echo "Running llmos.sh with URL: $repo_url"
bash ./llmos.sh "$repo_url" "$name" "$port_extern" "$port_intern"

