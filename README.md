# Deployer

This repo contains all the necessary config and scripts to run [go-abassian](https://github.com/abassian/go-abassian) nodes.

## Minimum Requirements

1. Linux-based AMD64 arch type OS
2. Dual-core CPU
3. 2 GB RAM
4. Rsyslog installed

## New Node Setup

Please note this setup is meant for deployment on AWS EC2 Linux instances where the default user is `root`, but can be adjusted to your environment. **If your default user is not `root`, see [changing data dir](#changing-data-dir) for instructions.**

1. Clone repo
2. Create the `.abassian` data directory in your home directory: `~/.abassian`
3. [Create env file](#environment-setup)
4. Create the `PW_FILE` if you are attaching an account to the node
5. Create the `PK_FILE` if you are attaching an account to the node
6. Create the `BOOTNODE_KEY` if you are running a bootnode
7. [Setup log rotations](#setup-automatic-log-rotation)
8. `cd deployer/script`
9. Download the required binaries by running `./download-bin.sh`
10. Run init script and pass in your newly-created .env file: `./init.sh ~/.abassian/mainnet/.env`
11. Use the [system command](#start-service) to start the bootnode
12. Use the [system command](#start-service) to start the node

**Note: all system services automatically auto-run on reboots.**

## Changing Data Dir

If your default user is not `root` you will need to change the following. The default `DATA_DIR_ROOT` is set to `/home/root/.abassian`. You can change replace `root` with whatever your default user is: `/home/myuser/.abassian`.

1. `WorkingDirectory`, `EnvironmentFile`, and `ExecStart` fields in each `services/*.service` file
2. `DATA_DIR` in your .env file
3. `BOOTNODE_KEY` in your .env file (if running a bootnode)
4. `PW_FILE` in your .env file (if attaching an account)
5. `PK_FILE` in your .env file (if attaching an account)

## Environment Setup

- [Chain ID] 91 for mainnet and 9192 for testnet
- Bootnodes - view metadata folder for each network
- Default mainnet .env location: `~/.abassian/mainnet/.env`
- Default testnet .env location: `~/.abassian/testnet/.env`

### Client Env

See `example-client.env` for an example. You will need to create this `.env` file in the `DATA_DIR` location. Below is the explanation for each field.

```bash
# Network type: mainnet|testnet
NETWORK=mainnet

# Node type: client
NODE_TYPE=client

# Chain ID for the chain
CHAIN_ID=91

# Data directory where all gbas data will go
DATA_DIR=/home/root/.abassian/mainnet

# Port where the node will listen for other nodes trying to connect
LISTEN_PORT=30313

# Port for HTTP-RPC server
RPC_PORT=8515

# Port for WS-RPC server
WS_PORT=8516

# Comma-separated values for all the bootnodes
BOOTNODES=enode://60d1fbfcd46f79c7cb963192524d5ca763fdf843bc6c3791b5cf191503389a635dfb5dab9346f94854bd618df3d901e0dc2ecff722baf7b4e5769a702433cd3e@199.192.17.198:30305,enode://ecce13f0c5df7b64087a92049089b6c911b849c8be594d9b72e5784eabbfc7df6dbc633340e07c95d1f6eea4463838ec41e6d5ad8e285b4d04a61b4472f6ba55@199.192.21.138:30305

# Bootnode key if you are running a bootnode on this server (optional)
BOOTNODE_KEY=/home/root/.abassian/mainnet/boot.key

# Bootnode port where it will listen for incoming connections (optional)
BOOTNODE_PORT=30305
```

## Logging

The different log files are located at:

```text
/var/log/gbas/mainnet/gbas.log
/var/log/gbas/testnet/gbas.log
/var/log/gbas/mainnet/bootnode.log
/var/log/gbas/testnet/bootnode.log
```

### Setup Automatic Log Rotation

For adding automatic log rotations, create a new config file at `/etc/logrotate.d` and add the following.

```bash
$ sudo vim /etc/logrotate.d/abassian

# Paste the config below and save the file
/var/log/gbas/mainnet/gbas.log {
    missingok
    daily
    create 0644 syslog adm
    size 100M
    copytruncate
    maxage 14
    rotate 9
}
/var/log/gbas/mainnet/bootnode.log {
    missingok
    daily
    create 0644 syslog adm
    size 100M
    copytruncate
    maxage 14
    rotate 9
}
/var/log/gbas/testnet/gbas.log {
    missingok
    daily
    create 0644 syslog adm
    size 100M
    copytruncate
    maxage 14
    rotate 9
}
/var/log/gbas/testnet/bootnode.log {
    missingok
    daily
    create 0644 syslog adm
    size 100M
    copytruncate
    maxage 14
    rotate 9
}
```

## Services

After running the `init.sh` script, you will now have systemd service(s) added. These are the following services depending on your env config:

```bash
gbas_client_mainnet
gbas_client_testnet
bootnode_mainnet
bootnode_testnet
```

### Start Service

```bash
$ sudo systemctl start $SERVICE_NAME
```

### Stop Service

```bash
$ sudo systemctl stop $SERVICE_NAME
```

### Check Status

```bash
$ systemctl status $SERVICE_NAME
```

## Attach Gbas Console

```bash
$ cd scripts
$ ./attach.sh
```

## Updating static-nodes.json

```bash
$ cd scripts
$ ./update-static-nodes.sh
```
