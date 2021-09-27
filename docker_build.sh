#!/bin/bash

docker build -t carlositline/nginx-php-fpm .
docker push carlositline/nginx-php-fpm

if [ "$1" == "" ]; then
    docker_tag=$(git describe --tags --abbrev=0)
else
    docker_tag="$1"
    docker_tag_2="$1-$2"
    git tag "${docker_tag_2}"
    git push --tags
fi

docker tag carlositline/nginx-php-fpm:latest "carlositline/nginx-php-fpm:${docker_tag}"
docker tag carlositline/nginx-php-fpm:latest "carlositline/nginx-php-fpm:${docker_tag_2}"
docker push "carlositline/nginx-php-fpm:${docker_tag}"
docker push "carlositline/nginx-php-fpm:${docker_tag_2}"