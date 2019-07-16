#!/bin/sh
systemctl stop bootnode_mainnet
systemctl stop gbas_client_mainnet

rm -rf /root/.abassian/mainnet/gbas
rm -rf /root/.abassian/mainnet/keystore

cd /root/deployer.dev/scripts
./init.sh ~/.abassian/mainnet/.env

systemctl start bootnode_mainnet
systemctl start gbas_client_mainnet
