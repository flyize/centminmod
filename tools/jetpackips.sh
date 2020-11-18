#!/bin/bash
#######################################################
# https://community.centminmod.com/threads/20700/
#######################################################
# set locale temporarily to english
# due to some non-english locale issues
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

jetpackallowips=$(curl -4sk https://jetpack.com/ips-v4.txt | awk '{print "allow "$1";"}')
echo "populating include file /usr/local/nginx/conf/jetpack_whitelist_ip.conf with:"
echo
echo -e "# jetpack ip whitelist https://jetpack.com/support/hosting-faq/\n$jetpackallowips\ndeny all;" | tee /usr/local/nginx/conf/jetpack_whitelist_ip.conf

echo -e "\nupdate your wordpress site nginx vhost's xml-rpc.php location context with"
echo -e "include file for /usr/local/nginx/conf/jetpack_whitelist_ip.conf\n"
echo 'location ~* /(xmlrpc\.php) {
    limit_req zone=xwprpc burst=45 nodelay;
    #limit_conn xwpconlimit 30;
    include /usr/local/nginx/conf/php-wpsc.conf;
    # https://jetpack.com/support/hosting-faq/
    include /usr/local/nginx/conf/jetpack_whitelist_ip.conf;
    # https://community.centminmod.com/posts/18828/
    #include /usr/local/nginx/conf/php-rediscache.conf;
}'

echo -e "\nif you need to disable deny all, comment out with hash #"
echo -e "in front of include directive & restart nginx\n"
echo 'location ~* /(xmlrpc\.php) {
    limit_req zone=xwprpc burst=45 nodelay;
    #limit_conn xwpconlimit 30;
    include /usr/local/nginx/conf/php-wpsc.conf;
    # https://jetpack.com/support/hosting-faq/
    #include /usr/local/nginx/conf/jetpack_whitelist_ip.conf;
    # https://community.centminmod.com/posts/18828/
    #include /usr/local/nginx/conf/php-rediscache.conf;
}'