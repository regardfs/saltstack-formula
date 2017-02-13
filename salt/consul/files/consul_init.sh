#!/bin/bash
set -ex

cd /tmp

CONSULVERSION=0.7.4
CONSULDOWNLOAD=https://releases.hashicorp.com/consul/${CONSULVERSION}/consul_${CONSULVERSION}_linux_amd64.zip
CONSULWEBUI=https://releases.hashicorp.com/consul/${CONSULVERSION}/consul_${CONSULVERSION}_web_ui.zip
CONSULDIR=/usr/local/consul
CONSULCONFIGDIR=$CONSULDIR/consul.d
CONSULDATAC=$CONSULDIR/datacenter
CONSULBINDIP=$2
CONSULSERVER='172.17.8.101'
AGENTNAME=`hostname`
SERVERTYPE=$1

if [ $SERVERTYPE == 'server' ]; then
    serverconf='-server -bootstrap-expect=1 -data-dir="$CONSULDATAC"'
else
    serverconf="-join $CONSULSERVER"
fi


echo Fetching Consul...
curl -L $CONSULDOWNLOAD > consul.zip

echo Installing Consul...
unzip consul.zip -d /usr/local/bin
chmod 0755 /usr/local/bin/consul
chown root:root /usr/local/bin/consul

echo Configuring Consul...
mkdir -p $CONSULCONFIGDIR
chmod 755 $CONSULCONFIGDIR
mkdir -p $CONSULDIR
chmod 755 $CONSULDIR
mkdir -p $CONSULDATAC
chmod 755 $CONSULDATAC


curl -L $CONSULWEBUI > ui.zip
unzip ui.zip -d $CONSULDIR/ui


echo "Configuring start script..."
cat >> /etc/init/consul.conf << EOF
description "Consul"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

console log

script
  if [ -f "/etc/service/consul" ]; then
    . /etc/service/consul
  fi

  # Make sure to use all our CPUs, because Consul can block a scheduler thread
  export GOMAXPROCS=`nproc`

  exec /usr/local/bin/consul agent $serverconf \
    -node="$AGENTNAME" \
    -config-dir="$CONSULCONFIGDIR" \
    -bind="$CONSULBINDIP" \
    \$${CONSUL_FLAGS} \
    >>/var/log/consul.log 2>&1
end script
EOF

chmod 644 /etc/init/consul.conf
chown root:root  /etc/init/consul.conf