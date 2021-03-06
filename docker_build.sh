#!/bin/bash

if [ "$#" != "2" ]; then
    exit 1
else
    if [ "$(git status -s)" != "" ]; then
        echo "You need send changes first. Suggest \"git status\" to see more details"
        exit 1
    fi
    docker_tag="${1/v/}"
    docker_tag_2="${docker_tag}-$2"
    git tag "${docker_tag_2}" || exit 1
    git push 
    git push --tags
fi

docker build -t carlositline/nginx-php-fpm .
docker push carlositline/nginx-php-fpm

docker tag carlositline/nginx-php-fpm:latest "carlositline/nginx-php-fpm:${docker_tag}"
docker tag carlositline/nginx-php-fpm:latest "carlositline/nginx-php-fpm:${docker_tag_2}"
docker push "carlositline/nginx-php-fpm:${docker_tag}"
docker push "carlositline/nginx-php-fpm:${docker_tag_2}"