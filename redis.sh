yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
yum module enable redis:remi-6.2 -y
yum install redis -y
#update listen address vim /etc/redis.conf & vim /etc/redis/redis.conf
systemctl enable redis
systemctl restart redis