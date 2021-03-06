#!/bin/bash
WEBDIR="$1"
LIST=('filterinto.com' 'www.filterinto.com')
LED_LIST=()
WWW_ROOT=/usr/share/nginx/html
for domain in ${LIST[@]};do
    docker run \
        --rm \
        -v ${WEBDIR}/nginx/conf.crt:/etc/letsencrypt \
        -v ${WEBDIR}/logs/letsencrypt:/var/log/letsencrypt \
        -v ${WEBDIR}/nginx/html:${WWW_ROOT} \
        certbot:1.0 \
        certbot certonly --verbose --noninteractive --quiet --agree-tos \
        --webroot -w ${WWW_ROOT} \
        --email="nick.li@grapecity.com" \
        -d "$domain"
    CODE=$?
    if [ $CODE -ne 0 ]; then
        FAILED_LIST+=($domain)
    fi
done

# output failed domains
if [ ${#FAILED_LIST[@]} -ne 0 ];then
    echo 'failed domain:'
    for (( i=0; i<${#FAILED_LIST[@]}; i++ ));
    do
        echo ${FAILED_LIST[$i]}
    done
fi
