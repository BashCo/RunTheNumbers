#!/bin/bash

# You need to replace 'RPC_USERNAME' and 'RPC_PASSWORD' with the username and password in your bitcoin.conf file
USERNAME="RPC_USERNAME"
PASSWORD="RPC_PASSWORD"

IP_ADDRESS="127.0.0.1"
PORT="8332"

# This is the block height we're waiting for
TARGET_BLOCK="645000"

OUTPUT_FILE="the_numbers_${TARGET_BLOCK}.txt"

# We'll set this to zero so we can update the console only when there's a new block
LATEST_BLOCK="0"

# This will query your node repeatedly until the target block height is reached
while true
do
    # Check that USERNAME and PASSWORD are filled in
    if [ $USERNAME = "RPC_USERNAME" ] || [ $PASSWORD = "RPC_PASSWORD" ]; then
        echo "first you need to update the username and password located in the script header to match those in your bitcoin.conf file"
        exit
    fi

    # This fetches the current block height from your full node.
    CURRENT_BLOCK=$(curl -s --user "${USERNAME}":"${PASSWORD}" --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockcount", "params": [] }' -H 'content-type: text/plain;' http://${IP_ADDRESS}:${PORT}/ | python -c "import sys, json; print(json.load(sys.stdin)['result'])")

    # If the block height matches, call gettxoutsetinfo and print to file
    if [ $CURRENT_BLOCK = $TARGET_BLOCK ]; then
        echo "$CURRENT_BLOCK/$TARGET_BLOCK: running the numbers...";
        TXOUTSETINFO=$(curl -s --user "${USERNAME}":"${PASSWORD}" --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "gettxoutsetinfo", "params":[] }' -H 'content-type: text/plain;' http://${IP_ADDRESS}:${PORT}/ | python -c "import sys, json; parsed = json.load(sys.stdin)['result']; print(json.dumps(parsed, indent=2))")
        echo
        echo
        echo "${TXOUTSETINFO}"
        echo
        echo
        echo "${TXOUTSETINFO}" > "$OUTPUT_FILE"
        echo "congratulations, you have run the numbers. output saved to $OUTPUT_FILE"
        exit

    # If block height doesn't match yet, update console when a new block is found
    elif [ $CURRENT_BLOCK -lt $TARGET_BLOCK ] && [ $CURRENT_BLOCK -gt $LATEST_BLOCK ]; then
        LATEST_BLOCK=$CURRENT_BLOCK
        REMAINING=$(($TARGET_BLOCK - $CURRENT_BLOCK))
        BLOCKS="blocks"
        if [ $REMAINING = 1 ]; then
            BLOCKS="block"
        fi
        echo "$CURRENT_BLOCK/$TARGET_BLOCK: ${REMAINING} ${BLOCKS} remaining"

    # If block height has already passed, go home and do better next time
    elif [ $CURRENT_BLOCK -gt $TARGET_BLOCK ]; then
        echo "${TARGET_BLOCK} has already passed. current block is ${CURRENT_BLOCK}";
        exit

    fi

    # Query block height every n seconds
    sleep 5

done