#!/bin/sh
# Attaches gbas console to instance

MAINNET_IPC=$HOME/.abassian/mainnet/gbas.ipc
TESTNET_IPC=$HOME/.abassian/testnet/gbas.ipc

echo "Attach gbas"
echo "==========="
echo "Enter input:"
echo "1 for Mainnet"
echo "2 for Testnet"

read NETWORK
if [ "$NETWORK" = "1" ]; then
    gbas attach ipc:$MAINNET_IPC
elif [ "$NETWORK" = "2" ]; then
    gbas attach ipc:$TESTNET_IPC
else
    echo "Invalid network!"
fi
