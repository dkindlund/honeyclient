#!/bin/bash +x

# Setup script, used to initialize the user database in RabbitMQ.

RABBITMQCTL_BIN="/usr/sbin/rabbitmqctl"
USERNAME="honeyclient"
PASSWORD="passw0rd"
VHOST="/honeyclient.org"
RABBIT_CREATE_BIN="bin/rabbitmq_create.py"

$RABBITMQCTL_BIN delete_user guest
$RABBITMQCTL_BIN delete_vhost /
$RABBITMQCTL_BIN add_vhost $VHOST
$RABBITMQCTL_BIN add_user $USERNAME $PASSWORD
$RABBITMQCTL_BIN set_permissions -p $VHOST $USERNAME ".*" ".*" ".*"

$RABBIT_CREATE_BIN --host 127.0.0.1 -u $USERNAME -p $PASSWORD --vhost=${VHOST}

