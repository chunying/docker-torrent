#!/bin/sh

_USER=${TORRENT_USER:-torrent}
_PASS=${TORRENT_PASS:-password}
_UID=${USER_UID:-1000}
_GID=${USER_GID:-1000}

## create built-in dirs
if [ ! -d /torrents/downloads ];  then /usr/bin/mkdir -p /torrents/downloads;  fi
if [ ! -d /torrents/incomplete ]; then /usr/bin/mkdir -p /torrents/incomplete; fi

## create the system user with a password, and setup transmission
if ! /usr/bin/id "$_USER" > /dev/null 2>&1; then
	## system user
	/usr/sbin/addgroup --gid $_GID "$_USER"
	/usr/sbin/adduser --uid $_UID --gid $_GID --comment '' --disabled-password "$_USER"
	/usr/sbin/adduser "$_USER" sudo
	echo "$_USER:$_PASS" | /usr/sbin/chpasswd
	## setup transmission
	/usr/bin/sed -i -e 's/"rpc-username": "[^"]*"/"rpc-username": "'$_USER'"/g' /etc/transmission-daemon/settings.json
	/usr/bin/sed -i -e 's/"rpc-password": "[^"]*"/"rpc-password": "'$_PASS'"/g' /etc/transmission-daemon/settings.json
	/usr/bin/sed -i -e 's/"rpc-whitelist": "[^"]*"/"rpc-whitelist": "10.*.*.*,192.*.*.*,172.*.*.*,127.*.*.*"/g' /etc/transmission-daemon/settings.json
	/usr/bin/sed -i -e 's/"download-dir": "[^"]*"/"download-dir": "\/torrents\/downloads"/g' /etc/transmission-daemon/settings.json
	/usr/bin/sed -i -e 's/"incomplete-dir": "[^"]*"/"incomplete-dir": "\/torrents\/incomplete"/g' /etc/transmission-daemon/settings.json
	/usr/bin/sed -i -e 's/"incomplete-dir-enabled": false/"incomplete-dir-enabled": true/g' /etc/transmission-daemon/settings.json
	## fix permission
	chown -R $_UID:$_GID /etc/transmission-daemon
	chown -R $_UID:$_GID /var/lib/transmission-daemon/.config/transmission-daemon
fi

## create required devices
if [ ! -d /dev/net ]; then mkdir /dev/net; fi
if [ ! -e /dev/net/tun ]; then mknod /dev/net/tun c 10 200; fi

## start webmin
/etc/init.d/webmin start

exec /sbin/start-stop-daemon --start --chuid $_UID:$_GID --pidfile /var/run/transmission-daemon.pid --exec /usr/bin/transmission-daemon -- -f --config-dir /var/lib/transmission-daemon/info

## fail-safe
exec /usr/bin/sleep infinity
