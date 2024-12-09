# docker-torrent

My simplest docker for torrent management

# quick start guide

- Clone this repo
- Modify the directories you want to place files
    - For downloaded files: `/path/to/local:/torrents/downloads:rw`
    - For incomplete files: `/path/to/local:/torrents/incomplete:rw`
- (Optional) Modify the default environment variables
    - `TORRENT_USER`: the login user name, default `torrent`
    - `TORRENT_PASS`: the login password, default `password`
    - `USER_UID`: the default user UID, default `1000`
    - `USER_GID`: the default user GID, default `1000`
- Bring up the docker instance: `docker compose up -d`
- You can access the console web GUI via the link
    - `https://<serveraddr>:10000/`
    - Replace the `<serveraddr>` with your server's IP address.
- You can access the transmission web GUI via the link
    - `http://<serveraddr>:9091/`
    - Replace the `<serveraddr>` with your server's IP address.

# some useful commands

- Create openvpn tunnel
  - Store username/password in `/openvpn/login.conf`
  - Store the vpn configuration in `/openvpn/openvpn.ovpn`
  - Activate the vpn
    ```
    sudo openvpn --config /openvpn/openvpn.ovpn --auth-user-pass /openvpn/login.conf --daemon
    ```
  - You may omit the `--daemon` option for debugging
  - Run `curl ipinfo.io` to test the outbound IP address

- Add download jobs via command line
  ```
  transmission-remote --auth torrent:password --add '<file-or-magnet-link>'
  ```

# Sample commands to mount a remote CIFS filesystem

  `mount.cifs "//$CIFS_SERVERIP/path/to/shared/folder" /mnt -o user=$CIFS_USER,pass=$CIFS_PASS,iocharset=utf8`

# Sample commands to mount a remote NFS filesystem

  `mount -t nfs $NFS_SERVERIP/path/to/exported/folder /mnt`

